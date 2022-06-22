[@b.head/]
[@b.toolbar title="维护课程模块"] bar.addBack();[/@]
<div class="container">
  <div class="row">
    <div  [#if pracActivity.persisted]class="col-5"[#else]class="col-12"[/#if]>
    [@b.form action=b.rest.save(pracActivity) theme="list"]
       [@b.field label="学年学期"]${pracActivity.semester.schoolYear}学年${pracActivity.semester.name}学期[/@]
       [@b.textfield name="pracActivity.activityName" value=pracActivity.activityName! label="活动名称" style="width:250px" required="true" maxlength="300"/]
       [@b.select name="pracActivity.department.id" value=pracActivity.department! items=departments label="实施主体" required="true"/]
       [@b.select name="pracActivity.activityType.id" value=pracActivity.activityType! items=activityTypes label="活动性质" width="200px" required="true"/]
       [@b.number name="pracActivity.stdCount" value=pracActivity.stdCount! label="人数" required="true" max="10000"/]
       [@b.textfield name="pracActivity.credits" value=pracActivity.credits! label="学分" required="false"/]
       [@b.textarea name="pracActivity.description" value=pracActivity.description! required="true" maxlength="500" cols="30" rows="5" label="描述"/]
       [@b.formfoot]
          <input type="hidden" name="pracActivity.semester.id" value="${pracActivity.semester.id}"/>
          [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
       [/@]
    [/@]
    </div>
    [#if pracActivity.persisted]
    <div class="col-7" style="border-left: solid 1px burlywood;">
    [@b.div href="prac-schedule!search?pracSchedule.activity.id=${pracActivity.id}"/]
    </div>
    [/#if]
  </div>
</div>
[@b.foot/]
