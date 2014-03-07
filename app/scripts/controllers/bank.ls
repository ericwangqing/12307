FOURTY_FIVE_MINUTES = 45 * 60 * 1000

angular.module('12307App').controller 'BankCtrl', ($scope, $interval, $location, Order) ->
  $scope.order = Order.get-order!
  