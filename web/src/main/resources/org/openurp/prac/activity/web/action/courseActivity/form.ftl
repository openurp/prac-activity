[@b.head/]
[@b.toolbar title="维护课程模块"] bar.addBack();[/@]
<div class="container">
  <div class="row">
    <div  [#if courseActivity.persisted]class="col-5"[#else]class="col-12"[/#if]>
    [@b.form action=b.rest.save(courseActivity) theme="list"]
       [@b.field label="学年学期"]${courseActivity.semester.schoolYear}学年${courseActivity.semester.name}学期[/@]
       [@b.textfield name="courseActivity.courseName" value=courseActivity.courseName! label="课程名称" style="width:250px" required="true" maxlength="300"/]
       [@b.select name="courseActivity.department.id" value=courseActivity.department! items=departments label="开课院系" required="true"/]
       [@b.select name="courseActivity.courseType.id" value=courseActivity.courseType! items=courseTypes label="课程类别" width="200px" required="false"/]
       [@b.textfield name="courseActivity.clazzName" value=courseActivity.clazzName! label="教学班" required="true"/]
       [@b.select name="courseActivity.langType.id" value=courseActivity.langType! items=langTypes label="授课语言" required="true"/]
       [@b.number name="courseActivity.stdCount" value=courseActivity.stdCount! label="人数" required="true" max="10000"/]
       [@b.textfield name="courseActivity.credits" value=courseActivity.credits! label="学分" required="false"/]
       [@b.formfoot]
          <input type="hidden" name="courseActivity.semester.id" value="${courseActivity.semester.id}"/>
          [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
       [/@]
    [/@]
    </div>
    [#if courseActivity.persisted]
    <div class="col-7" style="border-left: solid 1px burlywood;">
    [@b.div href="course-schedule!search?courseSchedule.activity.id=${courseActivity.id}"/]
    </div>
    [/#if]
  </div>
</div>
[@b.foot/]
