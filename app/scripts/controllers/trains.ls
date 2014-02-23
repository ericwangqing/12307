'use strict'

all-trains = null
satisfied-trains = null
amount-of-trains-in-a-batch-for-showing = 50
is-shown-trains-updating = false # 页面上的trains列表，在一次更新未完成前，不能够再更新，以免用户多次操作后，一下显示全部trains（特别是滚动）

angular.module('12307App').controller 'TrainsCtrl', ($scope, $location, $timeout, Tickets, Trains, Remain-tickets, Order) ->
  
  Trains.then (promise)-> # 获取车次和余票数据
    update-scope-trains Tickets, promise.data, $scope, $timeout, ->
      $scope.condition = {}

      $scope.query = !->
        update-scope-trains Tickets, promise.data, $scope, $timeout, ->
          satisfied-trains := [train for train in all-trains when satisfy-and-update-departure-and-terminal train, $scope.condition]

      $scope.book = ($event)!->
        train-id = $($event.target).attr 'value'
        Order.set-order-train get-satisfied-train-by-id train-id
        console.log "order ticket for: ", Order.get-order-train!

      $scope.show-more = !-> 
        if !is-shown-trains-updating 
          is-shown-trains-updating := true
          show-next-batch-of-trains $scope, $timeout

      $scope.show-train-info = ($event)!->
        $($event.target).find '.ui.modal' .modal 'show'   

      $scope.get-remain-tickets = Remain-tickets.get
      $scope.get-travel-time = get-travel-time

      initial-semantic-ui-drop-downs!
      initial-scroll-show-more-listener $scope

update-scope-trains = (Tickets, trains, $scope, $timeout, callback)->
  if !all-trains 
    Tickets.then (promise)-> 
      tickets = promise.data
      satisfied-trains := all-trains := combine-trains-tickets trains, tickets
      callback!
      show-next-batch-of-trains $scope, $timeout, reset = true
  else
    satisfied-trains := all-trains
    callback!
    show-next-batch-of-trains $scope, $timeout, reset = true

combine-trains-tickets = (trains, tickets)->
  for train in trains
    train.remain-tickets = tickets[train['车次']]
    set-initial-travel-departure-and-terminal-as-start-and-end-of-train train
  trains

set-initial-travel-departure-and-terminal-as-start-and-end-of-train = (train)->
  train.travel-departure = train['经停站'][0]
  train.travel-terminal = train['经停站'][train['经停站'].length - 1]

show-next-batch-of-trains = do ->
  batch = amount-of-trains-in-a-batch-for-showing
  [start-index, end-index] = [0, batch - 1]
  ($scope, $timeout, reset = false) -> 
    if reset
      [start-index, end-index] := [0, batch - 1]
      $scope.trains = []

    $scope.trains ||= []
    $scope.trains ++= satisfied-trains[start-index to end-index]

    $scope.unshown-trains-number = satisfied-trains.length - end-index - 1 
    $scope.unshown-trains-number = 0 if $scope.unshown-trains-number < 0

    start-index += batch
    end-index += batch
    end-index := satisfied-trains.length - 1 if end-index > satisfied-trains.length - 1 

    $timeout !-> # 在AngularJS rendered之后，避免多个scroll事件都触发show-next-batch-of-trains
      is-shown-trains-updating := false

satisfy-and-update-departure-and-terminal = (train, condition)->
  if (
    (!condition['出发地'] or (departure = get-station-by-name condition['出发地'], train, '出发')) and 
    (!condition['目的地'] or (terminal = get-station-by-name condition['目的地'], train, '到达'))  
  ) and (is-departure-ahead-of-terminal departure, terminal)
    train.travel-departure = departure if departure
    train.travel-terminal = terminal if terminal
    true
  else
    false

get-station-by-name = (station-name, train, direction)->
  stations = if direction is '出发' then train['经停站'][0 to -2] else train['经停站'][1 to -1]
  for station in stations
    return station if (station['站名'].index-of station-name) >= 0

is-departure-ahead-of-terminal = (departure, terminal)->
  return true if !departure or !terminal
  (parse-int departure['里程']) < (parse-int terminal['里程'])

get-satisfied-train-by-id = (train-id)->
  for ticket in satisfied-trains
    return ticket if ticket['车次'] is train-id

get-travel-time = (departure, terminal)->
  [departure-hours, departure-minutes] = departure['出发'].split ':' .map -> parse-int it
  [arrival-hours, arrival-minutes] = terminal['到达'].split ':' .map -> parse-int it
  arrival-day = parse-int terminal['第几天'] 
  calculate-travel-time departure-hours, departure-minutes, arrival-hours, arrival-minutes, arrival-day

calculate-travel-time = (departure-hours, departure-minutes, arrival-hours, arrival-minutes, arrival-day)->
  _minutes = arrival-minutes - departure-minutes
  hours = (arrival-day - 1) * 24 + arrival-hours - departure-hours
  if _minutes > 0 
    minutes = _minutes
  else 
    minutes = 60 + _minutes
    hours -=  1 
  "#{padding hours}:#{padding minutes}"

padding = (number)->
  if number < 10 then '0' + number else '' + number

initial-semantic-ui-drop-downs = !->  $ '.ui.dropdown' .dropdown!

initial-scroll-show-more-listener = ($scope)!->
  BOUNCING_DELTA = 100 # 加上余量，避免一到底部就直接加载，导致事实上看不清滚动加载的效果。
  $ window .scroll !->
    if document.document-element.client-height + $(document).scroll-top() >= document.body.offset-height + BOUNCING_DELTA
      $scope.show-more!
