angular.module "12307App" .factory 'Booking', ->
  booking-train = null
  service =
    set-booking-train: (train)!->
      booking-train := train
    get-booking-train: ->
      booking-train
