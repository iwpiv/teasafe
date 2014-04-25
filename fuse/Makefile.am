LIBNAME = teafuse

lib_LTLIBRARIES = libteafuse.la

VPATH = ../src/fuse

libctrnn_la_SOURCES = FuseLayer.cpp

AM_CPPFLAGS= @CXXFLAGS@ \
             @CXXFLAGS_FUSE@ \
             -I../include 

if STATIC
AM_LDFLAGS= @LDFLAGS@ \
            -static
else
AM_LDFLAGS= @LDFLAGS@\
            -Xlinker -rpath -Xlinker "`pwd`/.libs" -Xlinker -install_name -Xlinker "`pwd`/.libs/lib$(LIBNAME).0.dylib"
endif
