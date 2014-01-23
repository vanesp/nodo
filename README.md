# Nodo demo... 

Using socketstream and node.js talk to a NodoSmall via the serial port
of a Raspberry PI. Create a live user interface and allow control of 
lights via the KAKU (Klik Aan-Klik Uit) commands.

## Redesign

Move server related actions (on serial port functions and on incoming messages)
to server, so that it keeps working when there is no browser accessing the client

## Workings

The client receives, via Redis Pub/Sub, two kinds of messages. These looks as follows to conform to the 
Socketstream specification:

    "publish" "ss:event" "{\"t\":\"all\",\"e\":\"newMessage\",\"p\":[\"\\u0013\\u0000Error in command.\"]}"
    {
       "t" : "all",
       "e" : "newMessage",
       "p" : [ "param1", "param2" ]
    }

 The parameters for the messages we send look as follows:
 
    type        = Switch (to control a switch setting) or Motion (for a motion event)
    location    = 3 for Woonkamer, and 2 for Study. For a Switch these may contain values
                  1..4 or any other named switches if these switches are defined in the code
    quantity    = for a Switch this contains the body of the string to be sent to the Nodo
    value       = is 1 for a motion event, and a true for On, or false for Off


    
Motion events are just show in the log. Switch events cause the app to send a command to
the Nodo which switches the corresponding switch via rs-232 interface to the Nodo device.

* Motion events are captured on the Portux server in the rcvsend.php process (such that they
are transmitted immediately).
* Switch control events are generated in the controller.php process on the Portux server.

When the nodo is ultimately connected directly to the Portux, the redis database will
reside there and this code is no longer required.

## Requirements

Redis is installed on the Portux and invoked through socketstream as follows:

    # host changed to the Portux machine
    ss.session.store.use 'redis' 
        host: 'portux.local'




