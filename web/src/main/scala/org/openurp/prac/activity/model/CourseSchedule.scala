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
import org.beangle.commons.lang.reflect.Reflections
import org.beangle.commons.lang.time.WeekTime
import org.beangle.data.model.LongId
import org.beangle.data.model.pojo.{DateRange, Remark}
import org.openurp.base.model.User
import org.openurp.code.edu.model.TeachingMethod

import scala.collection.mutable

/** 课程活动的安排
 */
class CourseSchedule extends AbstractSchedule {
  var activity: CourseActivity = _
}
