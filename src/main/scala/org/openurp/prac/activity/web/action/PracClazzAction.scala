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

import org.beangle.commons.lang.time.{WeekTime, Weeks}
import org.beangle.data.dao.OqlBuilder
import org.beangle.webmvc.view.View
import org.beangle.webmvc.support.action.{ExportSupport, RestfulAction}
import org.openurp.base.model.{Project, Semester}
import org.openurp.code.edu.model.{CourseType, TeachLangType}
import org.openurp.prac.activity.model.{AbstractPracSchedule, PracClazz}
import org.openurp.prac.activity.web.helper.DateTable
import org.openurp.starter.web.support.ProjectSupport

import java.time.LocalDate
import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer

class PracClazzAction extends RestfulAction[PracClazz], ExportSupport[PracClazz], ProjectSupport {

  def datetables(): View = {
    val semesterId = getIntId("pracClazz.semester")
    val semester = entityDao.get(classOf[Semester], semesterId)
    val fromWeek = getInt("fromWeek", 1)
    val toWeek = getInt("toWeek", Weeks.between(semester.beginOn, semester.endOn))
    val query = OqlBuilder.from(classOf[PracClazz], "a")
    query.where("a.project=:project and a.semester=:semester", getProject, semester)
    val activities = entityDao.search(query)
    val schedules = new mutable.HashMap[LocalDate, mutable.Buffer[AbstractPracSchedule]]
    for (activity <- activities; schedule <- activity.schedules; date <- schedule.weekTime.dates) {
      val ac = schedules.getOrElseUpdate(date, new mutable.ArrayBuffer[AbstractPracSchedule])
      ac.addOne(schedule)
    }
    val dateTables = new mutable.ArrayBuffer[DateTable]
    (fromWeek to toWeek) foreach { i =>
      val weekdates = DateTable.weekdates(semester, i)
      dateTables ++= DateTable.apply(weekdates.head, weekdates.last, schedules)
    }
    put("dateTables", dateTables)
    forward()
  }

  override protected def indexSetting(): Unit = {
    given project: Project = getProject

    put("semester", getSemester)
    put("project", project)
    put("departments", getDeparts)
    super.indexSetting()
  }

  protected override def getQueryBuilder: OqlBuilder[PracClazz] = {
    val query = super.getQueryBuilder
    get("date", classOf[LocalDate]) foreach { date =>
      val wk = WeekTime.of(date)
      query.where("exists(from pracClazz.schedules as " +
        " cs where cs.weekTime.startOn=:startOn and bitand(cs.weekTime.weekstate,:weekstate)>0)", wk.startOn, wk.weekstate.value)
    }
    query
  }

  override protected def editSetting(entity: PracClazz): Unit = {
    given project: Project = getProject

    getInt("pracClazz.semester.id") foreach { semesterId =>
      entity.semester = entityDao.get(classOf[Semester], semesterId)
    }
    put("departments", getDeparts)
    put("courseTypes", getCodes(classOf[CourseType]))
    put("langTypes", getCodes(classOf[TeachLangType]))
    super.editSetting(entity)
  }

  override protected def saveAndRedirect(activity: PracClazz): View = {
    activity.project = getProject
    if !activity.persisted then
      saveOrUpdate(activity)
      redirect("edit", "&id=" + activity.id.toString, "info.save.success")
    else
      super.saveAndRedirect(activity)
  }
}
