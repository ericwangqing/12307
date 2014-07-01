'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;



/**
 * Train Schema
 */
var TrainSchema = new Schema({
  '车次': String,
  '类型':  String,
  '经停站': Array
});

mongoose.model('Train', TrainSchema);