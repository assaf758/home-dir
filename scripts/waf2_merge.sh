#svn diff -r 11902:122930

# merge revs:
# 121398
# 121404
# 121845
# 122421
# 122604
# 123157
SVN=/home/assafb/bin/svn
FILES_AGG=files_agg.txt
FILES_LIST=files_list.txt
DIFF_FILE=diff_file.txt
[ -f $FILES_AGG ] && rm $FILES_AGG

$SVN diff -r 119303:121397 --summarize >> $FILES_AGG
$SVN diff -r 121399:121403 --summarize >> $FILES_AGG
$SVN diff -r 121405:121844 --summarize >> $FILES_AGG
$SVN diff -r 121846:122420 --summarize >> $FILES_AGG
$SVN diff -r 122422:122603 --summarize >> $FILES_AGG
$SVN diff -r 122605:123156 --summarize >> $FILES_AGG
$SVN diff -r 123158:HEAD   --summarize >> $FILES_AGG

[ -f $FILES_LIST ] && rm $FILES_LIST
cat $FILES_AGG | gawk '{print $2}' | sort -u >> $FILES_LIST

echo "files_list"
cat $FILES_LIST
echo "now creting the diff"

[ -f $DIFF_FILE ] && rm $DIFF_FILE
for file in $(cat $FILES_LIST)
do  
    kvn diff -r 119003:122930 $file >> $DIFF_FILE
done


