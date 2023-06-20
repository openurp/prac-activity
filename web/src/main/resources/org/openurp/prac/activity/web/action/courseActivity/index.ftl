[#ftl]
[@b.head/]
[@b.toolbar title="课程模块"/]
[@base.semester_bar value=semester/]
<div class="search-container">
    <div class="search-panel">
    [@b.form name="searchForm" action="!search" target="activitylist" title="ui.searchForm" theme="search"]
      <input type="hidden" name="courseActivity.semester.id" value="${semester.id}"/>
      [@b.textfields names="courseActivity.courseName;课程名称"/]
      [@b.select name="courseActivity.department.id" items=departments empty="..." label="开课院系"/]

      [@b.datepicker name="date" label="上课日期" maxDate=semester.endOn?string minDate=semester.beginOn?string/]
      <input type="hidden" name="orderBy" value="courseActivity.courseName"/>
    [/@]
    </div>
    <div class="search-list">
      [@b.div id="activitylist" href="!search?orderBy=courseActivity.courseName&courseActivity.semester.id="+semester.id/]
    </div>
  </div>
[@b.foot/]
