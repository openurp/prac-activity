[#ftl]
[@b.head/]
[@b.toolbar title="课程模块"/]
[@base.semester_bar value=semester/]
<div class="search-container">
    <div class="search-panel">
    [@b.form name="searchForm" action="!search" target="activitylist" title="ui.searchForm" theme="search"]
      <input type="hidden" name="pracClazz.semester.id" value="${semester.id}"/>
      [@b.textfields names="pracClazz.courseName;课程名称"/]
      [@b.select name="pracClazz.department.id" items=departments empty="..." label="开课院系"/]

      [@b.date name="date" label="上课日期" maxDate=semester.endOn?string minDate=semester.beginOn?string/]
      <input type="hidden" name="orderBy" value="pracClazz.courseName"/>
    [/@]
    </div>
    <div class="search-list">
      [@b.div id="activitylist" href="!search?orderBy=pracClazz.courseName&pracClazz.semester.id="+semester.id/]
    </div>
  </div>
[@b.foot/]
