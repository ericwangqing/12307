angular.module "12307App" .factory 'Trains', ($http)->
  $http.get 'api/trains/'

angular.module "12307App" .factory 'Tickets', ($http)->
  $http.get "api/tickets/"

