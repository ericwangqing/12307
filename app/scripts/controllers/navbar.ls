'use strict'

preload-trains-data = (Tickets)->


angular.module('12307App')
.controller 'NavbarCtrl', ($scope, $location, Auth, Menu) ->
  $scope.menu = Menu.get-menu!

  
  $scope.logout = ->
    Auth.logout!then ->
      $scope.menu = Menu.get-menu!
      $location.path "/login" 
  
  $scope.isActive = (route) ->
    route is $location.path()