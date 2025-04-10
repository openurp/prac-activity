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

import org.beangle.commons.cdi.BindModule
import org.openurp.prac.activity.service.AutoStatPracticeHourJob
import org.openurp.prac.activity.service.impl.StdPracticeServiceImpl
import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler
import org.springframework.scheduling.config.{CronTask, ScheduledTaskRegistrar}

class DefaultModule extends BindModule {
  override protected def binding(): Unit = {
    bind(classOf[PracClazzAction], classOf[PracClazzScheduleAction])
    bind(classOf[PracActivityAction], classOf[PracActivityScheduleAction])

    bind(classOf[StdPracticeHourAction], classOf[StdPracticeInfoAction])
    bind(classOf[StdPracticeServiceImpl])

    bind(classOf[std.PracticeHourAction])

    bind(classOf[ConcurrentTaskScheduler])
    bind(classOf[ScheduledTaskRegistrar]).nowire("triggerTasks", "triggerTasksList")
    bind(classOf[AutoStatPracticeHourJob]).lazyInit(false)
    bindTask(classOf[AutoStatPracticeHourJob], "0 0 7,10,13,16,19 * * *") //every three hours
  }

  protected def bindTask[T <: Runnable](clazz: Class[T], expression: String): Unit = {
    val taskName = clazz.getName
    bind(taskName + "Task", classOf[CronTask]).constructor(ref(taskName), expression).lazyInit(false)
  }
}
