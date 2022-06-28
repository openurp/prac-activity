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

package org.openurp.prac.activity.model

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.time.{HourMinute, WeekTime}
import org.beangle.data.model.pojo.DateRange

import java.time.LocalDate

/**
 * 表示一次连续的时间安排，不论时间是否按周分布
 * @param beginOn
 * @param endOn
 */
class Session(var beginOn: LocalDate, var endOn: LocalDate) {

  var days = Collections.newSet[LocalDate]

  var beginAt: HourMinute = _

  var endAt: HourMinute = _

  var times: Option[String] = None

  var places: String = _

  def add(wt: WeekTime): Unit = {
    if (wt.weekstate.value != 0) {
      if wt.firstDay.isBefore(beginOn) then this.beginOn = wt.firstDay
      if wt.lastDay.isAfter(endOn) then this.endOn = wt.lastDay
      days ++= wt.dates
      beginAt = wt.beginAt
      endAt = wt.endAt
    }
  }
}
