FOURTY_FIVE_MINUTES = 45 * 60 * 1000

angular.module('12307App').controller 'PaymentCtrl', ($scope, $interval, Booking) ->
  $scope.order = Booking.get-order!
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
  booking-time = if $scope.order then $scope.order.booking-time else 0
  $scope.remaining-time = FOURTY_FIVE_MINUTES - (Date.now! - booking-time)
