#!/bin/bash

BUILD=${1:-"all"}
THREADS=32
REL="./configure --prefix=/opt --enable-libusb --enable-vdpau --enable-vaapi --disable-joystick --disable-pulse --enable-airtunes --enable-airplay CXXFLAGS=-DTIXML_USE_STL --disable-debug"
DBG="./configure --prefix=/opt --enable-libusb --enable-vdpau --enable-vaapi --disable-joystick --disable-pulse --enable-airtunes --enable-airplay CXXFLAGS=-DTIXML_USE_STL"
declare -x PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/lib/java/bin"
GITREV=`git describe --tags`

function build
{
  ./bootstrap
  `$CFG`
  make -j$THREADS && make install DESTDIR=$WORKSPACE/xbmc-output
  rm -rf $WORKSPACE/xbmc-output/opt/share/xbmc/addons/repository*
  if [ -e $OUTPUT ]; then
    echo "deleting old $OUTPUT..."
    rm -f $OUTPUT
  fi
  mksquashfs $WORKSPACE/xbmc-output/ $OUTPUT
  rm -rf xbmc-output
  make clean
  make dist-clean
}

function cfgbuild
{
  if [ $1 == "release" ]; then
    CFG=$REL
    OUTPUT="200gz-xbmc-$GITREV.lzm"
  elif [ $1 == "debug" ]; then
    CFG=$DBG
    OUTPUT="200gz-xbmc-$GITREV-debug.lzm"
  else
    echo "Unkown build - exit"
    exit 1
  fi

  echo "Using following configure command:"
  echo "$CFG"
}

if [ $BUILD == "all" ]; then
  echo "building xbmc..."
  cfgbuild "release"
  build;
  cfgbuild "debug"
  build;
else
  echo "build $BUILD xbmc..."
  cfgbuild $BUILD
  build
fi

exit 0
