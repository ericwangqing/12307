'use strict'

preload-trains-data = (Tickets)->


angular.module('12307App')
.controller 'NavbarCtrl', ($scope, $location, Auth, Trains) ->
  $scope.menu = 
    * title: 'Home'
      link: '/'
    * title: '12307'
      link: '/12307'
    * title: '车票预订'
      link: '/tickets'
    * title: 'Settings'
      link: '/settings'
  
  $scope.logout = ->
    Auth.logout!then ->
      $location.path "/login"
  
  $scope.isActive = (route) ->
    route is $location.path()