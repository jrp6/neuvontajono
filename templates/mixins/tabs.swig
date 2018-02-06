{%- macro renderTabs() -%}
<ul class="nav nav-tabs">
  <li><a href="/neuvontajono/queue">Queue</a></li>
  <li><a href="/neuvontajono/sessions">Exercise Groups</a></li>
  
  {% if course.statisticsLevel == 0 %}
  <li><a href="/neuvontajono/statistics">Statistics</a></li>
  {% elif course.statisticsLevel == 1 and staff %}
  <li><a href="/neuvontajono/statistics">Statistics</a></li>
  {% elif course.statisticsLevel == 2 and teacher %}
  <li><a href="/neuvontajono/statistics">Statistics</a></li>
  {% endif %}
  
  {% if staff %}
  <li><a href="/neuvontajono/selectSession">Queue Management</a></li>
  {% endif %}
  {% if teacher %}
  <li><a href="/neuvontajono/settings">Course Settings</a></li>
  {% endif %}  
</ul>
{%- endmacro -%}