'use strict'

angular.module('12307App')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
