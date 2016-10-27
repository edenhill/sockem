# sockem
Socket-level network emulation

sockem puts itself between your application's socket and the remote peer server,
introducing network latency, throughput restrictions, etc. to emulate
network problems.

## WIP

sockem currently only provides the infrastructure for traffic shaping, but
does not yet actually implement any of it.
The only usable option for now is to force connection close through
sockem_close().

Dont despair, [@andoma](https://github.com/andoma) will add proper traffic shaping support shortly.


## Uses

There are two ways to use sockem:
 * Modifying the program to call sockem instead of the standard socket API,
   this allows real-time sockem config changes to sockets, .e.g, forcing
   connections to close, changing latency or thruput, etc.
   See the [Inclusion](#inclusion) section below.
 * Overloading the libc API. This requires no changes or even recompilation
   of existing applications but simply `LD_PRELOAD`:ing libsockem prior to running
   the application. sockem configuration is provided through the `SOCKEM_CONF`
   environment variable. Realtime sockem config changes are not possible
   in this mode.
   See the [Preloading](#preloading) section below.


# Inclusion

## Add to build

Copy `sockem.c` and `sockem.h` to your application source directory
and add those two files to its build system.

Make sure your application is compiled with `-lpthread`.


## Usage

Replace your application's connect() call with sockem_connect() and
eventually call sockem_close().

Example:

    #include "sockem.h"
    ...
    
    sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    sockem_t *skm = sockem_connect(sockfd, peer, peer_len, "rx.thruput", 9000, NULL);

    /* Use sockfd as usual */
    ...
    poll(...sockfd...);
    send(sockfd, ...);
    recv(sockfd, ..);
    ..
    /* Change sockem config in realtime */
    sockem_set(skm, "delay", 900, "jitter", 200, NULL);
    ...

    sockem_close(skm);
    /* Or: */
    sockem_close(sockem_find(sockfd));

    /* And finally */
    close(sockfd);



`sockem_close()` may be used spontanoeusly to force the connection to be
closed. From the application's point of view it will seem as if the
remote peer had closed the connection.



# Preloading

## Building

Build libsockem.so by:

    ./configure
    make


## Running

    LD_PRELOAD=./libsockem.so SOCKEM_CONF="key=val,key2=val2" some-program with -args

Example:

    LD_PRELOAD=./libsockem.so SOCKEM_CONF="delay=120" ssh user@somehost

