# require! ['mongoose', 'async', 'mongodb'.Db, 'mongodb'.Server, 'mongodb'.MongoClient]
require! ['mongoose', 'async']
_ = require 'underscore'

mongo =
  host: \localhost
  port: 27018 # mongoDB default
  db: \agile-workflow
  write-concern: -1 # 'majority' , MongoDB在write concern上又变化，这里需要进一步查清如何应对。-1就是以前的safe。

# REMAIN_TICKETS_COLLECTION_NAME = 'remain-tickets'
SALE_DAYS = ['2014-03-0' + i for i in [1 to 9]].concat ['2014-03-' + i for i in [10 to 14]]
TEST_DAY = '2014-03-01'

class Tickets-manager
  @instance = null
  @get-instance = ->
    @instance = new Tickets-manager! if !@instance
    @instance

  init: (done)->
    <~! @load-trains
    <~! @load-remain-tickets
    console.log "tickets manager initialized"
    done!

  load-trains: (callback)!~>
    Train = mongoose.model('Train')
    Train.find (err, @trains)!~>
      throw err if err
      if _.is-empty @trains
        (@trains) <~! require '../config/data-process' .create

        <~! Train.collection.insert @trains, {}
        callback!
      else
        callback!

  load-remain-tickets: (done)!~> # 这里或许直接用mongodb，以便能够更加灵活地读取 
    # async.each SALE_DAYS, (day, callback)!~>
    #   (err, remain-tickets) <~! @con.collection (REMAIN_TICKETS_COLLECTION_NAME + ':' + day) .find {} .to-array
    #   remain-tickets-of-day = remain-tickets or @initial-remain-tickets!
    #   @remain-tickets[day] = remain-tickets-of-day
    #   callback!
    # , done
    query = mongoose.model('RemainTickets').find {} .sort '车次' .limit 10000
    query.exec (err, @remain-tickets)!~>
      @initial-remain-tickets! if _.is-empty @remain-tickets
      done!

  initial-remain-tickets: !-> [@remain-tickets[day] = @create-remain-tickets-for-a-day! for day in SALE_DAYS]

  create-remain-tickets-for-a-day: ->
    tickets = {}
    for train in @trains
      tickets[train['车次']] = create-remain-tickets-for-train train
    tickets

  order-ticket: (order)->
    tid = order.train['车次']
    departure = order.train.travel-departure['站名']
    terminal = order.train.travel-terminal['站名']
    seat-type = order.travelers.0.seat-type
    ticket-amount = order.travelers.length
    stations = @get-stations-between-departure-and-terminal tid, departure, terminal
    return false if _.is-empty stations

    train-tickets = @remain-tickets[TEST_DAY][tid][seat-type]
    for station in stations
      return false if train-tickets[station] < ticket-amount
    for station in stations
      console.log "train-tickets: ", train-tickets
      train-tickets[station] -= ticket-amount
      console.log "#station: #{train-tickets[station]}"
    true

  get-stations-between-departure-and-terminal: (tid, departure, terminal)->
    stations = []
    for train in @trains
      if train['车次'] is tid
        all-stations = train['经停站']
        break
    for station in all-stations
      isPassing = true if isPassing or station['站名'] is departure 
      stations.push station['站名']
      if station['站名'] is terminal
        isPassing = false
        break
    stations 


  get-all-remain-tickets: -> @remain-tickets[TEST_DAY]




# dev-trains = require '../config/data-process'
# trains-data = null
# tickets = 



# init = (callback)!->
#   dev-trains.create (trains)!->



# get-all-remain-tickets = (callback)!->
#   if !trains-data
#     dev-trains.create (trains)!->
#       trains-data := trains
#       callback create-remain-tickets-for-trains!
#   else
#     callback create-remain-tickets-for-trains!

# create-remain-tickets-for-trains = ->

create-remain-tickets-for-train = (train)->
  # '车次': train['车次']
  # '日期': '2013-02-04' 
  '商务座': create-remain-tickets-for-seat-type train, 10 
  '特等座': create-remain-tickets-for-seat-type train, 0 
  '一等座': create-remain-tickets-for-seat-type train, 20 
  '二等座': create-remain-tickets-for-seat-type train, 23 
  '高级软卧': create-remain-tickets-for-seat-type train, 40 
  '软卧': create-remain-tickets-for-seat-type train, 0 
  '硬卧': create-remain-tickets-for-seat-type train, 32 
  '软座': create-remain-tickets-for-seat-type train, 0 
  '硬座': create-remain-tickets-for-seat-type train, 20000 
  '无座': create-remain-tickets-for-seat-type train, 0 
  '其它': create-remain-tickets-for-seat-type train, 0

create-remain-tickets-for-seat-type = (train, number)->
  result = {}
  for station in train['经停站']
    result[station['站名']] = number
  result


module.exports = {get-instance: Tickets-manager.get-instance}