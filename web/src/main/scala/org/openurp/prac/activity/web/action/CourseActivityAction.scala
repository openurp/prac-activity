/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.prac.activity.web.action

import org.beangle.commons.lang.time.WeekTime
import org.beangle.data.dao.OqlBuilder
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.edu.code.model.CourseType
import org.openurp.base.model.Semester
import org.openurp.code.edu.model.TeachLangType
import org.openurp.prac.activity.model.{CourseActivity, CourseSchedule}
import org.openurp.starter.edu.helper.ProjectSupport

import java.time.LocalDate

class CourseActivityAction extends RestfulAction[CourseActivity] with ProjectSupport {

  override protected def indexSetting(): Unit = {
    val semester = getId("semester") match {
      case Some(sid) => entityDao.get(classOf[Semester], sid.toInt)
      case None => getCurrentSemester
    }
    put("semester", semester)
    put("project", getProject)
    put("departments", getDeparts)
    super.indexSetting()
  }

  protected override def getQueryBuilder: OqlBuilder[CourseActivity] = {
    val query = super.getQueryBuilder
    get("date", classOf[LocalDate]) foreach { date =>
      val wk = WeekTime.of(date)
      query.where("exists(from courseActivity.schedules as " +
        " cs where cs.weekTime.startOn=:startOn and bitand(cs.weekTime.weekstate,:weekstate)>0)", wk.startOn, wk.weekstate.value)
    }
    query
  }

  override protected def editSetting(entity: CourseActivity): Unit = {
    getInt("courseActivity.semester.id") foreach { semesterId =>
      entity.semester = entityDao.get(classOf[Semester], semesterId)
    }
    put("departments", getDeparts)
    put("courseTypes", getCodes(classOf[CourseType]))
    put("langTypes", getCodes(classOf[TeachLangType]))
    super.editSetting(entity)
  }

  override protected def saveAndRedirect(activity: CourseActivity): View = {
    activity.project = getProject
    if !activity.persisted then
      saveOrUpdate(activity)
      redirect("edit", "&id=" + activity.id.toString, "info.save.success")
    else
      super.saveAndRedirect(activity)
  }
}
