{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
<script src="/neuvontajono/scripts/knockout-3.3.0.js"></script>
<script src="/neuvontajono/scripts/knockout.mapping.js"></script>
<script>
  $(function() {
    var formData = {{ formDataJSON|safe }};
    var koViewModel = ko.mapping.fromJS(formData);
    ko.applyBindings(koViewModel);


    $('button.delete-session').click(function(event) {
      if (!confirm('Are you sure you wish to remove this exercise group?')) {
        event.preventDefault();
      }
    });

  });
</script>
{% endblock %}

{% block content %}
<h2>{{ course.name }}</h2>

{{ Tabs.renderTabs() }}

<form class="form-horizontal" method="post" action="#">

  <h3>General settings</h3>

  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <div class="form-group">
    <label for="courseName" class="col-sm-2 control-label">Course name:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="name" id="courseName" value="{{ formData.name }}">
    </div>
  </div>

  <div class="form-group">
    <label for="courseId" class="col-sm-2 control-label">Course ID:</label>
    <div class="col-sm-6">
      <p id="courseId" class="form-control-static">{{ formData.courseId }}</p>
    </div>
  </div>

  <div class="form-group">
    <label for="courseURL" class="col-sm-2 control-label">URL:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="url" id="courseURL" value="{{ formData.url }}">
      <p class="help-block small">Enter an URL with more information about the exercise groups. This field can be left blank.</p>
    </div>
  </div>

  <div class="form-group">
    <label for="combined" class="col-sm-2 control-label">Combine with course:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="combined" id="combined" value="{{ formData.combined }}">
      <p class="help-block small">
        If you wish to combine the queues of several courses, enter the ID of the course with which this course
        will be combined with. In this case, everyone except the course teacher will be redirected to the other course
        when the queue is opened, and the queue of this course will be disabled.
      </p>
    </div>
  </div>

  <div class="form-group">
    <label for="projectorConf" class="col-sm-2 control-label">Projector view:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="projectorConf" id="projectorConf" value="{{ formData.projectorConf }}">
      <p class="help-block small">If the projector view is used, enter the URL of the configuration file here.</p>
    </div>
  </div>

  <div class="form-group">
    <label for="statisticsLevel" class="col-sm-2 control-label">Statistics visibility:</label>
    <div class="col-sm-6">
      <select name="statisticsLevel" data-bind="value: statisticsLevel">
      <option value="0">Visible to all</option>
      <option value="1">Visible to staff only</option>
      <option value="2">Visible to teacher only</option>
      </select>
    </div>
  </div>

  <div class="form-group">
    <label for="yellowLimit" class="col-sm-2 control-label">Statistics colour limit:</label>
    <div class="col-sm-6">
      <input type="text" class="statistics-level-input form-control" name="yellowLimit" id="yellowLimit" value="{{ formData.yellowLimit }}">
      <input type="text" class="statistics-level-input form-control" name="redLimit" id="redLimit" value="{{ formData.redLimit }}">
      <p class="help-block small">Enter the yellow limit in the first field and the red limit in the second.</p>
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" name="action" value="saveSettings" class="btn btn-primary">Save</button>
    </div>
  </div>

</form>

<hr>

<h3>Exercise groups</h3>
<form action="#" method="post">
  <input type="hidden" name="action" value="remove">
  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <table class="table">
    <tr>
      <th>Name</th>
      <th>Duration</th>
      <th>Time</th>
      <th>Location</th>
      <th>Staff</th>
      <th>&nbsp;</th>
    </tr>
    {% for session in sessions %}
    {% if session.active %}
    <tr>
    {% else %}
    <tr class="inactive-session">
    {% endif %}
      <td>{{ session.name }}</td>
      <td>{{ session.datespan }}</td>
      <td>{{ session.timespan }}</td>
      <td>{{ session.location }}</td>
      <td>{{ session.assistants }}</td>
      <td><a href="/neuvontajono/sessions/{{session.id}}/edit" class="btn btn-xs btn-primary">Modify</a> <button name="sessionId" value="{{session.id}}" class="btn btn-xs btn-danger delete-session">Remove</button></td>
    </tr>
    {% endfor %}
  </table>
</form>

<form action="#" method="post">
  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <p>
    <a href="/neuvontajono/sessions/create" class="btn btn-success">Create a new exercise group</a>
  </p>
  <p style="margin-top: 25px;">
    All exercise groups can be temporarily deactivated e.g. for the duration of an exam week
    using the button below. The groups can be reactivated at any time.
  </p>
  <p>
    <button name="action" value="disableAll" class="btn btn-primary">Deactivate all</button>
    <button name="action" value="enableAll" class="btn btn-primary">Activate all</button>
  </p>
</form>

{% endblock %}
