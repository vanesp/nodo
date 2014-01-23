SerialPort = require 'serialport'
serial = null

# Export the serial setup code, to be started from the main app.js
exports.startSerial = (ss) ->
  
  serial = new SerialPort.SerialPort '/dev/ttyAMA0',
    baudrate: 57600
    parser: SerialPort.parsers.readline '\n'

#  serial.on 'data', (data) ->
    # text = data.slice(0, -1) # drop trailing newline
#    text = data
#    if text
#      ss.api.publish.all 'newMessage', text

  # tell the Nodo to not deal with IR, but only RF
  serial.write 'TransmitSettings RF;'
 
  
# Define actions which can be called from the client using ss.rpc('demo.ACTIONNAME', param1, param2...)
exports.actions = (req, res, ss) ->
  
  sendCommand: (message) ->
    if message # Check for blank messages
      serial.write message
    res true
