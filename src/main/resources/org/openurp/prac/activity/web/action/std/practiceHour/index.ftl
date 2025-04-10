[@b.head/]
<div class="container-fluid">
  <nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fa-solid fa-flag-checkered"></i>实践学时统计和认定</a>
      </div>
    </div>
  </nav>
  <div style="background-color: #e9ecef;border-radius: .3rem;padding: 1rem 1rem;margin-bottom: 1rem;">
    <pre style="border-bottom: 1px solid rgba(0,0,0,.125);white-space: pre-wrap;">实践学时统计
[#list categories as category]
${category_index+1}.${category.name} ${(hours.get(category).hours)!0}学时；
[/#list]</pre>
  </div>

  [#list categories as category]
  [#assign infoList = infoes.get(category)/]
  [#assign hour = hours.get(category)/]
  [@b.card class="card card-info card-outline"]
    [@b.card_header]
      ${category.name} <span class="text-muted">要求${hour.requiredHours!}学时 完成${hour.hours}学时</span>
      [@b.card_tools]
        [#if hour.courseGradeId??]已认定[#else]未认定[/#if]
      [/@]
    [/@]
    [@b.card_body style="padding-top:0px"]
      <table class="table table-sm table-striped">
        <thead>
          <tr>
            <td>日期</td>
            <td>时间地点</td>
            <td>类型</td>
            <td>学时</td>
          </tr>
        </thead>
        <tbody>
        [#list infoList?sort_by('datetime')?reverse as info]
          <tr>
            <td>${info.datetime!}</td>
            <td>${info.place!}</td>
            <td>${info.practiceType.name}</td>
            <td>${info.hours}</td>
          </tr>
        [/#list]
        </tbody>
      </table>
    [/@]
  [/@]
  [/#list]
</div>
[@b.foot/]
