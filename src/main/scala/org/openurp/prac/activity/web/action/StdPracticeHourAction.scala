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

import org.beangle.data.dao.OqlBuilder
import org.beangle.webmvc.support.action.{ExportSupport, RestfulAction}
import org.beangle.webmvc.view.View
import org.openurp.base.model.Project
import org.openurp.code.prac.model.StdPracticeCategory
import org.openurp.prac.activity.model.StdPracticeHour
import org.openurp.prac.activity.service.StdPracticeService
import org.openurp.starter.web.support.ProjectSupport

class StdPracticeHourAction extends RestfulAction[StdPracticeHour], ProjectSupport, ExportSupport[StdPracticeHour] {

  var stdPracticeService: StdPracticeService = _

  override def indexSetting(): Unit = {
    super.indexSetting()

    given project: Project = getProject

    put("levels", project.levels)
    put("departs", getDeparts)
    put("categories", getCodes(classOf[StdPracticeCategory]))
  }

  def stat(): View = {
    val hours = entityDao.find(classOf[StdPracticeHour], getLongIds("stdPracticeHour"))
    hours foreach { h =>
      stdPracticeService.stat(h)
    }
    redirect("search", "统计完成")
  }

  override def getQueryBuilder: OqlBuilder[StdPracticeHour] = {
    val query = super.getQueryBuilder
    getBoolean("complete") foreach { complete =>
      if (complete) query.where("stdPracticeHour.requiredHours >0 and stdPracticeHour.requiredHours<=stdPracticeHour.hours")
      else query.where("stdPracticeHour.requiredHours>stdPracticeHour.hours")
    }
    query
  }
}
