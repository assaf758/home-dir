#!/bin/bash

# This script creates a list of all files which are needed for creating editor's
# (cscope, slickedit) cross-reference. 
# Usage: create_files_list.sh [FILENAME]
# FILENAME - name of the file to craete (if omitted, filename is "cscope.files")

WSROOT=`pwd`
FILENAME=$1

# Verify $WSROOT is valid
if [ ! -e "$WSROOT/MAINTAINERS" ] ; then
  echo "Working-dir ($WSROOT) is not a valid kernel root, exiting"
  exit 1
fi 

# Use defualt filename if not given in command-line
if [ -z "$FILENAME" ] ; then
  FILENAME="cscope.files"
fi

echo "Creating file-list in \"$WSROOT/$FILENAME\" ... "

pushd / 1>/dev/null

rm $WSROOT/$FILENAME 2>/dev/null

# Define the directory list to search files in
INCLUDE_DIR_LIST="\
$WSROOT/net/tipc2 \
$WSROOT/include/ \
"

# Define the directory list to remove from the file search
EXCLUDE_DIR_LIST="\
-path $WSROOT/net/tipc1
"

# Define the file extensions to exclude from the file list
EXCLUDE_EXT_LIST="\
doc|bin|pdf|lib|obj|mak|dsp|exe|html|gif|tgz|gz|soc|ko|so|a|o|d|out|diff|patch|zip"

# Now create the file-list by searching over all relevant directories
# and removing files with non-rlvenat extensions
find -L $INCLUDE_DIR_LIST \( $EXCLUDE_DIR_LIST \) -prune -o -type f -printf \"%p\"\\n   | \
grep -Ev ".*((~$)|(\.($EXCLUDE_EXT_LIST)\"$)|(\.CC|\/\.))" > $WSROOT/$FILENAME

popd 1>/dev/null

echo Done

