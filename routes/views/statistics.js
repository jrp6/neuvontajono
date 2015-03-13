var keystone = require('keystone');
var moment = require('moment');

var Session = keystone.list('Session');
var Participant = keystone.list('Participant');

exports = module.exports = function(req, res) {

  var view = new keystone.View(req, res);
  var locals = res.locals;
  locals.weeks = [];

  view
      .on(
          'init',
          function(next) {

            if ((locals.course.statisticsLevel == 2 && !locals.teacher) || (locals.course.statisticsLevel == 1 && !locals.staff)) {
              req.flash('error', 'Sinulla ei ole oikeutta nähdä tilastoja.');
              res.redirect('/neuvontajono/queue');
            } else {
              next();
            }

          });

  view.on('get', function(next) {
    Session.model.find({course: locals.course._id}).sort({'weekday': 1, 'startTime': 1}).exec(function(err, sessions) {

      if (!err) {

        var startDates = [];
        var endDates = [];
        var names = {};
        var stats = {};
        var weeks = [];
        var sessionIdList = [];

        sessions.forEach(function(session) {

          startDates.push(moment(session.startDate));
          endDates.push(moment(session.endDate));
          names[session._id] = session.name;
          stats[session._id] = {};
          sessionIdList.push(session._id);

          var week = moment(session.startDate);
          var endWeek = moment(session.endDate).format('W/YYYY');

          // Generate all weeks when session is organized

          while (week.format('W/YYYY') != endWeek && week.isBefore(moment())) {
            stats[session._id][week.format('W/YYYY')] = 0;
            week.add(1, 'w');
          }

        });

        var minDay = moment.min(startDates);
        var maxDay = moment.max(endDates);
        var maxWeek = maxDay.format('W/YYYY');

        var currentWeek = moment(minDay);

        // Generate all possible weeks

        var currentWeekFormat;
        do {
          currentWeekFormat = currentWeek.format('W/YYYY');
          weeks.push(currentWeekFormat);
          currentWeek.add(1, 'w');
        } while (currentWeekFormat != maxWeek);

        Participant.model.find({course: locals.course._id}, function(err, participants) {

          if (!err) {

            participants.forEach(function(participant) {

              var week = moment(participant.date).format('W/YYYY');

              if (!stats[participant.session][week]) {
                stats[participant.session][week] = 0;
              }

              stats[participant.session][week]++;

            });

            locals.stats = [];
            var weekNames = [''];
            Array.prototype.push.apply(weekNames, weeks);

            if (minDay.year() == maxDay.year()) {
              weekNames = weekNames.map(function(item) {
                return item.split('/')[0];
              });
            }

            locals.stats.push(weekNames);

            // Collect data

            sessionIdList.forEach(function(id) {

              var participantsTotal = [names[id]];

              weeks.forEach(function(week) {
                if (stats[id][week] !== undefined) {
                  if (locals.staff || stats[id][week] >= 5) {
                    participantsTotal.push(stats[id][week]);
                  } else {
                    participantsTotal.push('<5');
                  }
                } else {
                  participantsTotal.push('-');
                }
              });

              locals.stats.push(participantsTotal);

            });

          } else {
            req.flash('error', 'Tilastojen lataaminen epäonnistui.');
          }

          next();

        });

      } else {

        req.flash('error', 'Tilastojen lataaminen epäonnistui.');
        next();

      }

    });
  });

  view.render('statistics', locals);

};