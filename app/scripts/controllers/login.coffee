'use strict'

angular.module('12307App')
  .controller 'LoginCtrl', ($scope, $location, Auth) ->
    $scope.user = {}
    $scope.errors = {}

    $scope.login = (form) ->
      $scope.submitted = true
      
      if form.$valid
        Auth.login(
          email: $scope.user.email
          password: $scope.user.password
        )
        .then ->
          # Logged in, redirect to home
          $location.path '/'
        .catch (err) ->
          err = err.data;
          $scope.errors.other = err.message;
