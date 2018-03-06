var keystone = require('keystone');
var io = require('../../sockets/socket');

exports = module.exports = function(req, res) {

  var Session = keystone.list('Session');
  var Queue = keystone.list('Queue');

  var view = new keystone.View(req, res);
  var locals = res.locals;
  locals.sessions = [];

  // **********************************************************************************************

  view.on('init', function(next) {
    next();
  });

  // **********************************************************************************************

  view.on('post', {action: 'add'}, function(next) {

    Session.model.findOne({course: locals.course._id, _id: req.body.sessionId}).exec(
        function(err, session) {

          if (!err) {

            if (session && session.isOpen()) {

              Queue.model.addToQueue(locals.course, session, locals.user, req.body.location, req.body.row,
                  function(err, queue) {

                    if (err && !req.xhr) {
                      req.flash('error', 'Failed to enqueue.');
                      next();
                    } else if (err && req.xhr) {
                      res.json({error: true});
                    } else {
                      next();
                    }

                  });

            } else {

              if (err && !req.xhr) {
                req.flash('error', 'Failed to enqueue.');
                next();
              } else if (err && req.xhr) {
                res.json({error: true});
              } else {
                next();
              }

            }

          } else {
            if (err && !req.xhr) {
              req.flash('error', 'Failed to enqueue.');
              next();
            } else if (err && req.xhr) {
              res.json({error: true});
            } else {
              next();
            }

          }

        });

  });

  // **********************************************************************************************

  view.on('post', {action: 'remove'}, function(next) {

    Queue.model.removeUser(locals.course, locals.user, function(err) {

      if (err) {
        req.flash('error', 'Failed to dequeue.');
      } else {
        req.flash('success', 'You are no longer in the queue.');
      }

      next();

    });

  });

  // **********************************************************************************************

  view.on('render', function(next) {

    var errors = false;
    locals.course.createSummary(locals.user, function(err, summary) {

      if (err) {
        errors = true;
      } else {
        locals.queueData = summary;
      }

      if (req.xhr) {
        if (errors) {
          res.json({error: true});
        } else {
          res.json(locals.queueData);
        }
      } else {
        if (errors) {
          req.flash('error', 'Failed to load queue data.');
        } else {
          locals.queueData = JSON.stringify(locals.queueData);
        }

        next();

      }

    });

  });

  view.render('queue', locals);

};
