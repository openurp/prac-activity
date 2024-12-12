[@b.head/]
[@b.toolbar title="维护课程模块"] bar.addBack();[/@]
<div>
  <div class="row">
    <div  [#if pracClazz.persisted]class="col-5"[#else]class="col-12"[/#if]>
    [@b.form action=b.rest.save(pracClazz) theme="list"]
       [@b.field label="学年学期"]${pracClazz.semester.schoolYear}学年${pracClazz.semester.name}学期[/@]
       [@b.textfield name="pracClazz.courseName" value=pracClazz.courseName! label="课程名称" style="width:250px" required="true" maxlength="300"/]
       [@b.select name="pracClazz.department.id" value=pracClazz.department! items=departments label="开课院系" required="true"/]
       [@b.select name="pracClazz.courseType.id" value=pracClazz.courseType! items=courseTypes label="课程类别" width="200px" required="false"/]
       [@b.textfield name="pracClazz.clazzName" value=pracClazz.clazzName! label="教学班" required="true"/]
       [@b.select name="pracClazz.langType.id" value=pracClazz.langType! items=langTypes label="授课语言" required="true"/]
       [@b.number name="pracClazz.stdCount" value=pracClazz.stdCount! label="人数" required="true" max="10000"/]
       [@b.textfield name="pracClazz.credits" value=pracClazz.credits! label="学分" required="false"/]
       [@b.formfoot]
          <input type="hidden" name="pracClazz.semester.id" value="${pracClazz.semester.id}"/>
          [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
       [/@]
    [/@]
    </div>
    [#if pracClazz.persisted]
    <div class="col-7" style="border-left: solid 1px burlywood;">
    [@b.div href="course-schedule!search?courseSchedule.activity.id=${pracClazz.id}"/]
    </div>
    [/#if]
  </div>
</div>
[@b.foot/]
