var keystone = require('keystone');

exports = module.exports = function(req, res) {

  var view = new keystone.View(req, res);
  var locals = res.locals;

  if (locals.course) {
    res.redirect('/assistancequeue/queue');
    return;
  }

  view.render('index', locals);

};
