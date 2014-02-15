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
    name : '轻量级高性能',
    info : '鱼与熊掌兼得。展示如何使用新一代Web计算技术，用一台笔记本作为服务器，应对12306这样高访问量、高动态的应用。',
    awesomeness: 10
  }, {
    name : '敏捷开发',
    info : '运行效率和开发效率同样出色。把握敏捷思想精髓，善用BDD，追求经济合理的软件过程。',
    awesomeness: 10
  }, {
    name : 'Literal Programming',
    info : '拥抱Declarative Programming和Dynamic Languages，践行“开发就是思考、思考即是程序”的方法学，创造高质量软件。',
    awesomeness: 10
  }, {
    name : '应用设计（待推出）',
    info : '真正以用户为中心的软件设计与开发，一切从应用设计开始，力求给用户最佳体验。',
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
