(function(){
  var DATA_SOURCE, DATA_FILE, fs, _, createTrainData, getTrains, getTrainLines, extractTrains;
  DATA_SOURCE = __dirname + '/2013-11-12列车.sql';
  DATA_FILE = __dirname + '/data.json';
  fs = require('fs');
  _ = require('underscore');
  createTrainData = function(callback){
    fs.readFile(DATA_SOURCE, {
      encoding: 'utf8'
    }, function(err, data){
      var trains;
      if (err) {
        throw err;
      }
      trains = getTrains(data);
      callback(trains);
    });
  };
  getTrains = function(data){
    var trainLines;
    trainLines = getTrainLines(data);
    return extractTrains(trainLines);
  };
  getTrainLines = function(data){
    var trainLines, sqlLines, i$, len$, line, trainLine;
    trainLines = [];
    sqlLines = data.split('\n');
    for (i$ = 0, len$ = sqlLines.length; i$ < len$; ++i$) {
      line = sqlLines[i$];
      trainLine = line.match(/.+\((.+)\)/)[1];
      trainLines.push(trainLine);
    }
    return trainLines;
  };
  extractTrains = function(trainLines){
    var trains, i$, len$, line, tokens, res$, j$, ref$, len1$, token;
    trains = {};
    for (i$ = 0, len$ = trainLines.length; i$ < len$; ++i$) {
      line = trainLines[i$];
      res$ = [];
      for (j$ = 0, len1$ = (ref$ = line.split(/,\s/)).length; j$ < len1$; ++j$) {
        token = ref$[j$];
        res$.push(token.substr(1, token.length - 2));
      }
      tokens = res$;
      if (!trains[tokens[0]]) {
        trains[tokens[0]] = {
          '车次': tokens[0],
          '类型': tokens[1],
          '经停站': []
        };
      }
      trains[tokens[0]]['经停站'][parseInt(tokens[3]) - 1] = {
        '站名': tokens[2],
        '里程': tokens[7],
        '第几天': tokens[4],
        '出发': tokens[6],
        '到达': tokens[5]
      };
    }
    return _.values(trains);
  };
  module.exports = {
    create: createTrainData
  };
}).call(this);
