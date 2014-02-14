'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;



/**
 * Train Schema
 */
var TrainSchema = new Schema({
  '车次': String,
  '出发站/到达站': String,
  '出发时间/到达时间': String,
  '经停站': Array,
  '历时': String
});

mongoose.model('Train', TrainSchema);