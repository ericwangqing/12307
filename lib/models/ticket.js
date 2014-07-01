'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;



/**
 * Ticket Schema
 */
var TicketSchema = new Schema({
  '车次': String,
  '日期': String,
  '商务座': Number,
  '特等座': Number,
  '一等座': Number,
  '二等座': Number,
  '高级软卧': Number,
  '软卧': Number,
  '硬卧': Number,
  '软座': Number,
  '硬座': Number,
  '无座': Number,
  '其它': Number
});

mongoose.model('Ticket', TicketSchema);