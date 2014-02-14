angular.module '12307FullApp' .filter 'showRemaind', ->
  (ticket-number)->
    if ticket-number > 0 then ticket-number else '-'