angular.module "12307App" .factory 'Trains', ($http)->
  $http.get 'api/trains/'

angular.module "12307App" .factory 'Tickets', ($resource)->
  $resource "api/tickets/"

