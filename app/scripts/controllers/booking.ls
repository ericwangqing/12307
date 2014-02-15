angular.module('12307App').controller 'BookingCtrl', ($scope, Booking) ->
  $scope.ticket-train = Booking.get-booking-train!
  $scope.travelers = [get-new-traveler!]

  initial-popup-title-for-submit-button!

  $scope.add-row = -> $scope.travelers.push get-new-traveler!

  $scope.remove-row = (index)-> $scope.travelers.splice index, 1

  $scope.show-confirmation-dialog = !-> $ '#confirmation' .modal 'show' if is-valide-booking $scope.travelers

  $scope.hide-confirmation-dialog = !-> $ '#confirmation' .modal 'hide'

  $scope.submit = !-> 
    $scope.hide-confirmation-dialog!
    Booking.make-order $scope.travelers




initial-popup-title-for-submit-button = !-> $ 'a.ui.blue.submit.large.button' .popup!

get-new-traveler = ->
  {seat-type:'硬座', ticket-type: '成人', id-type:'二代身份证'}

is-valide-booking = (travelers)->
  for traveler in travelers
    return false if _.is-empty traveler.name or _.is-empty traveler.id or _.is-empty traveler.mobile-number
  true