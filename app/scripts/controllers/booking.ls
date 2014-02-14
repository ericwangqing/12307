angular.module('12307App').controller 'BookingCtrl', ($scope, Booking) ->
  $scope.ticket-train = Booking.get-booking-train!
  $scope.table-header-names = ['序号', '座席类别', '票种', '姓名', '证件类型', '证件号码', '手机号码', '']
  $scope.travelers = [get-new-traveler!]
  $scope.seat-types = ['软卧', '硬卧', '软座', '硬座']
  $scope.ticket-types = ['成人', '儿童']
  $scope.id-types = ['二代身份证', '一代身份证', '港澳通行证', '台湾通行证', '护照']

  $scope.add-row = ->
    $scope.travelers.push get-new-traveler!

  $scope.remove-row = (index)->
    $scope.travelers.splice index, 1

get-new-traveler = ->
  {seat-type:'硬座', ticket-type: '成人', id-type:'二代身份证'}
