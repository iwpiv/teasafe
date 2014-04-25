LIBNAME = cipher

lib_LTLIBRARIES = libcipher.la

VPATH = ../src/cipher

libctrnn_la_SOURCES = IByteTransformer.cpp \
                      sha2.cpp \
                      XTEAByteTransformer.cpp

AM_CPPFLAGS= @CXXFLAGS@ \
             -I../include 

if STATIC
AM_LDFLAGS= @LDFLAGS@ \
            -static
else
AM_LDFLAGS= @LDFLAGS@\
            -Xlinker -rpath -Xlinker "`pwd`/.libs" -Xlinker -install_name -Xlinker "`pwd`/.libs/lib$(LIBNAME).0.dylib"
endif
