# Nodo demo... 

Using socketstream and node.js talk to a NodoSmall via the serial port
of a Raspberry PI. Create a live user interface and allow control of 
lights via the KAKU (Klik Aan-Klik Uit) commands.

## Requirements

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

So now when everything is ready for starting server comes the part with creating a daemon from this.
Make sure you are in redis directory and do the following:

    cp /opt/redis/redis.conf.default /opt/redis/redis.conf
    joe /opt/redis/redis.conf

And after that just change 'no' to 'yes' in line with daemonize option and the following changes (some of which
are prompted by the use of a Raspberry Pi)

    # By default Redis does not run as a daemon. Use 'yes' if you need it.
    # Note that Redis will write a pid file in /var/run/redis.pid when daemonized.
    daemonize yes
    pidfile /var/run/redis.pid
    logfile /var/log/redis.log
    dir /opt/redis/
    maxfiles 1000
    maxmemory 48MB

Issue the following sequence of commands to download a basic init script, create a dedicated system user,
mark this file as executable, and ensure that the Redis process will start following the next boot cycle:

    cd /opt/
    wget -O init-deb.sh http://library.linode.com/assets/629-redis-init-deb.sh
    adduser --system --no-create-home --disabled-login --disabled-password --group redis
    mv /opt/init-deb.sh /etc/init.d/redis
    chmod +x /etc/init.d/redis
    chown -R redis:redis /opt/redis
    touch /var/log/redis.log
    chown redis:redis /var/log/redis.log
    update-rc.d -f redis defaults

Redis will now start following the next boot process. You may now use the following commands to start and stop the Redis instance:

    /etc/init.d/redis start
    /etc/init.d/redis stop

Install interfaces for Node

    $ sudo npm install -d redis connect-redis


