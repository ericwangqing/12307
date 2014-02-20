dev-trains = require '../config/data-process'
trains-data = null

get-all-remain-tickets = (callback)!->
  if !trains-data
    dev-trains.create (trains)!->
      trains-data := trains
      callback create-remain-tickets-for-trains!
  else
    callback create-remain-tickets-for-trains!

create-remain-tickets-for-trains = ->
  tickets = {}
  for train in trains-data
    tickets[train['车次']] = create-remain-ticket-for-train train
  tickets

create-remain-ticket-for-train = (train)->
  # '车次': train['车次']
  '日期': '2013-02-04' 
  '商务座': 10 
  '特等座': 0 
  '一等座': 20 
  '二等座': 23 
  '高级软卧': 40 
  '软卧': 0 
  '硬卧': 32 
  '软座': 0 
  '硬座': 20 
  '无座': 0 
  '其它': 0


module.exports = {get-all-remain-tickets} 