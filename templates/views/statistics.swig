{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
<script>
  var yellowLimit = {{ course.yellowLimit }};
  var redLimit = {{ course.redLimit }};
</script>
<script src="/assistancequeue/scripts/statistics.js"></script>
{% endblock %}

{% block content %}
<h2>{{ course.name }}</h2>

{{ Tabs.renderTabs() }}

<p>Below are statistics on how many students have attended each group during different weeks.
The statistics are gathered automatically using the advice queue and therefore might not be precise,
but you may use them to see which groups are usually busy and which are not.
</p>

<table class="statistics-table">

{% for row in stats %}
<tr>
  {% for column in row %}
  <td>{{ column }}</td>
  {% endfor %}
</tr>
{% endfor %}

</table>

{% if teacher %}

<hr>

<h3>Most active students</h3>

<div class="alert alert-info">
   This statistic is only visible to teachers.
</div>

<p>
  The table shows how many different exercise groups the student
  has attended during the course.
</p>

<table class="table table-condensed">
  <thead>
    <tr>
      <th>Ranking</th>
      <th>Student</th>
      <th>Visits</th>
    </tr>
  </thead>
  <tbody>
    {% for participant in mostFrequent %}
    <tr>
      <td>{{ participant[0]|ordinal }}</td>
      <td>{{ participant[1] }}</td>
      <td>{{ participant[2] }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>

{% endif %}

{% endblock %}
