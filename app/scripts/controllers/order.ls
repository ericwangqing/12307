angular.module('12307App').controller 'OrderCtrl', ($scope, Order) ->
  $scope.train = Order.get-order-train!
  $scope.travelers = [get-new-traveler!]

  initial-popup-title-for-submit-button!

  $scope.get-seat-type = ->
    [type for type in ['商务座', '特等座', '一等座', '二等座', '高级软卧', '软卧', '硬卧', '软座', '硬座', '无座', '其它'] when $scope.train[type] > 0]

  $scope.get-ticket-price = -> Order.get-ticket-price!

  $scope.add-row = -> $scope.travelers.push get-new-traveler!

  $scope.remove-row = (index)-> $scope.travelers.splice index, 1

  $scope.show-confirmation-dialog = !-> $ '#confirmation' .modal 'show' if is-valide-order $scope.travelers

  $scope.hide-confirmation-dialog = !-> $ '#confirmation' .modal 'hide'

  $scope.submit = ($event)!-> 
    $scope.hide-confirmation-dialog!
    Order.make-order $scope.travelers, (is-success)!->
      if !is-success
        $event.prevent-default!
        alert "make order 失败"
        $scope.hide-confirmation-dialog!




initial-popup-title-for-submit-button = !-> $ 'a.ui.blue.submit.large.button' .popup!

get-new-traveler = ->
  {seat-type:'硬座', ticket-type: '成人', id-type:'二代身份证'}

is-valide-order = (travelers)-> # TODO: 完善校验逻辑
  # for traveler in travelers
  #   return false if _.is-empty traveler.name or _.is-empty traveler.id or _.is-empty traveler.mobile-number
  true