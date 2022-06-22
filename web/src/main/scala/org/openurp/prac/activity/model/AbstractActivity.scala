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
import org.beangle.data.model.LongId
import org.openurp.base.model.{Department, Project, Semester, User}

import scala.collection.mutable

abstract class AbstractActivity extends LongId {
  /** 项目 */
  var project: Project = _
  /** 学期 */
  var semester: Semester = _
  /** 开课院系 */
  var department: Department = _
  /** 学分 */
  var credits: Option[Float] = None
  /** 授课教师 */
  var teachers: mutable.Buffer[User] = Collections.newBuffer[User]
  /** 外校教师 */
  var externTeacher: Option[String] = None
  /** 实际人数 */
  var stdCount: Int = _

  /** 会话列表 */
  var schedules: mutable.Buffer[AbstractSchedule] = Collections.newBuffer[AbstractSchedule]

  def merge(): Unit = {
    val copyed = Collections.newBuffer(schedules)
    copyed foreach { ns =>
      schedules filter (x => x.weekTime.beginAt.value > 0 &&
        x.weekTime.beginAt == ns.weekTime.beginAt &&
        x.weekTime.startOn == ns.weekTime.startOn &&
        x.id != ns.id) foreach { e =>
        if ns.teachers == e.teachers && ns.externTeacher == e.externTeacher && ns.places == e.places then
          e.mergeWith(ns)
          schedules.subtractOne(ns)
      }
    }
  }

  def sessions: Iterable[Session] = {
    val map = Collections.newMap[String, Session]
    schedules foreach { s =>
      val key =
        if s.weekTime == null then s.beginOn.toString + s.places
        else s.weekTime.beginAt.toString() + s.weekTime.endAt.toString() + s.places
      map.get(key) match
        case Some(e) => if (s.weekTime != null) e.add(s.weekTime)
        case None =>
          val e = new Session(s.beginOn, s.endOn)
          e.times = s.times
          e.places = s.places
          map.put(key, e)
          if s.weekTime != null then
            e.add(s.weekTime)
    }
    map.values.toBuffer.sortBy(_.beginOn)
  }
}
