#!/bin/bash

# This script creates a list of all files which are needed for creating editor's
# (cscope, slickedit) cross-reference. 
# Usage: create_files_list.sh [FILENAME]
# FILENAME - name of the file to craete (if omitted, filename is "cscope.files")

WSROOT=`pwd`
FILENAME=$1

# Verify $WSROOT is valid
if [ ! -d "$WSROOT/src" -o ! -d "$WSROOT/build" ] ; then
  echo "Working-dir ($WSROOT) is not a valid WS root, exiting"
  exit 1
fi 

# Use defualt filename if not given in command-line
if [ -z "$FILENAME" ] ; then
  FILENAME="cscope.files"
fi

echo "Creating file-list in \"$WSROOT/$FILENAME\" ... "

VER_CONFD="`grep COMPASS_VER_CONFD build/CMakeCache.txt | grep STRING | awk -F= '{print $2}'`"
VER_PLATFORM="`grep COMPASS_VER_PLATFORM build/CMakeCache.txt | grep STRING | awk -F= '{print $2}'`"

pushd / 1>/dev/null

rm $WSROOT/$FILENAME 2>/dev/null

# Define the directory list to search files in
INCLUDE_DIR_LIST="\
$WSROOT/src \
$WSROOT/tools \
/home/compass/platform-releases/$VER_PLATFORM/sysroot/usr/include \
/home/compass/confd/confd-$VER_CONFD/full_lib/libconfd \
/usr/lib/gcc/i486-linux-gnu/4.2.4/include \
/usr/include \
"

# Define the directory list to remove from the file search
EXCLUDE_DIR_LIST="\
-path /usr/include/X11 -o \
-path /usr/include/gtk-2.0 -o \
-path /usr/include/qt3 -o \
-path /usr/include/qt4 -o \
-path /usr/include/xercesc -o \
-path /usr/include/freetype2 -o \
-path /usr/include/wireshark -o \
-path /usr/include/c++"

# Define the file extensions to exclude from the file list
EXCLUDE_EXT_LIST="\
doc|bin|pdf|lib|obj|mak|dsp|exe|html|gif|tgz|gz|soc|ko|so|a|o|d|out|diff|patch|zip"

# Now create the file-list by searching over all relevant directories
# and removing files with non-rlvenat extensions
find -L $INCLUDE_DIR_LIST \( $EXCLUDE_DIR_LIST \) -prune -o -type f -printf \"%p\"\\n   | \
grep -Ev ".*((~$)|(\.($EXCLUDE_EXT_LIST)\"$)|(\.CC|\/\.))" > $WSROOT/$FILENAME

popd 1>/dev/null

echo Done

