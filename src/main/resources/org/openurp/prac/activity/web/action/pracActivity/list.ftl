[@b.head/]
[#macro display contents width]
 <div style="overflow: hidden;text-overflow: ellipsis;width: ${width}px;display: inline-block;white-space: nowrap;">
    ${contents}
 </div>
[/#macro]

[#macro schedule activity]
[#list activity.sessions as sn]
   [#if sn.beginAt?? && sn.beginAt.value>0]
       [#assign thisMonth="--"]
       [#list sn.dates?sort as date]
       [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
       [#else]${date?string("d")}[/#if][#t]
       [#sep],[/#list][#t]
&nbsp;${sn.beginAt}~${sn.endAt}
   [#else]
     ${sn.beginOn?string("MM-dd")}~${sn.endOn?string("MM-dd")} ${sn.times!}
   [/#if]
   ${sn.places!}
   [#if sn_has_next]<br>[/#if]
[/#list]
[/#macro]
[@b.grid items=pracActivities var="pracActivity"]
  [@b.gridbar]
    bar.addItem("${b.text("action.new")}",action.add());
    bar.addItem("${b.text("action.modify")}",action.edit());
    bar.addItem("${b.text("action.delete")}",action.remove("确认删除?"));
    bar.addItem("${b.text('action.export')}",action.exportData("activityType.name:活动性质,activityName:活动名称,department.name:实施主体,teacherNames:授课教师,scheduleContent:课程安排,stdCount:人数,description:描述",null,'fileName=实践项目'));
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col width="15%" property="activityName" title="活动名称"]
      <span title="${(pracActivity.activityType.name)!}">${pracActivity.activityName}</span>
    [/@]
    [@b.col property="department.name" width="60px" title="实施主体"]
      [@display pracActivity.department.shortName!pracActivity.department.name 60/]
    [/@]
    [@b.col width="10%" title="授课教师"]
      [#list pracActivity.teachers as t]${t.name}[#sep]&nbsp;[/#list]
      ${(pracActivity.externTeacher)!}
    [/@]
    [@b.col title="课程安排"]
       [#assign pracSchedule][@schedule pracActivity/][/#assign]
       ${pracSchedule}
    [/@]
    [@b.col width="5%" property="stdCount" title="人数"]${pracActivity.stdCount}[/@]
  [/@]
[/@]
[@b.foot/]
