#/bin/bash
SRC_FILE_LIST=file_list.in.1
rm ${SRC_FILE_LIST}
find -L . -regextype posix-extended \
    -regex "(.*Makefile$|.*\.(c|cc|cpp|hpp|h|hh|py|pl|pm|xml|mk|make|sh|sch|list)$)" |\
     grep -v -e ".*\.devcall[123]\.h$" | sh ~/scripts/broken_sym.sh >> "$SRC_FILE_LIST"

# find ../../usr/include -regextype posix-extended \
#     -regex "(.*Makefile$|.*\.(c|cc|cpp|hpp|h|hh|py|pl|pm|xml|mk|make|sh|sch)$)" |\
#      grep -v -e ".*\.devcall[123]\.h$" >> "$SRC_FILE_LIST"

