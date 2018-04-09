{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
{% endblock %}

{% block content %}
<h2>{{ course.name }}</h2>

{{ Tabs.renderTabs() }}

{% if sessions.length > 0 %}

  <p>Select exercise group. The table below contains all exercise groups today.</p>

  <table class="table">
    <tr>
      <th>Name</th>
      <th>Time</th>
      <th>Location</th>
      <th>Staff</th>
      <th>&nbsp;</th>
    </tr>
    {% for session in sessions %}
    <tr class="{{ session.status }}">
      <td>{{ session.name }}</td>
      <td>{{ session.timespan }}</td>
      <td>{{ session.location }}</td>
      <td>{{ session.assistants }}</td>
      <td><a href="/assistancequeue/sessions/{{session.id}}/manage" class="btn btn-primary">Select</a></td>
    </tr>
    {% endfor %}
  </table>

{% else %}

    <p>No exercise groups today.</p>

{% endif %}

{% endblock %}
