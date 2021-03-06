http = require 'http'
ss = require 'socketstream'

# Define a single-page client called 'main'
ss.client.define 'main',
  view: 'app.jade'
  css: ['libs', 'app.styl']
  code: ['libs', 'app']
  tmpl: '*'

# Serve this client on the root URL
ss.http.route '/', (req, res) ->
  res.serveClient 'main'

# Code Formatters
ss.client.formatters.add require('ss-coffee')
ss.client.formatters.add require('ss-jade')
ss.client.formatters.add require('ss-stylus')

# Server side compiled Hogan
ss.client.templateEngine.use require('ss-hogan')

# PvE: incorporate redis for state information
# see https://github.com/socketstream/socketstream/blob/master/doc/guide/en/rpc_responder.md
# or: https://github.com/felixge/node-mysql
# host changed to the Portux machine
ss.session.store.use 'redis' 
    host: 'portux.local'

# ss.publish.transport.use ('redis');
ss.publish.transport.use 'redis', 
    host: 'portux.local' 

# Minimize and pack assets if you type: SS_ENV=production node app.js
ss.client.packAssets()  if ss.env is 'production'

# Start web server
server = http.Server(ss.http.middleware)
server.listen 3333

# Start SocketStream
ss.start server

# Start listening on the serial port
serial = require './server/rpc/serial'
serial.startSerial(ss)
