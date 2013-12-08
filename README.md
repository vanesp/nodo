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

### Daemon installation
  
The file called nodo needs to be copied to /etc/init.d to start it up automatically,
and it needs to be initialised by root as:

    update-rc.d nodo defaults

To remove, execute

    update-rc.d nodo remove

Note that user www-data needs access to the serial port, and needs to be added to the
group tty and dialout with the command

    sudo usermod -a -G tty www-data
    sudo usermod -a -G dialout www-data

### Redis Installation
Download, extract and compile Redis with:

    cd /opt/
    mkdir /opt/redis
    wget http://redis.googlecode.com/files/redis-2.6.8.tar.gz
    tar xzf redis-2.6.8.tar.gz
    cd redis-2.6.8
    make

Move all the executable files to /opt/redis

    cp /opt/redis-2.6.8/redis.conf /opt/redis/redis.conf.default
    cp /opt/redis-2.6.8/src/redis-benchmark /opt/redis/
    cp /opt/redis-2.6.8/src/redis-cli /opt/redis/
    cp /opt/redis-2.6.8/src/redis-server /opt/redis/
    cp /opt/redis-2.6.8/src/redis-check-aof /opt/redis/
    cp /opt/redis-2.6.8/src/redis-check-dump /opt/redis/

The binaries that are now compiled are available in the src directory. Run Redis with:

    /opt/redis/redis-server
    
The redis command line can be run with

    /opt/redis/redis-cli

So now when everything is ready for starting server comes the part with creating a daemon
from this. Make sure you are in redis directory and do the following:

    cp /opt/redis/redis.conf.default /opt/redis/redis.conf
    joe /opt/redis/redis.conf

And after that just change 'no' to 'yes' in line with daemonize option and the following
changes (some of which are prompted by the use of a Raspberry Pi)

    # By default Redis does not run as a daemon. Use 'yes' if you need it.
    # Note that Redis will write a pid file in /var/run/redis.pid when daemonized.
    daemonize yes
    pidfile /var/run/redis.pid
    logfile /var/log/redis.log
    dir /opt/redis/
    maxfiles 1000
    maxmemory 48MB

Issue the following sequence of commands to download a basic init script, create a
dedicated system user, mark this file as executable, and ensure that the Redis process
will start following the next boot cycle:

    cd /opt/
    wget -O init-deb.sh http://library.linode.com/assets/629-redis-init-deb.sh
    adduser --system --no-create-home --disabled-login --disabled-password --group redis
    mv /opt/init-deb.sh /etc/init.d/redis
    chmod +x /etc/init.d/redis
    chown -R redis:redis /opt/redis
    touch /var/log/redis.log
    chown redis:redis /var/log/redis.log
    update-rc.d -f redis defaults

Redis will now start following the next boot process. You may now use the following
commands to start and stop the Redis instance:

    /etc/init.d/redis start
    /etc/init.d/redis stop

Install interfaces for Node

    $ sudo npm install -d redis connect-redis

### Monitoring what happens with Redis

Start the following series of commands to be able to spot what goes on under the hood!

    /opt/redis/redis-cli
    redis 127.0.0.1:6379> monitor
    OK
    



