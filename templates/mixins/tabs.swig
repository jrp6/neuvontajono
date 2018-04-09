{%- macro renderTabs() -%}
<ul class="nav nav-tabs">
  <li><a href="/assistancequeue/queue">Queue</a></li>
  <li><a href="/assistancequeue/sessions">Exercise Groups</a></li>
  
  {% if course.statisticsLevel == 0 %}
  <li><a href="/assistancequeue/statistics">Statistics</a></li>
  {% elif course.statisticsLevel == 1 and staff %}
  <li><a href="/assistancequeue/statistics">Statistics</a></li>
  {% elif course.statisticsLevel == 2 and teacher %}
  <li><a href="/assistancequeue/statistics">Statistics</a></li>
  {% endif %}
  
  {% if staff %}
  <li><a href="/assistancequeue/selectSession">Queue Management</a></li>
  {% endif %}
  {% if teacher %}
  <li><a href="/assistancequeue/settings">Course Settings</a></li>
  {% endif %}  
</ul>
{%- endmacro -%}