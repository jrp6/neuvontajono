$(function() {

  var updateLayout = function() {
    $('table#queue tr').eq(1).addClass('first-in-queue');
    $('table#queue tr').eq(1).find('button').removeClass('btn-xs');
    document.title = 'Assistance Queue (' + koViewModel.users().length + ')';
  };

  // **********************************************************************************************

  var koViewModel = ko.mapping.fromJS(queueData);
  ko.applyBindings(koViewModel);
  updateLayout();

  // **********************************************************************************************

  var socket = io.connect('/queue', {path: '/assistancequeue/socket.io', forceNew: true});

  socket.on('connect', function() {
    socket.emit('staffQueue', {'sessionId': $('input[name="sessionId"]').val()});
  });

  socket.on('staffQueue', function(data) {
    if (data.error) {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend(
        $('<div class="alert alert-danger">Updating failed. Try to refresh the page.</div>'));
    } else {
      ko.mapping.fromJS(data, koViewModel);
      updateLayout();
    }
  });

  // **********************************************************************************************

  setInterval(function() {

    var timestamp = (new Date().getTime() / 1000).toFixed(0);
    $.getJSON(
        "?timestamp=" + timestamp,
        function(data) {
          if (data.error) {
            $('div#alerts div.alert').remove();
            $('div#content div#alerts').prepend(
              $('<div class="alert alert-danger">Updating failed. Try to refresh the page.</div>'));
          } else {
            ko.mapping.fromJS(data, koViewModel);
            updateLayout();
          }
        }).fail(
        function() {
          $('div#alerts div.alert').remove();
          $('div#content div#alerts').prepend(
            $('<div class="alert alert-danger">Updating failed. Try to refresh the page.</div>'));
        });
  }, 60000);

  // **********************************************************************************************

  $(document.body).on('click', 'form#remove button.remove', function(e) {
    e.preventDefault();

    if ($(this).hasClass('btn-xs') && !confirm('Are you sure you want to remove a student from the middle of the queue?')) {
      return;
    }

    var form = $(this).parents('form#remove');
    var postData = form.serializeArray();
    var formURL = $(this).attr("action");

    postData.push({name: 'queueId', value: $(this).attr('value')});

    $.post(formURL, postData, function(data) {
      if (data.error) {
        $('div#alerts div.alert').remove();
        $('div#content div#alerts').prepend($('<div class="alert alert-danger">Removal failed.</div>'));
      } else {
        ko.mapping.fromJS(data, koViewModel);
        updateLayout();
      }
    }).fail(function() {
      $('div#alerts div.alert').remove();
      $('div#content div#alerts').prepend($('<div class="alert alert-danger">Removal failed.</div>'));
    });

  });

  // **********************************************************************************************

  $('button#clear-queue').click(function(event) {
    if (!confirm('Are you sure you want to empty the queue?')) {
      event.preventDefault();
    }
  });

});
