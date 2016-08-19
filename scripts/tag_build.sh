#!/bin/bash

SRC_FILE_LIST=proj_file_list.in
rm ${SRC_FILE_LIST}
# root dir for files collecting is iguazio/engine
find -L .. -regextype posix-extended \
    -regex "(.*\.(c|cc|cpp|hpp|h|hh|py|pyx|pl|pm||capnp|xml|sh|txt)$)" |\
     grep -v -e ".*\.devcall[123]\.h$" | sh ~/scripts/broken_sym.sh >> "$SRC_FILE_LIST"
mkdir tags_new
gtags -f ${SRC_FILE_LIST} ./tags_new && mv tags_new/* .



