#! /bin/sh

echo "Bootstrapping build process..."

if test -d autom4te.cache ; then
# we must remove this cache, because it
# may screw up things if configure is run for
# different platforms. 
  echo "Removing old Automake cache."
  rm -rf autom4te.cache
fi

echo "running aclocal ..."
aclocal

# autoheader must run before automake 
echo "running autoheader ..."
autoheader

echo "running automake ..."
automake --foreign --add-missing --copy

echo "running autoconf ..."
autoconf


echo "done"

