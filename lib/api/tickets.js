(function(){
  var devTrains, trainsData, getAllRemainTickets, createRemainTicketsForTrains, createRemainTicketForTrain;
  devTrains = require('../config/data-process');
  trainsData = null;
  getAllRemainTickets = function(callback){
    if (!trainsData) {
      devTrains.create(function(trains){
        trainsData = trains;
        callback(createRemainTicketsForTrains());
      });
    } else {
      callback(createRemainTicketsForTrains());
    }
  };
  createRemainTicketsForTrains = function(){
    var tickets, i$, ref$, len$, train;
    tickets = {};
    for (i$ = 0, len$ = (ref$ = trainsData).length; i$ < len$; ++i$) {
      train = ref$[i$];
      tickets[train['车次']] = createRemainTicketForTrain(train);
    }
    return tickets;
  };
  createRemainTicketForTrain = function(train){
    return {
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
    };
  };
  module.exports = {
    getAllRemainTickets: getAllRemainTickets
  };
}).call(this);
