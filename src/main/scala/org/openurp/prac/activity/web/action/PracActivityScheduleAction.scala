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

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.commons.lang.time.{HourMinute, WeekState, WeekTime}
import org.beangle.ems.app.Ems
import org.beangle.webmvc.support.action.RestfulAction
import org.beangle.webmvc.view.View
import org.openurp.base.model.{Project, User}
import org.openurp.code.edu.model.TeachingMethod
import org.openurp.prac.activity.model.{PracActivity, PracActivitySchedule}
import org.openurp.starter.web.support.ProjectSupport

import java.time.LocalDate
import java.time.temporal.ChronoUnit

class PracActivityScheduleAction extends RestfulAction[PracActivitySchedule], ProjectSupport {
  override def search(): View = {
    val query = super.getQueryBuilder
    get("pracActivitySchedule.activity.id") match {
      case Some(id) =>
        query.limit(null)
        var schedules = entityDao.search(query)
        schedules = schedules.sortBy(x => (if null == x.weekTime then "0" else x.weekTime.beginAt.toString) + x.beginOn.toString)
        put("pracActivitySchedules", schedules)
        forward()
      case None =>
        super.search()
    }
  }

  override protected def editSetting(schedule: PracActivitySchedule): Unit = {
    given project: Project = getProject

    schedule.activity = entityDao.get(classOf[PracActivity], schedule.activity.id)
    val semester = schedule.activity.semester
    put("semester", semester)
    val months = Math.ceil(semester.beginOn.until(semester.endOn, ChronoUnit.DAYS) / 30.0)
    put("months", months)

    if (!schedule.persisted) {
      schedule.beginOn = semester.beginOn
      schedule.endOn = semester.endOn
    }
    put("teachingMethods", getCodes(classOf[TeachingMethod]))
    put("urp", Ems)
    super.editSetting(schedule)
  }

  override protected def saveAndRedirect(schedule: PracActivitySchedule): View = {
    val activity = entityDao.get(classOf[PracActivity], schedule.activity.id)
    schedule.teachers.clear();
    schedule.teachers ++= entityDao.find(classOf[User], getAll("teacherUserId", classOf[Long]))

    getBoolean("time_style") foreach { timeStyle =>
      if (timeStyle)
        schedule.times = None
        val weektimeMap = Collections.newMap[LocalDate, WeekTime]
        val days = Strings.split(get("days").get)
        for (day <- days) {
          val date = LocalDate.parse(day)
          val wt = WeekTime.of(date)
          weektimeMap.get(wt.startOn) match {
            case Some(existed) => existed.weekstate |= wt.weekstate
            case None => weektimeMap.put(wt.startOn, wt)
          }
        }
        val beginAt = HourMinute.apply(get("beginAt").get)
        val endAt = HourMinute.apply(get("endAt").get)
        val weektimes = weektimeMap.values.toBuffer
        weektimes foreach { wt =>
          wt.beginAt = beginAt
          wt.endAt = endAt
        }
        schedule.updateTime(weektimes.head)
        weektimes.tail foreach { wt =>
          activity.addSchedule(schedule.copyOn(wt))
        }
      else
        if (schedule.weekTime == null) schedule.weekTime = new WeekTime
        schedule.weekTime.weekstate = WeekState.Zero
        schedule.weekTime.beginAt = HourMinute.Zero
        schedule.weekTime.endAt = HourMinute.Zero
        schedule.weekTime.startOn = schedule.beginOn
    }
    if (!schedule.persisted) activity.addSchedule(schedule)
    saveOrUpdate(activity)
    activity.merge()

    val teachers = Collections.newSet[User]
    val external = Collections.newSet[String]
    activity.schedules foreach { s =>
      teachers.addAll(s.teachers)
      s.externTeacher foreach { et =>
        val ets = Strings.replace(et, "、", ",")
        external.addAll(Strings.split(ets))
      }
    }
    activity.teachers.clear()
    activity.externTeacher = None

    activity.teachers.addAll(teachers)
    if external.nonEmpty then activity.externTeacher = Some(external.mkString("、"))
    entityDao.saveOrUpdate(activity)
    redirect("search", "info.save.success")
  }
}
