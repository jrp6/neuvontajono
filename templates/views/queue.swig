{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
<script src="/neuvontajono/socket.io/socket.io.js"></script>
<script src="/neuvontajono/scripts/knockout-3.3.0.js"></script>
<script src="/neuvontajono/scripts/knockout.mapping.js"></script>

<script type="text/javascript">
   var queueData = {{ queueData|safe }}; 
</script>

<script src="/neuvontajono/scripts/queue.js"></script>
{% endblock %}

{% block content %}
<h2 data-bind="text: course.name"></h2>

{{ Tabs.renderTabs() }}

<p class="lead">You can ask course staff for help with solving exercises.
When you need help, you may add yourself to the queue. Everyone in the queue will be helped in order.</p>

<div style="display: none;" id="queue-length" class="alert alert-info" data-bind="visible: (user.position() >= 2)">
  You are currently <span id="queue-length" data-bind="text: user.position"></span>th in the queue.
</div>

<div style="display: none;" id="queue-length" class="alert alert-success" data-bind="visible: (user.position() == 1)">
  You are next in queue.
</div>

<div style="display: none;" id="queue-length" class="alert alert-info" data-bind="visible: (user.position() == 0 && locations().length == 0)">
  The queue is not currently open.
</div>

<div style="display: none;" data-bind="visible: (user.position() > 0)">
  <p>If you leave the exercise group or no longer need help, please exit the queue.</p>
  <form id="remove" action="#" method="post">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
    <button class="remove btn btn-primary">Exit the queue</button>
  </form>
</div>

<input type="hidden" name="courseId" value="{{ course._id.toString() }}">

<div style="display: none;" data-bind="visible: (user.position() == 0 && locations().length > 0)">
  <form class="queue form-horizontal" method="post" action="#">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
    
    <div style="display: none;" class="alert alert-warning" data-bind="visible: sessions().length > 1">
      This course has exercise groups ongoing in multiple locations. Please select the correct location.
    </div>
    
    <div class="form-group" data-bind="visible: sessions().length > 1">
      <label for="location" class="col-sm-3 control-label">Exercise group:</label>
      <div class="col-sm-6">
        <select id="session-selector" data-bind="options: sessions, optionsText: function(item){ return item.name() + ' (' + item.location() + ')'}, value: selectedSession"></select>
      </div>
    </div>
    
    <div class="form-group" data-bind="visible: sessions().length == 1">
      <label for="location" class="col-sm-3 control-label">Exercise group:</label>
      <div class="col-sm-6" data-bind="with: selectedSession">
        <span id="session-selector" data-bind="text: (name() + ' (' + location() + ')')"></span>
      </div>
    </div>  
    
    <hr>
    
    <div data-bind="with: selectedSession">
      <div class="form-group" data-bind="visible: (assistants().length > 0)">
        <label class="col-sm-3 control-label">Staff present:</label>
        <div class="col-sm-6">
          <p class="form-control-static" data-bind="text: assistants"></p>
        </div>
      </div>
    </div>
     
    <div class="form-group" data-bind="with: selectedSession">
      <label class="col-sm-3 control-label">Current queue length:</label>
      <div class="col-sm-6">
          <p class="form-control-static" data-bind="text: queueLength"></p>
        </div>
      <input type="hidden" name="sessionId" data-bind="value: _id">
      <input type="hidden" name="location" data-bind="value: location">
    </div>
    
    <hr>
    
    <div class="form-group">
      <label for="row" class="col-sm-3 control-label">I'm sitting on row:</label>
      <div class="col-sm-6">
        <select name="row" data-bind="value: user.previousRow">
          {% for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] %}
          <option value="{{ i }}">{{ i }}</option>  
          {% endfor %}
        </select>
        <p class="help-block small">Count rows starting from the front.</p>
      </div>
    </div>
    
    <hr>
    
    <div>
      <button class="add btn btn-primary">Enqueue</button>
    </div>
    
  </form>
</div>

<div class="change-session" style="display: none;" data-bind="visible: (user.position() >  0 && locations().length > 0)">
  <p>If you change to another row or change locations, please update your location.</p>
  <form class="queue form-inline" method="post" action="#">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">

    <div data-bind="with: selectedSession">
      <input type="hidden" name="sessionId" data-bind="value: _id">
      <input type="hidden" name="location" data-bind="value: location">
    </div>

    <div class="form-group">
      <label for="session2">Group:</label>
      <select id="session2" data-bind="options: sessions, optionsText: function(item){ return item.name() + ' (' + item.location() + ')'}, value: selectedSession"></select>
    </div>

    <div class="form-group">
      <label for="row2">Row:</label>
      <select id="row2" name="row" data-bind="value: user.previousRow">
        {% for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] %}
        <option value="{{ i }}">{{ i }}</option> {% endfor %}
      </select>
    </div>

    <div class="form-group">
      <button class="add btn btn-primary btn-xs">Change location</button>
    </div>

  </form>
</div>

{% endblock %}
