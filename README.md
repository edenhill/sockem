# sockem
Socket-level network emulation


# Inclusion

Add `sockem.c` and `sockem.h` to your application build system.

Compile with `-lpthread` or similar.

# Usage

All you need to do is replace your application's connect() call with
sockem_connect() and eventually call sockem_close().

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

