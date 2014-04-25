LIBNAME = teasafe

lib_LTLIBRARIES = libteasafe.la

VPATH = ../src/teasafe

libctrnn_la_SOURCES = EntryInfo.cpp \
                      TeaSafe.cpp \
                      TeaSafeImageStream.cpp \
                      FileBlock.cpp \
                      TeaSafeFile.cpp \
                      FileBlockBuilder.cpp \
                      TeaSafeFileDevice.cpp \
                      FileBlockIterator.cpp \
                      TeaSafeFolder.cpp

AM_CPPFLAGS= @CXXFLAGS@ \
             -I../include \
             -I@BOOST_HEADERS@

if STATIC
AM_LDFLAGS= @LDFLAGS@ \
            -static
else
AM_LDFLAGS= @LDFLAGS@\
            -Xlinker -rpath -Xlinker "`pwd`/.libs" -Xlinker -install_name -Xlinker "`pwd`/.libs/lib$(LIBNAME).0.dylib"
endif
