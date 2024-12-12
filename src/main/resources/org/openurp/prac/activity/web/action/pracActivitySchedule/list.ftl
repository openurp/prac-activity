[@b.head/]
[@b.messages slash="2"/]
<div class="card" style="width: 100%;">
  <div class="card-header" style="padding-bottom:0px">
    课程安排[@b.a style="float:right" class="btn btn-sm btn-success" href="!editNew?pracActivitySchedule.activity.id="+Parameters['pracActivitySchedule.activity.id']]<i class="fa-solid fa-plus"></i>添加[/@]
  </div>
  <ul class="list-group list-group-flush">
    [#list pracActivitySchedules as pracActivitySchedule]
    <li class="list-group-item">
     [#list pracActivitySchedule.teachers as t]${t.name}[#sep]&nbsp;[/#list]&nbsp;${(pracActivitySchedule.externTeacher)!}
     [#if pracActivitySchedule.weekTime?? && pracActivitySchedule.weekTime.weekstate.value>0]
       ${pracActivitySchedule.weekTime.firstDay?string("E")}
         [#assign thisMonth="--"]
         [#list pracActivitySchedule.weekTime.dates as date]
         [#if date?string("MM")!=thisMonth][#assign thisMonth=date?string("MM")]${date?string("M-d")}[#t]
         [#else]${date?string("d")}[/#if][#t]
         [#sep],[/#list]
       日${pracActivitySchedule.weekTime.beginAt}~${pracActivitySchedule.weekTime.endAt}[#t]
     [#else]
       ${pracActivitySchedule.beginOn?string("MM-dd")}~${pracActivitySchedule.endOn?string("MM-dd")} ${pracActivitySchedule.times!}&nbsp;
     [/#if]
     ${pracActivitySchedule.places!}
     [@b.a href="!edit?id="+pracActivitySchedule.id]<i class="fa-solid fa-pen-to-square"></i>[/@]
     <a title="删除" href="#" style="color:red" onclick="return remoteSchedule('${pracActivitySchedule.id}');"><i class="fa-solid fa-xmark"></i></a>
    </li>
    [/#list]
  </ul>
</div>
[@b.form name="removeForm" action="!remove"]
   <input type="hidden" value="" name="pracActivitySchedule.id"/>
   <input type="hidden" name="_params" value="pracActivitySchedule.activity.id=${Parameters['pracActivitySchedule.activity.id']}"/>
[/@]
<script>
   function remoteSchedule(id){
      if(confirm("确定删除?")){
         document.removeForm['pracActivitySchedule.id'].value=id;
         bg.form.submit(document.removeForm);
         return true;
      }else{
        return false;
      }
   }
</script>
[@b.foot/]
