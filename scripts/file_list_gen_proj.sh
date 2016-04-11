#/bin/bash
SRC_FILE_LIST=proj_file_list.in
rm ${SRC_FILE_LIST}
find -L . -regextype posix-extended \
    -regex "(.*\.(c|cc|cpp|hpp|h|hh|py|pl|pm||capnp|xml|sh|txt)$)" |\
     grep -v -e ".*\.devcall[123]\.h$" | sh ~/scripts/broken_sym.sh >> "$SRC_FILE_LIST"

# find ../../usr/include -regextype posix-extended \
#     -regex "(.*Makefile$|.*\.(c|cc|cpp|hpp|h|hh|py|pl|pm|xml|mk|make|sh|sch)$)" |\
#      grep -v -e ".*\.devcall[123]\.h$" >> "$SRC_FILE_LIST"

