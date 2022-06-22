[#ftl]
[@b.head/]
[@b.toolbar title="实践项目"/]
[@urp_base.semester_bar value=semester/]
<div class="search-container">
    <div class="search-panel">
    [@b.form name="searchForm" action="!search" target="activitylist" title="ui.searchForm" theme="search"]
      <input type="hidden" name="pracActivity.semester.id" value="${semester.id}"/>
      [@b.textfields names="pracActivity.activityName;活动名称"/]
      [@b.select name="pracActivity.department.id" items=departments empty="..." label="实施主体"/]

      [@b.datepicker name="date" label="上课日期" maxDate=semester.endOn?string minDate=semester.beginOn?string/]
      <input type="hidden" name="orderBy" value="pracActivity.activityName"/>
    [/@]
    </div>
    <div class="search-list">
      [@b.div id="activitylist" href="!search?orderBy=pracActivity.activityName&pracActivity.semester.id="+semester.id/]
    </div>
  </div>
[@b.foot/]
