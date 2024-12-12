[@b.head/]
[@b.messages slash="2"/]
<div class="card" style="width: 100%;">
  <div class="card-header" style="padding-bottom:0px">
    课程安排[@b.a style="float:right" class="btn btn-sm btn-success" href="!editNew?pracClazzSchedule.activity.id="+Parameters['pracClazzSchedule.activity.id']]<i class="fa-solid fa-plus"></i>添加[/@]
  </div>
  <ul class="list-group list-group-flush">
    [#list pracClazzSchedules as pracClazzSchedule]
    <li class="list-group-item">
     [#list pracClazzSchedule.teachers as t]${t.name}[#sep]&nbsp;[/#list]&nbsp;${(pracClazzSchedule.externTeacher)!}
     [#if pracClazzSchedule.weekTime?? && pracClazzSchedule.weekTime.weekstate.value>0]
       ${pracClazzSchedule.weekTime.firstDay?string("E")}
         [#assign thisMonth="--"]
         [#list pracClazzSchedule.weekTime.dates as date]
         [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
         [#else]${date?string("d")}[/#if][#t]
         [#sep],[/#list]
       日${pracClazzSchedule.weekTime.beginAt}~${pracClazzSchedule.weekTime.endAt}[#t]
     [#else]
       ${pracClazzSchedule.beginOn?string("MM-dd")}~${pracClazzSchedule.endOn?string("MM-dd")} ${pracClazzSchedule.times!}
     [/#if]
     ${pracClazzSchedule.places!}
     [@b.a href="!edit?id="+pracClazzSchedule.id]<i class="fa-solid fa-pen-to-square"></i>[/@]
     <a title="删除" href="#" style="color:red" onclick="return remoteSchedule('${pracClazzSchedule.id}');"><i class="fa-solid fa-xmark"></i></a>
    </li>
    [/#list]
  </ul>
</div>
[@b.form name="removeForm" action="!remove"]
   <input type="hidden" value="" name="pracClazzSchedule.id"/>
   <input type="hidden" name="_params" value="pracClazzSchedule.activity.id=${Parameters['pracClazzSchedule.activity.id']}"/>
[/@]
<script>
   function remoteSchedule(id){
      if(confirm("确定删除?")){
         document.removeForm['pracClazzSchedule.id'].value=id;
         bg.form.submit(document.removeForm);
         return true;
      }else{
        return false;
      }
   }
</script>
[@b.foot/]
