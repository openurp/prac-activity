[@b.head/]
  [#assign time_style='0']
  [#if pracSchedule.weekTime?? && pracSchedule.weekTime.weekstate?? && pracSchedule.weekTime.weekstate.value >0]
    [#assign time_style='1']
  [/#if]

  [@b.form action=b.rest.save(pracSchedule) theme="list" onsubmit="validTime"]
     [@b.select name="pracSchedule.teachingMethod.id" value=pracSchedule.teachingMethod! items=teachingMethods label="授课形式" required="true"/]
     [@b.radios id="time_style" name="time_style" label="课程安排" items={"1":"选择具体时间","0":"文字说明"} value=time_style required="true" onclick="toggleTimePicker(this.value)"/]
     [@b.field label="具体时间"]
         <input id="beginAt" name="beginAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(pracSchedule.weekTime.beginAt)!}" class="Wdate" style="width:40px" placeholder="00:00">~[#t]
         <input id="endAt" name="endAt" onFocus="WdatePicker({dateFmt:'HH:mm'})" value="${(pracSchedule.weekTime.endAt)!}" class="Wdate" style="width:40px" placeholder="00:00">[#t]
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
             [#if pracSchedule.weekTime??]
             kd.setSelected("[#list pracSchedule.weekTime.dates as date]${date?string('yyyy-MM-dd')}[#sep],[/#list]")
             [/#if]
          });
         </script>
     [/@]
     [#assign timeStyle][#if time_style =='1']display:'none';[/#if]width:100px[/#assign]
     [@b.startend name="pracSchedule.beginOn,pracSchedule.endOn" required="true" style=timeStyle start=pracSchedule.beginOn! end=pracSchedule.endOn! label="起始结束" required="true"/]
     [@b.textfield id="pracSchedule_times" name="pracSchedule.times" style=timeStyle value=pracSchedule.times!'--' label="安排说明" required="true" style="width:300px"/]

     [@b.textfield name="pracSchedule.places" value=pracSchedule.places! label="地点" required="true" style="width:300px;"/]
     [@b.select name="teacherUserId" label="授课教师" values=pracSchedule.teachers multiple="true"
                style="width:300px;" href=urp.api+"/base/users.json?q={term}&isTeacher=1" option="id,description" empty="..."/]
     [@b.textfield name="pracSchedule.externTeacher" value=pracSchedule.externTeacher! label="其他教师" required="false"/]
     [@b.formfoot]
        <input type="hidden" name="pracSchedule.activity.id" value="${pracSchedule.activity.id}"/>
        <input name="_params" type="hidden" value="&pracSchedule.activity.id=${pracSchedule.activity.id}"/>
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
        jQuery("#pracSchedule_times").parent().prev().hide();
        jQuery("#pracSchedule_times").parent().hide();
       }else{
        jQuery("#dates_picker").parent().hide();
        jQuery("#pracSchedule_times").parent().prev().show();
        jQuery("#pracSchedule_times").parent().show();
       }
    }
    toggleTimePicker('${time_style}')
  </script>
[@b.foot/]
