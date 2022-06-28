[@b.head/]
<div class="container-fluid">
[#list dateTables?sort_by('date') as dateTable]
  <p style="text-align:center;margin-bottom:0px">课程模块${dateTable.date}(${dateTable.date?string('E')})</p>
  [@b.grid items=dateTable.schedules var="schedule" style="border:0.5px solid #006CB2" sortable="false"]
    [@b.row]
      [@b.col width="5%" title="序号"]${schedule_index+1}[/@]
      [@b.col width="20%" property="courseName" title="课程名称"]
        ${schedule.activity.courseName}
      [/@]
      [@b.col property="department.name" width="10%" title="开课院系"]
        ${schedule.activity.department.name}
      [/@]
      [@b.col width="10%" title="授课教师"]
        [#list schedule.teachers as t]${t.name}[#sep]&nbsp;[/#list]
        ${(schedule.externTeacher)!}
      [/@]
      [@b.col width="12%" title="课程类别"]
        ${(schedule.activity.courseType.name)!}
      [/@]
      [@b.col width="5%" property="langType.name" title="授课语言"]${schedule.activity.langType.name}[/@]
      [@b.col width="10%" property="clazzName" title="教学班"]${schedule.activity.clazzName}[/@]
      [@b.col title="时间安排"  width="10%"]
         ${schedule.weekTime.beginAt}~${schedule.weekTime.endAt}
      [/@]
      [@b.col title="教室安排" property="places"  width="13%"/]
      [@b.col width="5%" property="stdCount" title="人数"]${schedule.activity.stdCount}[/@]
    [/@]
  [/@]
[/#list]
</div>
[@b.foot/]
