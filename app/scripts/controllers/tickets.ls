'use strict'

# _ = require 'underscore'

all-tickets = null
satisfied-tickets = null
trains-promise = null
show-tickets-at-initial = 50
is-shown-tickets-updating = false # 页面上的ticket列表，在一次更新未完成前，不能够再更新，以免用户多次操作后，一下显示全部tickets（特别是滚动）

angular.module('12307App').controller 'TicketsCtrl', ($scope, $location, $timeout, Tickets, Trains, Booking) ->
  
  Trains.then (promise)-> # 获取车次和余票数据
    trains-promise := promise
    update-tickets Tickets, $scope, $timeout, ->
      $scope.condition = {}

      $scope.query = !->
        update-tickets Tickets, $scope, $timeout, ->
          satisfied-tickets := [ticket for ticket in all-tickets when satisfy ticket, $scope.condition]

      $scope.book = ($event)!->
        train-id = $($event.target).attr 'value'
        Booking.set-booking-train get-train-ticket-by-id train-id
        console.log "booking ticket for: ", Booking.get-booking-train!

      $scope.show-more = !-> 
        if !is-shown-tickets-updating 
          is-shown-tickets-updating := true
          select-tickets-shows $scope, $timeout

      $scope.show-train-info = ($event)!->
        $($event.target).find '.ui.modal' .modal 'show'        


      $scope.get-travel-time = get-travel-time

      initial-drop-downs!
      initial-show-more $scope, $timeout



initial-drop-downs = !->
  $ '.ui.dropdown' .dropdown!

initial-show-more = ($scope)!->
  $ window .scroll !->
    if document.document-element.client-height + $(document).scroll-top() >= document.body.offset-height + 100
      $scope.show-more!

combine-trains-tickets = (trains, tickets)->
  results = []
  for train in trains
    results.push extend-ticket train, tickets[train['车次']]
  results

extend-ticket = (train, ticket)->
  train.travel-departure = train['经停站'][0]
  train.travel-terminal = train['经停站'][train['经停站'].length - 1]
  _.extend train, ticket

get-travel-time = (departure, terminal)->
  [departure-hours, departure-minutes] = departure['出发'].split ':' .map -> parse-int it
  [arrival-hours, arrival-minutes] = terminal['到达'].split ':' .map -> parse-int it
  arrival-day = parse-int terminal['第几天'] 
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

satisfy = (ticket, condition)->
  if (
    (!condition['出发地'] or (departure = get-station-by-name condition['出发地'], ticket, '出发')) and 
    (!condition['目的地'] or (terminal = get-station-by-name condition['目的地'], ticket, '到达'))  
  ) and (is-departure-ahead-of-terminal departure, terminal)
    ticket.travel-departure = departure if departure
    ticket.travel-terminal = terminal if terminal
    true
  else
    false

is-departure-ahead-of-terminal = (departure, terminal)->
  return true if !departure or !terminal
  (parse-int departure['里程']) < (parse-int terminal['里程'])

get-station-by-name = (station-name, ticket, direction)->
  stations = if direction is '出发' then ticket['经停站'][0 to -2] else ticket['经停站'][1 to -1]
  for station in stations
    return station if (station['站名'].index-of station-name) >= 0
  null

update-tickets = (Tickets, $scope, $timeout, callback)->
  trains = trains-promise.data
  if !all-tickets
    Tickets.then (promise)-> 
      tickets = promise.data
      satisfied-tickets := all-tickets := combine-trains-tickets trains, tickets
      callback!
      select-tickets-shows $scope, $timeout, reset = true
  else
    satisfied-tickets := all-tickets
    callback!
    select-tickets-shows $scope, $timeout, reset = true

select-tickets-shows = do ->
  start-index = 0
  end-index = show-tickets-at-initial - 1
  ($scope, $timeout, reset = false) -> 
    if reset
      start-index := 0
      end-index := show-tickets-at-initial - 1
      $scope.tickets = []
    $scope.tickets ||= []
    $scope.tickets ++= satisfied-tickets[start-index to end-index]
    $scope.unshown-tickets-number = satisfied-tickets.length - end-index - 1 
    $scope.unshown-tickets-number = 0 if $scope.unshown-tickets-number < 0
    start-index += show-tickets-at-initial
    end-index += show-tickets-at-initial
    end-index := satisfied-tickets.length - 1 if end-index > satisfied-tickets.length - 1 
    $timeout !->
      is-shown-tickets-updating := false



get-train-ticket-by-id = (train-id)->
  for ticket in satisfied-tickets
    return ticket if ticket['车次'] is train-id