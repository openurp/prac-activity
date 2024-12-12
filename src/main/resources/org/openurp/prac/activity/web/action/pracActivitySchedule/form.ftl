[@b.head/]
  [#assign time_style='0']
  [#if pracActivitySchedule.weekTime?? && pracActivitySchedule.weekTime.weekstate?? && pracActivitySchedule.weekTime.weekstate.value >0]
    [#assign time_style='1']
  [/#if]

  [@b.form action=b.rest.save(pracActivitySchedule) theme="list" onsubmit="validTime"]
     [@b.select name="pracActivitySchedule.teachingMethod.id" value=pracActivitySchedule.teachingMethod! items=teachingMethods label="授课形式" required="true"/]
     [@b.radios id="time_style" name="time_style" label="课程安排" items={"1":"选择具体时间","0":"文字说明"} value=time_style required="true" onclick="toggleTimePicker(this.value)"/]
     [@b.field label="具体时间"]
         <input id="beginAt" name="beginAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(pracActivitySchedule.weekTime.beginAt)!}" class="Wdate" style="width:40px" placeholder="00:00">~[#t]
         <input id="endAt" name="endAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(pracActivitySchedule.weekTime.endAt)!}" class="Wdate" style="width:40px" placeholder="00:00">[#t]
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
             [#if pracActivitySchedule.weekTime??]
             kd.setSelected("[#list pracActivitySchedule.weekTime.dates as date]${date?string('yyyy-MM-dd')}[#sep],[/#list]")
             [/#if]
          });
         </script>
     [/@]
     [#assign timeStyle][#if time_style =='1']display:'none';[/#if]width:100px[/#assign]
     [@b.startend name="pracActivitySchedule.beginOn,pracActivitySchedule.endOn" required="true" style=timeStyle start=pracActivitySchedule.beginOn! end=pracActivitySchedule.endOn! label="起始结束" required="true"/]
     [@b.textfield id="pracActivitySchedule_times" name="pracActivitySchedule.times" style=timeStyle value=pracActivitySchedule.times!'--' label="安排说明" required="true" style="width:300px"/]

     [@b.textfield name="pracActivitySchedule.places" value=pracActivitySchedule.places! label="地点" required="true" style="width:300px;"/]
     [@b.select name="teacherUserId" label="授课教师" values=pracActivitySchedule.teachers multiple="true"
                style="width:300px;" href=urp.api+"/base/users.json?q={term}&isTeacher=1" option="id,description" empty="..."/]
     [@b.textfield name="pracActivitySchedule.externTeacher" value=pracActivitySchedule.externTeacher! label="其他教师" required="false"/]
     [@b.formfoot]
        <input type="hidden" name="pracActivitySchedule.activity.id" value="${pracActivitySchedule.activity.id}"/>
        <input name="_params" type="hidden" value="&pracActivitySchedule.activity.id=${pracActivitySchedule.activity.id}"/>
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
        jQuery("#pracActivitySchedule_times").parent().prev().hide();
        jQuery("#pracActivitySchedule_times").parent().hide();
       }else{
        jQuery("#dates_picker").parent().hide();
        jQuery("#pracActivitySchedule_times").parent().prev().show();
        jQuery("#pracActivitySchedule_times").parent().show();
       }
    }
    toggleTimePicker('${time_style}')
  </script>
[@b.foot/]
