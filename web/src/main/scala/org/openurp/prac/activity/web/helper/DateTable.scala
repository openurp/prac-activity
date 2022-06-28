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

package org.openurp.prac.activity.web.helper

import org.openurp.base.model.Semester
import org.openurp.prac.activity.model.{AbstractSchedule, CourseActivity}

import java.time.LocalDate
import scala.collection.mutable

object DateTable {

  def weekdates(semester: Semester, index: Int): Iterable[LocalDate] = {
    val beginOn = semester.beginOn
    val endDay = semester.calendar.firstWeekday.previous
    var start = beginOn.plusDays(7 * (index - 1))
    val rs = new mutable.ArrayBuffer[LocalDate]
    while (start.getDayOfWeek.getValue != endDay.id) {
      rs.addOne(start)
      start = start.plusDays(1)
    }
    rs
  }

  def apply(from: LocalDate, to: LocalDate, datas: collection.Map[LocalDate, collection.Seq[AbstractSchedule]]): Iterable[DateTable] = {
    if to.isBefore(from) then return List.empty
    var start = from
    val rs = new mutable.ArrayBuffer[DateTable]
    while (!to.isBefore(start)) {
      if datas.contains(start) then
        rs.addOne(DateTable(start, datas(start).sortBy(x=> x.weekTime.beginAt)))
      start = start.plusDays(1)
    }
    rs
  }
}

case class DateTable(date: LocalDate, schedules: Iterable[AbstractSchedule]) {

}
