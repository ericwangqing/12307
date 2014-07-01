'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

/**
 * RemainTickets Schema
 */
var RemainTicketsSchema = new Schema(Object);

mongoose.model('RemainTickets', RemainTicketsSchema);