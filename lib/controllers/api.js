'use strict';
// var Tickets = require('../api/tickets');
var ticketsManager = require('../api/tickets-manager').getInstance();

var A_DAY = 24 * 60 * 60,
    mongoose = require('mongoose'),
    Thing = mongoose.model('Thing'),
    Train = mongoose.model('Train');

var setCacheControl = function(res, maxAge){
  res.setHeader('Cache-Control', 'public, max-age=' + maxAge);
  console.log("=========== getHeader: ", res.getHeader('Cache-Control'));
};
/**
 * Get awesome things
 */
exports.awesomeThings = function(req, res) {
  return Thing.find(function (err, things) {
    if (!err) {
      return res.json(things);
    } else {
      return res.send(err);
    }
  });
};

/**
 * Get Trains
 */
exports.Trains = function(req, res){
  return Train.find(function(err, trains){
    console.log("in api load " + trains.length + " trains");
    if (!err){
      // console.log("88888888- trains: ", trains);
      setCacheControl(res, A_DAY);
      return res.json(trains);
    } else {
      console.log("err: ", err);
      return res.send(err);
    }
  });
};

/**
 * Get Tickets
 */
exports.Tickets = function(req, res){
  var tickets = ticketsManager.getAllRemainTickets();
  // console.log("--------- tickets: ", tickets);
  return res.json(tickets);
};

/**
 * Make Order
 */
exports.order = function(req, res){
  if (ticketsManager.orderTicket(req.body)){
    return res.json({oid: 'oid'});
  } else {
    return res.json({});
  }


  // var result;
  // if (Math.random() >= 0.5) {
  //   console.log("----- success -------");
  //   result = {oid: 'oid'};
  // } else {
  //   console.log("***** failed *********");
  //   result = {};
  // }
  // return res.json(result);
};