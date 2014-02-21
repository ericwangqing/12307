THRESHOLD_REMAIN_TICKETS = 10

angular.module '12307App' .filter 'showRemaind', ->
  (ticket-number)->
    if ticket-number > 0 then ticket-number else '-'

angular.module '12307App' .filter 'showRemainingTime', ->
  (time-in-milliseconds)->
    minutes = Math.floor time-in-milliseconds / 1000 / 60
    second = Math.floor time-in-milliseconds / 1000 - minutes * 60
    if minutes < 0 or second < 0
      minutes = second = 0
    "#minutes 分 #second 秒"

angular.module '12307App' .filter 'showRemainTickets', ->
  (number)->
    # number = parse-int str-number
    if number > THRESHOLD_REMAIN_TICKETS then '有票' else "#number 张"
