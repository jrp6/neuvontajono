$(function() {

  // **********************************************************************************************

  var koViewModel = ko.mapping.fromJS(queueData);
  koViewModel.selectedSession = ko.observable({});

  // **********************************************************************************************

  var findPrevious = function(data, location) {
    if (data.sessions.length > 0) {
      koViewModel.selectedSession(koViewModel.sessions()[0]);
    }

    for (var i = 0; i < koViewModel.sessions().length; i++) {
      if (koViewModel.sessions()[i].location() === (location || data.user.previousLocation)) {
        koViewModel.selectedSession(koViewModel.sessions()[i]);
        break;
      }
    }
  };

  var update = function(data) {

    // Don't let the update to change the values the user might have just
    // selected

    var previousLocation = koViewModel.selectedSession() ? koViewModel.selectedSession().location() : '';
    var previousRow = koViewModel.user.previousRow();
    ko.mapping.fromJS(data, koViewModel);
    findPrevious(data, previousLocation);
    koViewModel.user.previousRow(previousRow);

  };

  // **********************************************************************************************

  findPrevious(queueData);
  ko.applyBindings(koViewModel);

  // **********************************************************************************************

  var socket = io.connect('/queue', { path: '/assistancequeue/socket.io', forceNew: true });

  socket.on('connect', function() {
    socket.emit('userQueue', { 'courseId': $('input[name="courseId"]').val() });
  });

  socket.on('userQueue', function(data) {
    if (data.error) {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend(
        $('<div class="alert alert-danger">Update failed. Try to refresh the queue.</div>'));
    } else {
      update(data);
    }
  });

  // **********************************************************************************************

  setInterval(function() {

    var timestamp = (new Date().getTime() / 1000).toFixed(0);
    $.getJSON('?timestamp=' + timestamp, function(data) {
      if (data.error) {
        $('div#alerts div.alert').remove();
        $('div#content div#alerts').prepend(
          $('<div class="alert alert-danger">Update failed. Try to refresh the queue.</div>'));
      } else {
        update(data);
      }
    }).fail(function() {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend(
        $('<div class="alert alert-danger">Update failed. Try to refresh the queue.</div>'));
    });
  }, 60000);

  // **********************************************************************************************

  $(document.body).on('click', 'form.queue button.add', function(e) {
    e.preventDefault();

    $('div#alerts div.alert').remove();

    var form = $(this).parents('form.queue');
    var postData = form.serializeArray();
    var formURL = $(this).attr('action');

    $.post(formURL, postData, function(data) {
      if (data.error) {
        $('div#alerts div.alert').remove();
        $('div#content div#alerts').prepend($('<div class="alert alert-danger">Failed to enqueue.</div>'));
      } else {
        update(data);
      }
    }).fail(function() {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend($('<div class="alert alert-danger">Failed to enqueue.</div>'));
    });

  });

  // **********************************************************************************************

  $(document.body).on('click', 'form#remove button.remove', function(e) {

    e.preventDefault();

    if (!confirm('Are you sure you wish to dequeue?')) {
      return;
    }

    $('div#alerts div.alert').remove();

    var form = $(this).parents('form#remove');
    var postData = form.serializeArray();
    var formURL = $(this).attr('action');

    $.post(formURL, postData, function(data) {
      if (data.error) {
        $('div#alerts div.alert').remove();
        $('div#content div#alerts').prepend(
          $('<div class="alert alert-danger">Failed to dequeue.</div>'));
      } else {
        $('div#content div#alerts').prepend($('<div class="alert alert-success">You are no longer in the queue.</div>'));
        update(data);
      }
    }).fail(function() {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend(
        $('<div class="alert alert-danger">Failed to dequeue.</div>'));
    });

  });

});
