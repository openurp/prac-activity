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
import org.beangle.webmvc.support.action.{ExportSupport, RestfulAction}
import org.openurp.base.model.{Project, Semester}
import org.openurp.prac.activity.model.{ActivityType, PracActivity}
import org.openurp.starter.web.support.ProjectSupport

import java.time.LocalDate

class PracActivityAction extends RestfulAction[PracActivity], ExportSupport[PracActivity], ProjectSupport {

  override protected def indexSetting(): Unit = {
    given project: Project = getProject

    put("semester", getSemester)
    put("project", project)
    put("departments", getDeparts)
    super.indexSetting()
  }

  protected override def getQueryBuilder: OqlBuilder[PracActivity] = {
    val query = super.getQueryBuilder
    get("date", classOf[LocalDate]) foreach { date =>
      val wk = WeekTime.of(date)
      query.where("exists(from pracActivity.schedules as " +
        " cs where cs.weekTime.startOn=:startOn and bitand(cs.weekTime.weekstate,:weekstate)>0)", wk.startOn, wk.weekstate.value)
    }
    query
  }

  override protected def editSetting(entity: PracActivity): Unit = {
    given project: Project = getProject

    getInt("pracActivity.semester.id") foreach { semesterId =>
      entity.semester = entityDao.get(classOf[Semester], semesterId)
    }
    put("departments", getDeparts)
    put("activityTypes", getCodes(classOf[ActivityType]))
    super.editSetting(entity)
  }

  override protected def saveAndRedirect(activity: PracActivity): View = {
    activity.project = getProject
    if !activity.persisted then
      saveOrUpdate(activity)
      redirect("edit", "&id=" + activity.id.toString, "info.save.success")
    else
      super.saveAndRedirect(activity)
  }
}
