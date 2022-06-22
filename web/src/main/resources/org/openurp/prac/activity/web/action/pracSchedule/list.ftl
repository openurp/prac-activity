[@b.head/]
[@b.messages slash="2"/]
<div class="card" style="width: 100%;">
  <div class="card-header" style="padding-bottom:0px">
    课程安排[@b.a style="float:right" class="btn btn-sm btn-success" href="!editNew?pracSchedule.activity.id="+Parameters['pracSchedule.activity.id']]<i class="fa-solid fa-plus"></i>添加[/@]
  </div>
  <ul class="list-group list-group-flush">
    [#list pracSchedules as pracSchedule]
    <li class="list-group-item">
     [#list pracSchedule.teachers as t]${t.name}[#sep]&nbsp;[/#list]&nbsp;${(pracSchedule.externTeacher)!}
     [#if pracSchedule.weekTime?? && pracSchedule.weekTime.weekstate.value>0]
       ${pracSchedule.weekTime.firstDay?string("E")}
         [#assign thisMonth="--"]
         [#list pracSchedule.weekTime.dates as date]
         [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
         [#else]${date?string("d")}[/#if][#t]
         [#sep],[/#list]
       日${pracSchedule.weekTime.beginAt}~${pracSchedule.weekTime.endAt}[#t]
     [#else]
       ${pracSchedule.beginOn?string("MM-dd")}~${pracSchedule.endOn?string("MM-dd")} ${pracSchedule.times!}&nbsp;
     [/#if]
     ${pracSchedule.places!}
     [@b.a href="!edit?id="+pracSchedule.id]<i class="fa-solid fa-pen-to-square"></i>[/@]
     <a title="删除" href="#" style="color:red" onclick="return remoteSchedule('${pracSchedule.id}');"><i class="fa-solid fa-xmark"></i></a>
    </li>
    [/#list]
  </ul>
</div>
[@b.form name="removeForm" action="!remove"]
   <input type="hidden" value="" name="pracSchedule.id"/>
   <input type="hidden" name="_params" value="pracSchedule.activity.id=${Parameters['pracSchedule.activity.id']}"/>
[/@]
<script>
   function remoteSchedule(id){
      if(confirm("确定删除?")){
         document.removeForm['pracSchedule.id'].value=id;
         bg.form.submit(document.removeForm);
         return true;
      }else{
        return false;
      }
   }
</script>
[@b.foot/]
