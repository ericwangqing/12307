angular.module "12307App" .factory 'Booking', ->
  booking-train = null
  order = null
  service =
    set-booking-train: (train)!-> booking-train := train
    get-booking-train: -> booking-train

    make-order: (travelers)!-> order := {train: booking-train, travelers: travelers, booking-time: Date.now!}
    get-order: -> order
