AC_INIT(src/fuse/FuseLayer.cpp)

AM_CONFIG_HEADER(config.h)

AM_INIT_AUTOMAKE(TeaSafe, 0.1b)

AM_MAINTAINER_MODE

#set the compiler to use
AC_CANONICAL_HOST
case $host_os in
	darwin*)
		AC_PROG_CXX(clang++)
		FUSE="osxfuse"
		;;
	linux*)
		AC_PROG_CXX(g++)
		FUSE="fuse"
		;;
	*)
		#Default case
		AC_MSG_ERROR([Your platform is not currently supported])
		;;
esac

AC_ISC_POSIX
AC_HEADER_STDC
AC_PROG_LIBTOOL

# set default locations of where boost can be found
# to set differently when running ./configure do e.g.
# ./configure BOOST_LIBS=/usr....
BOOST_LIBS="/usr/local/lib"
BOOST_HEADERS="/usr/local/include/boost"

# compilation and linking flags
CXXFLAGS="-ggdb -std=c++11 -Os -ffast-math -funroll-loops -Wno-ctor-dtor-privacy -I/usr/local/include/boost -Iinclude -D_FILE_OFFSET_BITS=64"
LDFLAGS="-L/usr/local/lib -lboost_filesystem -lboost_system -lboost_program_options"
CXXFLAGS_FUSE="-I/usr/local/include/$(FUSE)  -DFUSE_USE_VERSION=26"

AC_SUBST(BOOST_LIBS)
AC_SUBST(BOOST_HEADERS)
AC_SUBST(CXXFLAGS)
AC_SUBST(CXXFLAGS_FUSE)
AC_SUBST(LDFLAGS)

#test for whether we want static linking
AM_CONDITIONAL(STATIC, [test "x$enable_static" = "xyes"])


AC_OUTPUT([
Makefile
])

