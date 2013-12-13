# Nodo demo... 

Using socketstream and node.js talk to a NodoSmall via the serial port
of a Raspberry PI. Create a live user interface and allow control of 
lights via the KAKU (Klik Aan-Klik Uit) commands.

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
    location    = 1,2,3,4 (corresponding to switch etc) or 3 for Woonkamer, and 2 for Study
    quantity    = empty
    value       = is 1 for a motion event, and true or false for On or Off
    
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




