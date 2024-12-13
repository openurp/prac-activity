[#ftl]
[@b.head/]
[@b.grid items=stdPracticeHours var="stdPracticeHour" ]
  [@b.gridbar]
    bar.addItem("统计完成情况",action.multi("stat"));
    bar.addItem("${b.text('action.export')}",action.exportData("std.code:学号,"+
                "std.name:姓名,std.state.grade.code:年级,std.level.name:培养层次,std.state.department.name:院系,"+
                "std.state.major.name:专业,category.name:大类,hours:学时",null,'fileName=学生实践学时统计'));
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col property="std.code" title="学号" width="8%"/]
    [@b.col property="std.name" title="姓名" width="10%"]
      <div title="${stdPracticeHour.std.name}" class="text-ellipsis">
        ${stdPracticeHour.std.name}
      </div>
    [/@]
    [@b.col property="std.state.grade.code" title="年级" width="8%"/]
    [@b.col property="std.level.name" title="培养层次" width="8%"/]
    [@b.col property="std.state.department.name" title="院系" width="16%"/]
    [@b.col property="std.state.major.name" title="专业" width="16%"/]
    [@b.col property="category.name" title="大类" /]
    [@b.col property="requiredHours" title="要求学时" width="7%"/]
    [@b.col property="hours" title="完成学时" width="7%"]
      ${stdPracticeHour.hours}
      [#if stdPracticeHour.requiredHours>0]
      <span class="inlinepie" values="${stdPracticeHour.hours},[#if stdPracticeHour.hours>stdPracticeHour.requiredHours]0[#else]${stdPracticeHour.requiredHours-stdPracticeHour.hours}[/#if]"></span>
      [/#if]
    [/@]
    [@b.col title="认定成绩"  width="7%"]
      [#if stdPracticeHour.courseGradeId??]已认定[#else]未认定[/#if]
    [/@]
  [/@]
[/@]
<script>
beangle.register("${b.base}/static/",{
  "sparkline":{js:"js/jquery.sparkline.min.js"}
});
bg.load(["sparkline"],function(){
  jQuery(document).ready(function(){
    $('.inlinepie').sparkline('html', {type: 'pie',sliceColors:['green','red']});
  });
});
</script>
[@b.foot/]
