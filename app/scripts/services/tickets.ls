angular.module "12307FullApp" .factory 'Trains', ($resource)->
  $resource "api/trains/"

angular.module "12307FullApp" .factory 'Tickets', ($resource)->
  $resource "api/tickets/"

