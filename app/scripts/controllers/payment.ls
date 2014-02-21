FOURTY_FIVE_MINUTES = 45 * 60 * 1000

angular.module('12307App').controller 'PaymentCtrl', ($scope, $interval, Order) ->
  $scope.order = Order.get-order!
  update-remaining-time-every-second $scope, $interval

  $scope.get-order-price = -> 'xxx' # TODO:

  $scope.show-banks-list = !-> $ '#banksList' .modal 'show'

  $scope.cancel-order = !-> # TODO:

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
