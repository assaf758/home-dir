#/bin/sh
#
#############################################
#
# The simple bash Jazz baseline diff tool
# for dumping simple release notes
#
# Written by: D. Toczala - Jazz Jumpstart Team
# Last Modified: January 2011
#
# This script just takes a series of user interactive
# choices to build the Jazz scm command to do a simple
# work item diff of two baselines associated with a 
# user indicated component.
#
# Feel free to change this script to take a series
# of six arguments, so you would be able to just
# redirect an input file, and then rename the result
# file, to do a series of these.
#
# This is provided with no guarantees, and was
# developed with RTC 3.0 on Ubuntu Linux (Lucid)
#
#############################################
#
# Setup
#
# Characters
QUOTE="\""
#
# Temp files
TMPFILE="Jazz_BL_Exec.sh"
RESULTFILE="Jazz_BL_Result.txt"
#
# SCM tool path
SCM_CMD=/home/dtoczala/Jazz/Clients/RTC_3_0/scmtools/eclipse/scm
#
# Repository Nickname
NICKNAME=MYRTC
#
# Default variables
DEFAULT_REPO_PATH=https://clmwb.dtoczala.laptop:9443/ccm/
DEFAULT_USERID=dtoczala
DEFAULT_USERPW=dtoczala
DEFAULT_START_BL="Initial Baseline"
DEFAULT_END_BL=BaselineFour
DEFAULT_COMPONENT=Acme
#
#############################################
#
# Get user data
#
# Note that we look for non-blank values to indicate that the user has NOT elected to 
# use the default values.  If user just hits return, we use the default values.
# For component, and baseline names, we need to enclose responses in double quotes, in 
# case the name has one or maore spaces in it.
#
# Repository URL
read -p "Repository URL is [$DEFAULT_REPO_PATH] - " REPO_PATH
if [ "$REPO_PATH" = "" ]; then 
   REPO_PATH="$DEFAULT_REPO_PATH"
fi
#
# User ID
echo -n "Jazz User ID is [$DEFAULT_USERID] - "
read USERID
if [ "$USERID" = "" ]; then 
   USERID="$DEFAULT_USERID"
fi
#
# User password
read -p "Jazz User password is [$DEFAULT_USERPW] - " USERPW
if [ "$USERPW" = "" ]; then 
   USERPW="$DEFAULT_USERPW"
fi
#
# Component
read -p "SCM Component is [$DEFAULT_COMPONENT] - " COMPONENT
if [ "$COMPONENT" = "" ]; then 
   TEMP=$DEFAULT_COMPONENT
else
   TEMP=$COMPONENT
fi
COMPONENT=$QUOTE$TEMP$QUOTE
#
# Initial baseline
read -p "Initial baseline is [$DEFAULT_START_BL] - " START_BL
if [ "$START_BL" = "" ]; then 
   TEMP=$DEFAULT_START_BL
else
   TEMP=$START_BL
fi
START_BL=$QUOTE$TEMP$QUOTE
#
# Final baseline
read -p "Final baseline is [$DEFAULT_END_BL] - " END_BL
if [ "$END_BL" = "" ]; then 
   TEMP=$DEFAULT_END_BL
else
   TEMP=$END_BL
fi
END_BL=$QUOTE$TEMP$QUOTE
#
#############################################
#
# Login to repository
#
#echo "Executing scm login to $REPO_PATH..."
$SCM_CMD login -r $REPO_PATH -u $USERID -P $USERPW -n $NICKNAME
#echo "... doing baseline compare between $START_BL and $END_BL "
#echo ""
#echo ""
#
#############################################
#
# Build the command line in a tempfile, make the
# tempfile executable
#
CMD="$SCM_CMD compare -r $NICKNAME -f i -I w -c $COMPONENT baseline $START_BL baseline $END_BL "
echo $CMD > $TMPFILE
chmod 775 $TMPFILE
#
#############################################
#
# Dump the results to a resultfile
#
echo "Delivered functionality in component $COMPONENT" > $RESULTFILE
echo " between $START_BL " >> $RESULTFILE
echo "     and $END_BL   " >> $RESULTFILE
echo "" >> $RESULTFILE
CMD="$SCM_CMD compare -r $NICKNAME -f i -I w -c $COMPONENT baseline $START_BL baseline $END_BL "
echo $CMD > $TMPFILE
chmod 775 $TMPFILE
./$TMPFILE >> $RESULTFILE
#rm $TMPFILE
#
# Dump results file to screen
#
cat $RESULTFILE
echo ""
echo "Results can be found in $RESULTFILE "
#
#############################################
#
# Note: I like to move the results files to a
# dropbox location, and then I can just display
# them on a dashboard via an HTML widget.
#
cp $RESULTFILE /home/dtoczala/Dropbox/Public/ReleaseNotes.txt
#
exit 0

