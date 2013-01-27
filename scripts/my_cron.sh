# To change script frequency, run:  crontab -e

# Create a .csv file with all non-resolved DDTS in xblade fw project

# old version, based on comp
#findcr -f "%-10.10s\t%-12.12s\t%-10.10s\t%-4.4s\t%-4.4s\t%-14.14s\t%-10.10s\t%-72.72s\n" -w Identifier,Version,Submitted-on,Status,Severity,Component,Engineer,Headline -s NAOIPWH "(Component = 'c12000-fw-images' or Component = 'x-blade-dp' or Component ='x-blade-vfw-dp' or Component = 'x-blade-vfw-cp' or Component = 'service-vfirewall') " > ~/bugs.csv

#new version, based on IOX-XB attribute
QUERY="([Attribute] like '*IOX-XB*') and ([DE-manager] = 'ozarad') and ([Project] = 'CSC.ena' or [Project] = 'CSC.labtrunk')"
STATUS="([Status]='N' or [Status] = 'A' or [Status] = 'O' or [Status] = 'I' or [Status] = 'P' or [Status] = 'W' or [Status] = 'H')"  
FORMAT_FULL='-f %-10.10s\t%-12.12s\t%-10.10s\t%-4.4s\t%-4.4s\t%-14.14s\t%-10.10s\t%-72.72s\n -w Identifier,Version,Submitted-on,Status,Severity,Component,Engineer,Headline'
FORMAT_SHORT='-f %-10.10s\n -w Identifier'
#findcr  --order Severity,Engineer $FORMAT_FULL  $STATUS "and" $QUERY  > ~/bugs.csv
findcr  --order Severity,Engineer $FORMAT_FULL $STATUS "and" $QUERY > ~/bugs.csv
#echo  --order Severity,Engineer $FORMAT_FULL  $STATUS "and" $QUERY  




#findcr -f "%-10.10s\t%-12.12s\t%-10.10s\t%-4.4s\t%-4.4s\t%-14.14s\t%-10.10s\t%-72.72s\n" -w Identifier,Version,Submitted-on,Status,Severity,Component,Engineer,Headline -s NAOIPWH "(Component = 'x-blade-li-dp' or Component = 'service-li' or Component ='c12k-service-li' ) " > ~/li_bugs.csv


