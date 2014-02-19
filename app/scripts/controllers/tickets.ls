'use strict'

# _ = require 'underscore'

all-tickets = null
trains-promise = null

angular.module('12307App').controller 'TicketsCtrl', ($scope, $location, Tickets, Trains, Booking) ->
  initial-drop-downs!
  
  Trains.then (promise)-> # 获取车次和余票数据
    trains-promise := promise
    update-tickets Tickets, $scope, ->
      $scope.condition = {}

      $scope.query = !->
        update-tickets Tickets, $scope, ->
          $scope.tickets = [ticket for ticket in all-tickets when satisfy ticket, $scope.condition]

      $scope.book = ($event)!->
        train-id = $($event.target).attr 'value'
        Booking.set-booking-train get-train-ticket-by-id train-id
        console.log "booking ticket for: ", Booking.get-booking-train!


initial-drop-downs = !->
  $ '.ui.dropdown' .dropdown!

  # $http.get '/api/Tickets' .success (tickets)->
  #   $scope.tickets = tickets

combine-trains-tickets = (trains, tickets)->
  results = []
  for train in trains
    for ticket in tickets
      results.push extend-ticket train, ticket
  results

extend-ticket = (train, ticket)->
  # _.extend ticket, train if ticket['车次'] is train['车次']
  [departure, ...passes, terminal] = train['经停站'] .map -> it['站名']
  _train =
     '车次': train['车次']
     '出发站/到达站': "#{departure}/#{terminal}"
     '经停站': [departure] ++ passes ++ [terminal]
     '出发时间/到达时间': "#{train['经停站'][0]['出发']} ~ #{train['经停站'][train['经停站'].length - 1]['到达']}"
     '历时': get-travel-time train
  _.extend _train, ticket

get-travel-time = (train)!->
  [departure-hours, departure-minutes] = train['经停站'][0]['出发'].split ':' .map -> parse-int it
  [arrival-hours, arrival-minutes] = train['经停站'][train['经停站'].length - 1]['到达'].split ':' .map -> parse-int it
  arrival-day = parse-int train['经停站'][train['经停站'].length - 1]['第几天'] 
  _minutes = arrival-minutes - departure-minutes
  hours = (arrival-day - 1) * 24 + arrival-hours - departure-hours
  if _minutes > 0 
    minutes = _minutes
  else 
    minutes = 60 + minutes
    hours -=  1 
  "#hours:#minutes"

satisfy = (ticket, condition)->
  (!condition['出发地'] or condition['出发地'] in ticket['经停站']) and (!condition['目的地'] or condition['目的地'] in ticket['经停站'])


update-tickets = (Tickets, $scope, callback)->
  trains = trains-promise.data
  tickets = Tickets.query -> 
    $scope.tickets = all-tickets := combine-trains-tickets trains, tickets
    callback!

get-train-ticket-by-id = (train-id)->
  for ticket in all-tickets
    return ticket if ticket['车次'] is train-id