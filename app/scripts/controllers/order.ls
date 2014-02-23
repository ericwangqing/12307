angular.module('12307App').controller 'OrderCtrl', ($scope, $location, RemainTickets, Order) ->
  $scope.train = Order.get-order-train!
  $scope.travelers = [get-new-traveler!]

  initial-popup-title-for-submit-button!

  $scope.get-seat-type = ->
    [type for type in ['商务座', '特等座', '一等座', '二等座', '高级软卧', '软卧', '硬卧', '软座', '硬座', '无座', '其它'] when is-available-from-departure-to-terminal $scope.train, type]

  $scope.get-ticket-price = -> Order.get-ticket-price!

  $scope.add-row = -> $scope.travelers.push get-new-traveler!

  $scope.remove-row = (index)-> $scope.travelers.splice index, 1

  $scope.show-confirmation-dialog = !-> $ '#confirmation' .modal 'show' if is-valide-order $scope.travelers

  $scope.hide-confirmation-dialog = !-> $ '#confirmation' .modal 'hide'

  $scope.get-remain-tickets = Remain-tickets.get

  $scope.submit = ($event)!-> 
    $event.prevent-default!
    $scope.hide-confirmation-dialog!
    Order.make-order $scope.travelers, (err, is-success)!->
      if !is-success
        alert "make order 失败"
      else
        path = $location.path '/payment'


is-available-from-departure-to-terminal = (train, type)->
  is-available = true
  for station in train['经停站']
    is-passing = true if is-passing or station['站名'] is train.travel-departure['站名'] 
    if station['站名'] is train.travel-terminal['站名'] # 终点不计入
      is-passing = false
      break
    is-available = false if train.remain-tickets[type][station['站名']] < 1
  is-available
    


initial-popup-title-for-submit-button = !-> $ 'a.ui.blue.submit.large.button' .popup!

get-new-traveler = ->
  {seat-type:'硬座', ticket-type: '成人', id-type:'二代身份证'}

is-valide-order = (travelers)-> # TODO: 完善校验逻辑
  # for traveler in travelers
  #   return false if _.is-empty traveler.name or _.is-empty traveler.id or _.is-empty traveler.mobile-number
  true