[#ftl]
[@b.head/]
[#include "../stdPracticeHour/nav.ftl"/]
<div class="search-container">
  <div class="search-panel">
      [@b.form name="stdGradeSearchForm" action="!search" title="查询条件" target="contentDiv" theme="search"]
        [@b.textfield name="stdPracticeInfo.std.code" maxlength="999999" label="学号"/]
        [@b.textfields names="stdPracticeInfo.std.name;姓名,stdPracticeInfo.std.state.grade.code;就读年级"/]
        [@b.select name="stdPracticeInfo.std.level.id" items=levels  label="培养层次" empty="..." style="width:6.25rem"/]
        [@b.select name="stdPracticeInfo.std.state.department.id" items=departs label="院系" empty="..." style="width:6.25rem"/]
        [@b.select name="stdPracticeInfo.category.id" items=categories  label="大类" empty="..."/]
      [/@]
  </div>
  <div class="search-list">
   [@b.div id="contentDiv" href="!search"/]
  </div>
</div>
[@b.foot/]
