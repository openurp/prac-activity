[@b.head/]
  [#assign time_style='0']
  [#if courseSchedule.weekTime?? && courseSchedule.weekTime.weekstate?? && courseSchedule.weekTime.weekstate.value >0]
    [#assign time_style='1']
  [/#if]
  [#if !courseSchedule.persisted][#assign time_style='1'][/#if]

  [@b.form action=b.rest.save(courseSchedule) theme="list" onsubmit="validTime"]
     [@b.select name="courseSchedule.teachingMethod.id" value=courseSchedule.teachingMethod! items=teachingMethods label="授课形式" required="true"/]
     [@b.radios id="time_style" name="time_style" label="课程安排" items={"1":"选择具体时间","0":"文字说明"} value=time_style required="true" onclick="toggleTimePicker(this.value)"/]
     [@b.field label="具体时间"]
         <input id="beginAt" name="beginAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(courseSchedule.weekTime.beginAt)!}" class="Wdate" style="width:40px" placeholder="00:00">~[#t]
         <input id="endAt" name="endAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(courseSchedule.weekTime.endAt)!}" class="Wdate" style="width:40px" placeholder="00:00">[#t]
         <input id="dates_input" name="days" readonly="readonly" style="width:250px;border: 0px;background-color: transparent;" placeholder="时间可直接键盘输入">
         <div id="dates_picker"></div>
         <span id="time_msg" style="color:red;display: block;margin-left: 100px;"></span>
         <script type="text/javascript">
          bg.load(["kalendae"],function(kalendae){
             var kd = new Kalendae({
             attachTo:document.getElementById('dates_picker'),
             months:${months},
             mode:'multiple',
             format:'YYYY-MM-DD',
             viewStartDate:'${semester.beginOn?string('yyyy-MM-dd')}',
             endDate:'${semester.endOn?string('yyyy-MM-dd')}',
             dayHeaderClickable: true,
             multipleDelimiter:','
             });
             kd.subscribe('change', function (date) {
                document.getElementById('dates_input').value=this.getSelected();
             });
             [#if courseSchedule.weekTime??]
             kd.setSelected("[#list courseSchedule.weekTime.dates as date]${date?string('yyyy-MM-dd')}[#sep],[/#list]")
             [/#if]
          });
         </script>
     [/@]
     [#assign timeStyle][#if time_style =='1']display:'none';[/#if]width:100px[/#assign]
     [@b.startend name="courseSchedule.beginOn,courseSchedule.endOn" required="true" style=timeStyle start=courseSchedule.beginOn! end=courseSchedule.endOn! label="起始结束" required="true"/]
     [@b.textfield id="courseSchedule_times" name="courseSchedule.times" style=timeStyle value=courseSchedule.times!'--' label="安排说明" required="true" style="width:300px"/]

     [@b.textfield name="courseSchedule.places" value=courseSchedule.places! label="教室安排" required="true" style="width:300px;"/]
     [@b.select name="teacherUserId" label="上课教师" values=courseSchedule.teachers multiple="true"
                style="width:300px;" href=urp.api+"/base/users.json?q={term}&isTeacher=1" option="id,description" empty="..."/]
     [@b.textfield name="courseSchedule.externTeacher" value=courseSchedule.externTeacher! label="其他教师" required="false"/]
     [@b.formfoot]
        <input type="hidden" name="courseSchedule.activity.id" value="${courseSchedule.activity.id}"/>
        <input name="_params" type="hidden" value="&courseSchedule.activity.id=${courseSchedule.activity.id}"/>
        [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
     [/@]
  [/@]
  <script>
    function validTime(form){
      if(form["time_style"].value=='1'){
        if(!$("#beginAt").val() || !$("#endAt").val() ||  !$("#dates_input").val()){
           $("#time_msg").html("请选择日期和输入时间")
           return false;
        }
      }
      return true;
    }
    function toggleTimePicker(display){
       if(display=='1'){
        jQuery("#dates_picker").parent().show();
        jQuery("#courseSchedule_times").parent().prev().hide();
        jQuery("#courseSchedule_times").parent().hide();
       }else{
        jQuery("#dates_picker").parent().hide();
        jQuery("#courseSchedule_times").parent().prev().show();
        jQuery("#courseSchedule_times").parent().show();
       }
    }
    toggleTimePicker('${time_style}')
  </script>
[@b.foot/]
