<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="{{ csrf_token_value }}" name="_csrf" />
    <title>{{ title|default("Assistance Queue") }}</title>
    <script src="/assistancequeue/scripts/jquery-3.3.1.min.js"></script>
    <script src="/assistancequeue/scripts/jquery-migrate-3.0.1.min.js"></script>
    <link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
    <script src="/assistancequeue/scripts/moment.min.js"></script>
    <link href="/assistancequeue/styles/projector.css" rel="stylesheet">

    <!--[if lt IE 9]>
    			<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    			<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    		<![endif]-->

    <script src="/assistancequeue/socket.io/socket.io.js"></script>
    <script src="/assistancequeue/scripts/knockout-3.4.2.js"></script>
    <script src="/assistancequeue/scripts/knockout.mapping.js"></script>

    <script type="text/javascript">
       var queueData = {{ queueData|safe }};
    </script>
    <script src="/assistancequeue/scripts/manageQueueProjector.js"></script>

  </head>

  <body>

    <input type="hidden" name="courseId" value="{{ course._id.toString() }}">
    <input type="hidden" name="sessionId" value="{{ session._id.toString() }}">
    <input type="hidden" name="csrf" value="{{ csrf_token_value }}">
    <input type="hidden" name="projectorConf" value="{{ course.projectorConf }}">

    <div id="header">
    <div id="time">&nbsp;</div>
    <div id="queue">In queue: <span id="length">&nbsp;</span></div>
    <div id="next">Next in queue:
      <span id="name">&nbsp;</span>
      (row <span id="row">&nbsp;</span>)</div>
    </div>

    <div id="content">
      <img align="middle" src="" id="img" alt="">
    </div>

  </body>
</html>
