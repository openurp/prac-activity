[#ftl]
[@b.head/]
[#include "nav.ftl"/]
<div class="search-container">
  <div class="search-panel">
      [@b.form name="stdGradeSearchForm" action="!search" title="查询条件" target="contentDiv" theme="search"]
        [@b.textfield name="stdPracticeHour.std.code" maxlength="999999" label="学号"/]
        [@b.textfields names="stdPracticeHour.std.name;姓名,stdPracticeHour.std.state.grade.code;就读年级"/]
        [@b.select name="stdPracticeHour.std.level.id" items=levels  label="培养层次" empty="..." style="width:6.25rem"/]
        [@b.select name="stdPracticeHour.std.state.department.id" items=departs label="院系" empty="..." style="width:6.25rem"/]
        [@b.select name="stdPracticeHour.category.id" items=categories  label="大类" empty="..."/]
        [@b.select style="width:100px" name="complete" label="是否完成" items={"1":"是", "0":"否"} empty="..." /]
      [/@]
  </div>
  <div class="search-list">
   [@b.div id="contentDiv" href="!search"/]
  </div>
</div>
[@b.foot/]
