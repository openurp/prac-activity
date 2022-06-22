[@b.head/]
[@b.messages slash="2"/]
<div class="card" style="width: 100%;">
  <div class="card-header" style="padding-bottom:0px">
    课程安排[@b.a style="float:right" class="btn btn-sm btn-success" href="!editNew?courseSchedule.activity.id="+Parameters['courseSchedule.activity.id']]<i class="fa-solid fa-plus"></i>添加[/@]
  </div>
  <ul class="list-group list-group-flush">
    [#list courseSchedules as courseSchedule]
    <li class="list-group-item">
     [#list courseSchedule.teachers as t]${t.name}[#sep]&nbsp;[/#list]&nbsp;${(courseSchedule.externTeacher)!}
     [#if courseSchedule.weekTime?? && courseSchedule.weekTime.weekstate.value>0]
       ${courseSchedule.weekTime.firstDay?string("E")}
         [#assign thisMonth="--"]
         [#list courseSchedule.weekTime.dates as date]
         [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
         [#else]${date?string("d")}[/#if][#t]
         [#sep],[/#list]
       日${courseSchedule.weekTime.beginAt}~${courseSchedule.weekTime.endAt}[#t]
     [#else]
       ${courseSchedule.beginOn?string("MM-dd")}~${courseSchedule.endOn?string("MM-dd")} ${courseSchedule.times!}
     [/#if]
     ${courseSchedule.places!}
     [@b.a href="!edit?id="+courseSchedule.id]<i class="fa-solid fa-pen-to-square"></i>[/@]
     <a title="删除" href="#" style="color:red" onclick="return remoteSchedule('${courseSchedule.id}');"><i class="fa-solid fa-xmark"></i></a>
    </li>
    [/#list]
  </ul>
</div>
[@b.form name="removeForm" action="!remove"]
   <input type="hidden" value="" name="courseSchedule.id"/>
   <input type="hidden" name="_params" value="courseSchedule.activity.id=${Parameters['courseSchedule.activity.id']}"/>
[/@]
<script>
   function remoteSchedule(id){
      if(confirm("确定删除?")){
         document.removeForm['courseSchedule.id'].value=id;
         bg.form.submit(document.removeForm);
         return true;
      }else{
        return false;
      }
   }
</script>
[@b.foot/]
