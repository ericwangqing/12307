'use strict'

angular.module('12307FullApp')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
