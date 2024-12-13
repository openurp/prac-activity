[#ftl]
[@b.head/]
[@b.grid items=stdPracticeInfoes var="stdPracticeInfo" ]
  [@b.gridbar]
    bar.addItem("${b.text('action.export')}",action.exportData("std.code:学号,"+
                "std.name:姓名,category.name:大类,practiceType.name:实践分类,hours:学时,name:活动名称,"+
                "datetime:日期时间,place:地点",null,'fileName=学生实践活动明细'));
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col property="std.code" title="学号" width="8%"/]
    [@b.col property="std.name" title="姓名" width="10%"]
      <div title="${stdPracticeInfo.std.name}" class="text-ellipsis">
        ${stdPracticeInfo.std.name}
      </div>
    [/@]
    [@b.col property="category.name" title="大类" width="6%"/]
    [@b.col property="practiceType.name" title="实践分类" width="10%"/]
    [@b.col property="hours" title="学时" width="5%"/]
    [@b.col property="name" title="活动名称"]
      <div class="text-ellipsis">${stdPracticeInfo.name}</div>
    [/@]
    [@b.col property="datetime" title="日期时间" width="10%"/]
    [@b.col property="place" title="地点" width="20%"]
      <div class="text-ellipsis" title="${stdPracticeInfo.remark}">${stdPracticeInfo.place}</div>
    [/@]
  [/@]
[/@]
[@b.foot/]
