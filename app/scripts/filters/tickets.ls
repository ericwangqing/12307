angular.module '12307App' .filter 'showRemaind', ->
  (ticket-number)->
    if ticket-number > 0 then ticket-number else '-'