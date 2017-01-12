#!/bin/bash

src_files_list=proj_file_list.in
new_db=no

for i in "$@"
do
    case $i in
        -f=*|--file-list=*)
            src_files_list="${i#*=}"
            shift # past argument=value
            ;;
        -n|--new-db)
            new_db=yes
            shift # past argument=value
            ;;
        -h|--help)
            printf -- "-n for new db (by default update existing db)\n-f='x' to set file list (by default proj_file_list.in)"
            exit
            ;;
        *)
            # unknown option
            ;;
    esac
done

echo "src_files_list = ${src_files_list}"
echo "new_db = ${new_db}"

rm ${src_files_list}
# root dir for files collecting is iguazio/engine
find -L .. -regextype posix-extended \
    -regex "(.*\.(c|cc|cpp|hpp|h|hh|py|pyx|pl|pm||capnp|xml|sh|txt)$)" |\
     grep -v -e ".*\.devcall[123]\.h$" | sh ~/scripts/broken_sym.sh >> "${src_files_list}"

if [[ ${new_db} == 'yes' ]]; then
    echo "creating new db..."
    mkdir tags_new
    gtags -f ${src_files_list} ./tags_new && mv tags_new/* .
else
    echo "updating existing db..."
    gtags -i -f ${src_files_list}
fi

