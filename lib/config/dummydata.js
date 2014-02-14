'use strict';

var mongoose = require('mongoose'),
  User = mongoose.model('User'),
  Thing = mongoose.model('Thing'),
  Train = mongoose.model('Train'),
  Ticket = mongoose.model('Ticket');

/**
 * Populate database with sample application data
 */

//Clear old things, then add things in
Thing.find({}).remove(function() {
  Thing.create({
    name : 'HTML5 Boilerplate',
    info : 'HTML5 Boilerplate is a professional front-end template for building fast, robust, and adaptable web apps or sites.',
    awesomeness: 10
  }, {
    name : 'AngularJS',
    info : 'AngularJS is a toolset for building the framework most suited to your application development.',
    awesomeness: 10
  }, {
    name : 'Karma',
    info : 'Spectacular Test Runner for JavaScript.',
    awesomeness: 10
  }, {
    name : 'Express',
    info : 'Flexible and minimalist web application framework for node.js.',
    awesomeness: 10
  }, {
    name : 'MongoDB + Mongoose',
    info : 'An excellent document database. Combined with Mongoose to simplify adding validation and business logic.',
    awesomeness: 10
  }, function() {
      console.log('finished populating things');
    }
  );
});

// Clear old users, then add a default user
User.find({}).remove(function() {
  User.create({
    provider: 'local',
    name: 'Test User',
    email: 'test@test.com',
    password: 'test'
  }, function() {
      console.log('finished populating users');
    }
  );
});

// Clear old trains, then add tickets for dev in
Train.find({}).remove(function(){
  Train.create({
    '车次': 'D5117',
    '出发站/到达站': '重庆北 - 成都东',
    '经停站': ['重庆北', '合川', '潼南', '成都东'],
    '出发时间/到达时间': '13:02~15:03',
    '历时': '2:01' 
  }, {
    '车次': 'D5121',
    '出发站/到达站': '重庆北 - 成都东',
    '经停站': ['重庆北', '遂宁', '成都东'],
    '出发时间/到达时间': '13:02~15:03',
    '历时': '2:01'
  }, function() {
      console.log('finished populating tickets');
    }
  );
});

Ticket.find({}).remove(function(){
  Ticket.create({
    '车次': 'D5117',
    '日期': '2013-02-04', 
    '商务座': 10, 
    '特等座': 0, 
    '一等座': 20, 
    '二等座': 23, 
    '高级软卧': 40, 
    '软卧': 0, 
    '硬卧': 32, 
    '软座': 0, 
    '硬座': 20, 
    '无座': 0, 
    '其它': 0
  }, {
    '车次': 'D5121',
    '日期': '2013-02-04', 
    '商务座': 10, 
    '特等座': 0, 
    '一等座': 20, 
    '二等座': 23, 
    '高级软卧': 40, 
    '软卧': 0, 
    '硬卧': 32, 
    '软座': 0, 
    '硬座': 20, 
    '无座': 0, 
    '其它': 0
  }, function() {
      console.log('finished populating tickets');
    }
  );

});
