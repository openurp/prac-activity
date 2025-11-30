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

package org.openurp.prac.activity.service

import org.beangle.commons.logging.Logging
import org.beangle.data.dao.OqlBuilder
import org.beangle.data.orm.hibernate.AbstractDaoTask
import org.openurp.prac.activity.model.StdPracticeHour

class AutoStatPracticeHourJob extends AbstractDaoTask, Logging {
  var stdPracticeService: StdPracticeService = _

  def execute(): Unit = {
    val q = OqlBuilder.from(classOf[StdPracticeHour], "h")
    q.where("(h.requiredHours>0 and h.requiredHours<=h.hours) or h.requiredHours=0")
    q.where("h.courseGradeId is null")

    val hours = entityDao.search(q)
    if (hours.nonEmpty) {
      logger.info(s"auto generate grade for ${hours.size} practice infoes")
    }
    hours foreach { h =>
      stdPracticeService.stat(h)
    }
  }
}
