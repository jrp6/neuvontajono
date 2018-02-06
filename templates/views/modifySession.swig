{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
<script src="/neuvontajono/scripts/knockout-3.3.0.js"></script>
<script src="/neuvontajono/scripts/knockout.mapping.js"></script>
<script src="/neuvontajono/scripts/moment.min.js"></script>
<script src="/neuvontajono/scripts/bootstrap.transitions.min.js"></script>
<script src="/neuvontajono/scripts/bootstrap-datetimepicker.min.js"></script>

<script>
  $(function() {
    $('.calendar').datetimepicker({locale: 'fi', format: 'D.M.YYYY'});
    var formData = {{ formDataJSON|safe }};
    var koViewModel = ko.mapping.fromJS(formData);
    ko.applyBindings(koViewModel);

    $('#startTime').change(function() {

      if (!$('#queueOpenTime').val() || $('#queueOpenTime').val().trim() == '') {
        $('#queueOpenTime').val($(this).val());
      }

    });

  });
</script>
{% endblock %}

{% block css %}
  <link href="/neuvontajono/styles/bootstrap-datetimepicker.min.css" rel="stylesheet">
{% endblock %}

{% block content %}

<h2>{{ course.name }}</h2>
{% if createNew %}
<h3>Create a new exercise group</h3>
{% else %}
<h3>Modify exercise group</h3>
{% endif %}

<form class="form-horizontal" method="post" action="#">
  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <div class="form-group">
    <label for="courseName" class="col-sm-2 control-label">Name:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="name" id="name" value="{{formData.name}}">
      <p class="help-block small">Name can be e.g. &quot;Monday 14-16&quot; or &quot;H2&quot;..</p>
    </div>
  </div>
  <div class="form-group">
    <label for="location" class="col-sm-2 control-label">Location:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="location" id="location" value="{{formData.location}}">
      <p class="help-block small">If there is an exercise group simultaneously in multiple locations,
      and the locations share a queue, enter all the locations separated by commas.</p>
    </div>
  </div>
  <div class="form-group">
    <label for="assistants" class="col-sm-2 control-label">Staff:</label>
    <div class="col-sm-6">
      <input type="text" class="form-control" name="assistants" id="assistants" value="{{formData.assistants}}">
      <p class="help-block small">Enter staff names separated by commas. This field can be left blank.</p>
    </div>
  </div>

  <hr>

  <div class="form-group">
    <label for="weekday" class="col-sm-2 control-label">Day of week:</label>
    <div class="col-sm-6">
      <select name="weekday" data-bind="value: weekday">
      <option value="1">Monday</option>
      <option value="2">Tuesday</option>
      <option value="3">Wednesday</option>
      <option value="4">Thursday</option>
      <option value="5">Friday</option>
      <option value="6">Saturday</option>
      <option value="0">Sunday</option>
      </select>
    </div>
  </div>

  <hr>

  <div class="form-group">
    <label for="startDate" class="col-sm-2 control-label">Start date:</label>
    <div class="col-sm-3">
      <input type="text" class="form-control calendar" name="startDate" id="startDate" value="{{formData.startDate}}">
      <p class="help-block small">Enter the date in format 1.3.2015.</p>
    </div>
  </div>
  <div class="form-group">
    <label for="endDate" class="col-sm-2 control-label">End date:</label>
    <div class="col-sm-3">
      <input type="text" class="form-control calendar" name="endDate" id="endDate" value="{{formData.endDate}}">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <div class="checkbox">
        <label>
          <input type="checkbox" name="active" id="active" data-bind="checked: active"> Active
        </label>
        <p class="help-block small">This setting can be used to temporarily disable a group.</p>
      </div>
    </div>
  </div>
  <hr>

  <div class="form-group">
    <label for="startTime" class="col-sm-2 control-label">Start time:</label>
    <div class="col-sm-3">
      <input type="text" class="form-control" name="startTime" id="startTime" value="{{formData.startTime}}">
      <p class="help-block small">Enter time in format 14:15.</p>
    </div>
  </div>
  <div class="form-group">
    <label for="endTime" class="col-sm-2 control-label">End time:</label>
    <div class="col-sm-3">
      <input type="text" class="form-control" name="endTime" id="endTime" value="{{formData.endTime}}">
    </div>
  </div>

  <hr>

  <div class="form-group">
    <label for="queueOpenTime" class="col-sm-2 control-label">Queue open time:</label>
    <div class="col-sm-3">
      <input type="text" class="form-control" name="queueOpenTime" id="queueOpenTime" value="{{formData.queueOpenTime}}">
    </div>
  </div>

  <div class="form-group">
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" name="action" value="save" class="btn btn-primary">Save</button>
      <a href="/neuvontajono/settings" class="btn btn-danger">Cancel</a>
    </div>
  </div>
</form>

{% endblock %}
