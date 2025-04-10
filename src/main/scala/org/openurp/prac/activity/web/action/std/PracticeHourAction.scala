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

package org.openurp.prac.activity.web.action.std

import org.beangle.webmvc.view.View
import org.openurp.base.std.model.Student
import org.openurp.prac.activity.model.{StdPracticeHour, StdPracticeInfo}
import org.openurp.starter.web.support.StudentSupport

class PracticeHourAction extends StudentSupport{

  override protected def projectIndex(std: Student): View = {
    val infoes = entityDao.findBy(classOf[StdPracticeInfo],"std",std).groupBy(_.category)
    val hours = entityDao.findBy(classOf[StdPracticeHour],"std",std).groupBy(_.category).map(x=>(x._1,x._2.head))
    put("infoes",infoes)
    put("hours",hours)
    put("categories",infoes.keys)
    forward()
  }
}
