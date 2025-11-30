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

package org.openurp.prac.activity.service.impl

import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.openurp.base.service.SemesterService
import org.openurp.code.edu.model.{CourseTakeType, GradingMode}
import org.openurp.edu.grade.model.{CourseGrade, Grade}
import org.openurp.edu.grade.service.GradeRateService
import org.openurp.edu.program.domain.CoursePlanProvider
import org.openurp.prac.activity.model.StdPracticeHour
import org.openurp.prac.activity.service.StdPracticeService

import java.time.{Instant, ZoneId}

class StdPracticeServiceImpl extends StdPracticeService {
  var entityDao: EntityDao = _
  var planProvider: CoursePlanProvider = _
  var gradeRateService: GradeRateService = _
  var semesterService: SemesterService = _

  def stat(h: StdPracticeHour): Unit = {
    planProvider.getCoursePlan(h.std) foreach { plan =>
      val pc = plan.planCourses.find { p =>
        var courseName = p.course.name
        if (courseName.contains("（")) {
          courseName = Strings.substringBefore(courseName, "（")
        }
        courseName == h.category.name
      }
      pc foreach { c =>
        h.requiredHours = c.course.creditHours
        entityDao.saveOrUpdate(h)
        if (h.requiredHours <= h.hours) {
          val existed = entityDao.findBy(classOf[CourseGrade], "std" -> h.std, "course" -> c.course).headOption
          existed match
            case Some(g) =>
              if (h.courseGradeId.isEmpty) {
                g.provider = Some(s"${h.id}@StdPracticeHour")
                h.courseGradeId = Some(g.id)
                entityDao.saveOrUpdate(g, h)
              }
            case None =>
              val g = new CourseGrade
              g.project = h.std.project
              g.std = h.std
              g.course = c.course
              g.courseType = c.group.courseType
              g.courseTakeType = new CourseTakeType()
              g.courseTakeType.id = CourseTakeType.Normal
              g.updatedAt = h.updatedAt
              g.createdAt = Instant.now
              g.gradingMode = new GradingMode(GradingMode.TwoLevel)
              val converter = gradeRateService.getConverter(g.project, g.gradingMode)
              g.score = Some(90f)
              g.scoreText = converter.convert(g.score)
              g.gp = converter.calcGp(g.score)
              g.crn = "--"
              g.semester = semesterService.get(h.std.project, h.updatedAt.atZone(ZoneId.systemDefault()).toLocalDate)
              g.provider = Some(s"${h.id}@StdPracticeHour")
              g.examMode = c.course.examMode
              g.passed = true
              g.status = Grade.Status.Published
              g.operator = Some("系统自动产生")
              entityDao.saveOrUpdate(g)
              h.courseGradeId = Some(g.id)
              entityDao.saveOrUpdate(h)
        }
      }
    }
  }
}
