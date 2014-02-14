'use strict'

RESULTS-TABLE-HEADER-COLUMNS-NAMES = ['车次', '出发站/到达站', '出发时间/到达时间', '历时', '商务座', '特等座', '一等座', '二等座', '高级软卧', '软卧', '硬卧', '软座', '硬座', '无座', '其它', '操作']
all-tickets = null
trains-promise = null

angular.module('12307App').controller 'TicketsCtrl', ($scope, $location, Tickets, Trains, Booking) ->
  $ '.ui.dropdown' .dropdown!
  $scope.table-header-names = RESULTS-TABLE-HEADER-COLUMNS-NAMES
  Trains.then (promise)->
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



  # $http.get '/api/Tickets' .success (tickets)->
  #   $scope.tickets = tickets

combine-trains-tickets = (trains, tickets)->
  for ticket in tickets
    for train in trains
      if ticket['车次'] is train['车次']
        _.extend ticket, train

  tickets


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