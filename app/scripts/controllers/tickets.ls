'use strict'

TICKETS-TABLE-HEADER-COLUMNS-NAMES = ['车次', '出发站/到达站', '出发时间/到达时间', '历时', '商务座', '特等座', '一等座', '二等座', '高级软卧', '软卧', '硬卧', '软座', '硬座', '无座', '其它', '操作']

angular.module('12307FullApp').controller 'TicketsCtrl', ($scope, Tickets, Trains) ->
  $ '.ui.dropdown' .dropdown!
  $scope.table-header-names = TICKETS-TABLE-HEADER-COLUMNS-NAMES
  trains = Trains.query ->
    tickets = Tickets.query -> 
      $scope.tickets = combine-trains-tickets trains, tickets
  # $http.get '/api/Tickets' .success (tickets)->
  #   $scope.tickets = tickets

combine-trains-tickets = (trains, tickets)->
  for ticket in tickets
    for train in trains
      if ticket['车次'] is train['车次']
        _.extend ticket, train

  tickets