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
       [#list sn.days?sort as date]
       [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
       [#else]${date?string("d")}[/#if][#t]
       [#sep],[/#list][#t]
&nbsp;${sn.beginAt}~${sn.endAt}
   [#else]
     ${sn.beginOn?string("MM-dd")}~${sn.endOn?string("MM-dd")} ${sn.times!}
   [/#if]
   ${sn.places!}
[/#list]
[/#macro]
[@b.grid items=courseActivities var="courseActivity"]
  [@b.gridbar]
    bar.addItem("${b.text("action.new")}",action.add());
    bar.addItem("${b.text("action.modify")}",action.edit());
    bar.addItem("${b.text("action.delete")}",action.remove("确认删除?"));
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col width="15%" property="courseName" title="课程名称"]
      <span title="${(courseActivity.courseType.name)!}">${courseActivity.courseName}</span>
    [/@]
    [@b.col property="department.name" width="60px" title="开课院系"]
      [@display courseActivity.department.shortName!courseActivity.department.name 60/]
    [/@]
    [@b.col width="10%" title="授课教师"]
      [#list courseActivity.teachers as t]${t.name}[#sep]&nbsp;[/#list]
      ${(courseActivity.externTeacher)!}
    [/@]
    [@b.col width="8%" property="langType.name" title="授课语言"]${courseActivity.langType.name}[/@]
    [@b.col width="10%" property="clazzName" title="教学班"]${courseActivity.clazzName}[/@]
    [@b.col title="课程安排"]
       [#assign courseSchedule][@schedule courseActivity/][/#assign]
       ${courseSchedule}
    [/@]
    [@b.col width="5%" property="stdCount" title="人数"]${courseActivity.stdCount}[/@]
  [/@]
[/@]
[@b.foot/]
