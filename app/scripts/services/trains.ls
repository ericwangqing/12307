angular.module "12307App" .factory 'Trains', ($http)->
  $http.get 'api/trains/'

angular.module "12307App" .factory 'Tickets', ($http)->
  $http.get "api/tickets/"

angular.module "12307App" .factory 'RemainTickets', ->
  get: (train, seat-type)->
    stations = []
    for station in train['经停站']
      is-passing = true if is-passing or station['站名'] is train.travel-departure['站名'] 
      if station['站名'] is train.travel-terminal['站名'] # 终点不计入
        is-passing = false
        break
      stations.push station['站名']

    get-min-tickets-number-of-stations train.remain-tickets[seat-type], stations 

get-min-tickets-number-of-stations = (station-remain-ticekts, stations)->
  min  = 100000
  for station in stations
    min = number if min > number = station-remain-ticekts[station] 
  min

