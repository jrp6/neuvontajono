{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
{% endblock %}

{% block content %}
<h2>{{ course.name }}</h2>

{{ Tabs.renderTabs() }}


<p>The table below contains all exercise groups this week. Groups marked in green are today.
{%if course.url %}
For more details see <a href="{{course.url}}">here</a>.
{% endif %}
</p>

<table class="table">
  <tr>
    <th>Name</th>
    <th>Time</th>
    <th>Location</th>
    <th>Staff</th>
  </tr>
  {% for session in sessions %}
  <tr {% if session.weekday == today %}class="success" {% endif %}>
    <td>{{ session.name }}</td>
    <td>{{ session.weekdayString }} {{ session.timespan }}</td>
    <td>{{ session.location }}</td>
    <td>{{ session.assistants }}</td>
  </tr>
  {% endfor %}
</table>

{% if teacher %}
<p>Exercise groups can be modified in the <a href="/neuvontajono/settings">course settings</a>.</p>
{% endif %}

{% endblock %}
