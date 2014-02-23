angular.module "12307App" .factory 'Order', ($http)->
  order-train = null
  order = null
  service =
    set-order-train: (train)!-> order-train := train
    get-order-train: -> order-train

    get-ticket-price: (seat-type)->
      # 10
      distance = order-train.travel-terminal['里程'] - order-train.travel-departure['里程']
      calculate-price distance, seat-type

    make-order: (travelers, callback)!-> 
      order-request = {train: order-train, travelers: travelers, order-time: Date.now!}
      headers = "Content-Type": "application/json"
      $http.post '/api/order', order-request, {headers: headers} .success (data, status, headers, config)!->
        console.log "make-order success. status: #status, data: ", data
        if data.oid
          order := order-request
          order.id = data.oid
          is-success = true
        else
          is-success = false
        callback null, is-success
      .error (data, status, headers, config)!->
        console.log "make-order failed. status: #status, data: ", data
        callback {status: status, data: data}

    get-order: -> order


calculate-price = (distance, seat-type)-> #TODO: 根据http://news.ifeng.com/mainland/special/2013chunyun/content-3/detail_2013_02/18/22225601_0.shtml?_from_ralated 公式计算
  distance 