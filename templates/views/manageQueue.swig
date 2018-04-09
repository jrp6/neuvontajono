{% import "../mixins/tabs.swig" as Tabs %}
{% extends "../layouts/default.swig" %}

{% block js %}
<script src="/assistancequeue/socket.io/socket.io.js"></script>
<script src="/assistancequeue/scripts/knockout-3.4.2.js"></script>
<script src="/assistancequeue/scripts/knockout.mapping.js"></script>

<script type="text/javascript">
   var queueData = {{ queueData|safe }};

  function ordinal(number) {
      if (number % 10 === 1 && number % 100 !== 11) {
          return number + 'st'
      } else if (number % 10 === 2 && number % 100 !== 12) {
          return number + 'nd'
      } else if (number % 10 === 3 && number % 100 !== 13) {
          return number + 'rd'
      } else {
          return number + 'th'
      }
  }

</script>

<script src="/assistancequeue/scripts/manageQueue.js"></script>

{% endblock %}

{% block content %}
<h2>{{ course.name }}</h2>

{{ Tabs.renderTabs() }}

<h3>Queue status in {{ session.location }}</h3>

<input type="hidden" name="courseId" value="{{ course._id.toString() }}">
<input type="hidden" name="sessionId" value="{{ session._id.toString() }}">

{% if course.projectorConf %}
<p>
  <a href="/assistancequeue/sessions/{{ session._id.toString() }}/manage/projector" target="_blank" class="btn btn-success">Open projector view</a>
</p>
<p>
  When in projector view, remove next in queue by pressing space or clicking the name. You can
  get the view full screen in most browsers by pressing F11.
</p>
<hr>
{% endif%}

<p id="queue-length">Current queue length: <span data-bind="text: (users().length)"></span></p>
<form id="remove" action="#" method="post">
  <input type="hidden" name="action" value="remove">
  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <table id="queue" class="table">
    <thead>
      <tr>
        <th>Spot</th>
        <th>Name</th>
        <th>Enqueue time</th>
        <th>Location</th>
        <th>&nbsp;</th>
      </tr>
    </thead>
    <tbody data-bind="foreach: users">
      <tr>
        <td data-bind="text: (ordinal($index() + 1))"></td>
        <td data-bind="text: (user.name.first() + ' ' + user.name.last())"></td>
        <td data-bind="text: enteredAt"></td>
        <td data-bind="text: (location() + ', row ' + row())"></td>
        <td><button class="btn btn-primary btn-xs remove" name="queueId" data-bind="value: _id">Dequeue</button></td>
      </tr>
    </tbody>
  </table>
</form>

<p data-bind="visible: (users().length == 0)">The queue is empty.</p>

<form style="display: none;" data-bind="visible: (users().length > 0)" action="#" method="post">
  <input type="hidden" name="_csrf" value="{{ csrf_token_value }}">
  <button id="clear-queue" type="submit" class="btn btn-danger" name="action" value="clear">Empty the queue</button>
</form>

{% endblock %}
