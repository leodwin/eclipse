#!/bin/bash
#Call the Extract
rm *.csv
filter=$1
username=$2
password=$3
export https_proxy=http://www-proxy.us.oracle.com:80
python extract_from_jira.py $filter $username $password 
#Cleanup and get columns I need
cleanfile="jira_csv_"$filter"_clean.csv"
python cleanup_csv.py "jira_csv_$filter.csv" $cleanfile 0,1,4,13,14,16,17,103,99
#Trim the first Header Row
sed -i -e "1d" $cleanfile
echo ""
cat $cleanfile
