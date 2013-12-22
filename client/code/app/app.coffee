# Listen out for blink:button events coming from the server
ss.event.on "newMessage", (message) ->
  
  # Example of using the Hogan Template in client/templates/chat/message.jade to generate HTML for each message
  html = ss.tmpl["chat-message"].render(
    message: message
    time: ->
      timestamp()
  )
  
  # Append it to the #chatlog div and show effect
  $(html).hide().appendTo("#chatlog").slideDown()
  
  # now try to figure out the message
  # check for Direction=Input, Event=(...)
  # set the state

ss.event.on "portux", (object) ->

  # store this in the session store
  # req.use 'session'
  # req.session.value = object
  # req.session.save
  # console.log "Data saved"
  # console.log object
  
  message = object.type + ' ' + object.location + ': '+ object.value + ' ' + object.quantity
  
  # skip if it is a Tick message
  if object.type isnt "Tick"
      # Example of using the Hogan Template in client/templates/chat/message.jade to generate HTML for each message
      html = ss.tmpl["chat-message"].render(
        message: message
        time: ->
          timestamp()
      )
  
  # if the event is motion, switch on the light
  # if object.type is "Motion"  and object.location is 3
  #    $('#switch2').prop('checked', true)
  #    send 'SendNewKaku 3,On;'
  
  # Handle messages of the type Switch 3 true (to switch 3 on) or Switch 2 false
  if object.type is "Switch" 
     sw = object.location
     # the cmd is now in the quantity field
     cmd = object.quantity
     if object.value then cmd += 'On;' else cmd += 'Off;'
     send cmd
     
     $(sw).prop('checked', object.value)
        
  # Append it to the #chatlog div and show effect
  $(html).hide().appendTo("#chatlog").slideDown()

  # html = ss.tmpl["chat-dashboard"].render(
  #  location: location
  #  type: type
  #  value: value
  #  quantity: quantity
  # )
  
  # $(html).replaceAll("#dashboard")

# Handle clicks on the switch

$("switch1").on "click", (a,b,c) ->
  state = $('#switch1').prop('checked')
  send if state then 'SendKAKU E1,On;' else 'SendKAKU E1,Off;'

$("#switch2").on "click", (a,b,c) ->
  state = $('#switch2').prop('checked')
  send if state then 'SendNewKaku 3,On;' else 'SendNewKaku 3,Off;'

$("#switch3").on "click", (a,b,c) ->
  state = $('#switch3').prop('checked')
  send if state then 'SendKAKU E3,On;' else 'SendKAKU E3,Off;'

$("#switch4").on "click", (a,b,c) ->
  state = $('#switch4').prop('checked')
  send if state then 'SendNewKaku 1,On;' else 'SendNewKaku 1,Off;'

$("#teach").on "click", (a,b,c) ->
  send 'SendNewKaku 2,On;'



# and a click on the 'Status' button
$("#status").on "click", (a,b,c) ->
  send 'Status All;'

# and a click on the 'clear' button
$("#clear").on "click", (a,b,c) ->
  $('#switch4').prop('checked',false)
  $("#chatlog").html("");

# Private method
send = (command, cb) ->
  if command
    ss.rpc "serial.sendCommand", command, () -> # ignore status

# Private functions
timestamp = ->
  d = new Date()
  d.getHours() + ":" + pad2(d.getMinutes()) + ":" + pad2(d.getSeconds())

pad2 = (number) ->
  ((if number < 10 then "0" else "")) + number

valid = (text) ->
  text and text.length > 0
