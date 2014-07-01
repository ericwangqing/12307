(function(){
  var mongoose, async, _, mongo, SALE_DAYS, i, TEST_DAY, TicketsManager, createRemainTicketsForTrain, createRemainTicketsForSeatType;
  mongoose = require('mongoose');
  async = require('async');
  _ = require('underscore');
  mongo = {
    host: 'localhost',
    port: 27018,
    db: 'agile-workflow',
    writeConcern: -1
  };
  SALE_DAYS = (function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = [1, 2, 3, 4, 5, 6, 7, 8, 9]).length; i$ < len$; ++i$) {
      i = ref$[i$];
      results$.push('2014-03-0' + i);
    }
    return results$;
  }()).concat((function(){
    var i$, ref$, len$, results$ = [];
    for (i$ = 0, len$ = (ref$ = [10, 11, 12, 13, 14]).length; i$ < len$; ++i$) {
      i = ref$[i$];
      results$.push('2014-03-' + i);
    }
    return results$;
  }()));
  TEST_DAY = '2014-03-01';
  TicketsManager = (function(){
    TicketsManager.displayName = 'TicketsManager';
    var prototype = TicketsManager.prototype, constructor = TicketsManager;
    TicketsManager.instance = null;
    TicketsManager.getInstance = function(){
      if (!this.instance) {
        this.instance = new TicketsManager();
      }
      return this.instance;
    };
    prototype.init = function(done){
      var this$ = this;
      return this.loadTrains(function(){
        this$.loadRemainTickets(function(){
          console.log("tickets manager initialized");
          done();
        });
      });
    };
    prototype.loadTrains = function(callback){
      var Train, this$ = this;
      Train = mongoose.model('Train');
      Train.find(function(err, trains){
        this$.trains = trains;
        if (err) {
          throw err;
        }
        if (_.isEmpty(this$.trains)) {
          require('../config/data-process').create(function(trains){
            this$.trains = trains;
            Train.collection.insert(this$.trains, {}, function(){
              callback();
            });
          });
        } else {
          callback();
        }
      });
    };
    prototype.loadRemainTickets = function(done){
      var query, this$ = this;
      query = mongoose.model('RemainTickets').find({}).sort('车次').limit(10000);
      query.exec(function(err, remainTickets){
        this$.remainTickets = remainTickets;
        if (_.isEmpty(this$.remainTickets)) {
          this$.initialRemainTickets();
        }
        done();
      });
    };
    prototype.initialRemainTickets = function(){
      var i$, ref$, len$, day;
      for (i$ = 0, len$ = (ref$ = SALE_DAYS).length; i$ < len$; ++i$) {
        day = ref$[i$];
        this.remainTickets[day] = this.createRemainTicketsForADay();
      }
    };
    prototype.createRemainTicketsForADay = function(){
      var tickets, i$, ref$, len$, train;
      tickets = {};
      for (i$ = 0, len$ = (ref$ = this.trains).length; i$ < len$; ++i$) {
        train = ref$[i$];
        tickets[train['车次']] = createRemainTicketsForTrain(train);
      }
      return tickets;
    };
    prototype.orderTicket = function(order){
      var tid, departure, terminal, seatType, ticketAmount, stations, trainTickets, i$, len$, station;
      tid = order.train['车次'];
      departure = order.train.travelDeparture['站名'];
      terminal = order.train.travelTerminal['站名'];
      seatType = order.travelers[0].seatType;
      ticketAmount = order.travelers.length;
      stations = this.getStationsBetweenDepartureAndTerminal(tid, departure, terminal);
      if (_.isEmpty(stations)) {
        return false;
      }
      trainTickets = this.remainTickets[TEST_DAY][tid][seatType];
      for (i$ = 0, len$ = stations.length; i$ < len$; ++i$) {
        station = stations[i$];
        if (trainTickets[station] < ticketAmount) {
          return false;
        }
      }
      for (i$ = 0, len$ = stations.length; i$ < len$; ++i$) {
        station = stations[i$];
        console.log("train-tickets: ", trainTickets);
        trainTickets[station] -= ticketAmount;
        console.log(station + ": " + trainTickets[station]);
      }
      return true;
    };
    prototype.getStationsBetweenDepartureAndTerminal = function(tid, departure, terminal){
      var stations, i$, ref$, len$, train, allStations, station, isPassing;
      stations = [];
      for (i$ = 0, len$ = (ref$ = this.trains).length; i$ < len$; ++i$) {
        train = ref$[i$];
        if (train['车次'] === tid) {
          allStations = train['经停站'];
          break;
        }
      }
      for (i$ = 0, len$ = allStations.length; i$ < len$; ++i$) {
        station = allStations[i$];
        if (isPassing || station['站名'] === departure) {
          isPassing = true;
        }
        stations.push(station['站名']);
        if (station['站名'] === terminal) {
          isPassing = false;
          break;
        }
      }
      return stations;
    };
    prototype.getAllRemainTickets = function(){
      return this.remainTickets[TEST_DAY];
    };
    function TicketsManager(){
      this.loadRemainTickets = bind$(this, 'loadRemainTickets', prototype);
      this.loadTrains = bind$(this, 'loadTrains', prototype);
    }
    return TicketsManager;
  }());
  createRemainTicketsForTrain = function(train){
    return {
      '商务座': createRemainTicketsForSeatType(train, 10),
      '特等座': createRemainTicketsForSeatType(train, 0),
      '一等座': createRemainTicketsForSeatType(train, 20),
      '二等座': createRemainTicketsForSeatType(train, 23),
      '高级软卧': createRemainTicketsForSeatType(train, 40),
      '软卧': createRemainTicketsForSeatType(train, 0),
      '硬卧': createRemainTicketsForSeatType(train, 32),
      '软座': createRemainTicketsForSeatType(train, 0),
      '硬座': createRemainTicketsForSeatType(train, 20000),
      '无座': createRemainTicketsForSeatType(train, 0),
      '其它': createRemainTicketsForSeatType(train, 0)
    };
  };
  createRemainTicketsForSeatType = function(train, number){
    var result, i$, ref$, len$, station;
    result = {};
    for (i$ = 0, len$ = (ref$ = train['经停站']).length; i$ < len$; ++i$) {
      station = ref$[i$];
      result[station['站名']] = number;
    }
    return result;
  };
  module.exports = {
    getInstance: TicketsManager.getInstance
  };
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
