FOURTY_FIVE_MINUTES = 45 * 60 * 1000

angular.module('12307App').controller 'PaymentCtrl', ($scope, $interval, $location, Order) ->
  $scope.order = Order.get-order!
  update-remaining-time-every-second $scope, $interval

  $scope.get-price = (traveler)-> 
    distance = $scope.order.train.travel-terminal['里程'] - $scope.order.train.travel-departure['里程'] if $scope.order
    traveler.price = get-price traveler.seat-type, distance
  
  $scope.get-order-price = ->
    $scope.order.price = [traveler.price for traveler in $scope.order.travelers].reduce (+) if $scope.order


  $scope.show-banks-list = !-> $ '#banksList' .modal 'show'

  $scope.hide-banks-list = !-> $ '#banksList' .modal 'hide'

  $scope.go-bank = !-> 
    $scope.hide-banks-list!
    $location.path '/3rd-bank' 

  $scope.cancel-order = !-> # TODO: 需要发送请求给server取消订单
    delete $scope.order
    $location.path '/trains'

update-remaining-time-every-second = ($scope, $interval)!->
  calculate-remaining-time $scope
  interval-id = $interval !->
    if $scope.remaining-time < 0
      $interval.cancel interval-id 
      $scope.cancel-order!
    else
      calculate-remaining-time $scope
  , 1000

calculate-remaining-time = ($scope)!->
  order-time = if $scope.order then $scope.order.order-time else 0
  $scope.remaining-time = FOURTY_FIVE_MINUTES - (Date.now! - order-time)

get-price = (seat-type, distance)-> # TODO: 给出真实价格的计算公式
  distance ||= 0
  distance * 0.5