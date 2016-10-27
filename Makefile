PKGNAME=libsockem
LIBNAME=libsockem
LIBFILENAME=libsockem.so
LIBVER=0

SRCS=sockem.c
HDRS=sockem.h
OBJS=$(SRCS:.c=.o)

LIBS+=-lpthread -lrt

# Preloading is WIP, will not work now.
#CPPFLAGS+=-DLIBSOCKEM_PRELOAD

-include Makefile.config

all: lib

include mklove/Makefile.base

clean: lib-clean

install: lib-install

