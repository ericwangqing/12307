DATA_SOURCE = __dirname + '/2013-11-12列车.sql'
DATA_FILE = __dirname + '/data.json'

require! 'fs'
_ = require 'underscore'

create-train-data = (callback)!->
  fs.read-file DATA_SOURCE,  encoding: 'utf8', (err, data)!->
    throw err if err
    trains = get-trains data
    callback trains
    # fs.write-file DATA_FILE, (JSON.stringify trains), encoding: 'utf8', (err)!->
    #   throw err if err
    #   console.log "Data success saved to #DATA_FILE"

get-trains = (data)->
  train-lines = get-train-lines data
  extract-trains train-lines

get-train-lines = (data)->
  train-lines = []
  sql-lines = data.split '\n'
  for line in sql-lines
    train-line = line.match /.+\((.+)\)/ .1
    train-lines.push train-line
  train-lines

extract-trains = (train-lines)->
  trains = {}
  for line in train-lines
    tokens = [token.substr 1, token.length - 2 for token in line.split /,\s/]
    trains[tokens.0] ||= {'车次': tokens.0, '类型': tokens.1, '经停站': []}
    trains[tokens.0]['经停站'][(parse-int tokens.3) - 1] = 
      '站名': tokens.2, '里程': tokens.7, '第几天': tokens.4, '出发': tokens.6, '到达': tokens.5
  _.values trains
      

module.exports = create: create-train-data


# train =
#   '车次': 'D5117'
#   '类型': '动车'
#   '经停站': 
#     * '站名': '重庆北':
#       '第几天': 1
#       '出发': '21:11'
#     * '站名': '合川':
#       '里程': 62
#       '第几天': 1
#       '到达': '21:31'
#       '出发': '21:35'
#     * '站名': '潼南':
#       '里程': 162
#       '第几天': 1
#       '到达': '22:11'
#       '出发': '22:15'
#     * '站名': '成都东':
#       '里程': 262
#       '第几天': 1
#       '到达': '23:11'


