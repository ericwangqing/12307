'use strict'

angular.module '12307App', ['ngCookies', 'ngResource', 'ngSanitize', 'ngRoute']
.config ($routeProvider, $locationProvider, $httpProvider) ->
  # $routeProvider! 
  $routeProvider.when '/',
    templateUrl: 'partials/main'
    controller: 'MainCtrl'
  .when '/login',
    templateUrl: 'partials/login'
    controller: 'LoginCtrl'
  .when '/signup', 
    templateUrl: 'partials/signup'
    controller: 'SignupCtrl'
  .when '/settings',
    templateUrl: 'partials/settings'
    controller: 'SettingsCtrl'
    authenticate: true
  .when '/tickets',
    templateUrl: 'partials/tickets'
    controller: 'TicketsCtrl'
  .when '/booking',
    templateUrl: 'partials/booking'
    controller: 'BookingCtrl'
  .when '/payment',
    templateUrl: 'partials/payment'
    controller: 'PaymentCtrl'
  .otherwise templateUrl: '404'

  $locationProvider.html5Mode true

  $httpProvider.interceptors.push ['$q', '$location', ($q, $location) ->
    responseError: (response) ->
      if response.status is 401 or response.status is 403
        $location.path '/login'
        $q.reject response
      else
        $q.reject response
  ]
.run ($rootScope, $location, Auth) ->
  
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    $location.path '/login'  if next.authenticate and not Auth.isLoggedIn!