filter=$1
cd /root/css-dw/jira_python
PASS=`cat USERPASS.txt`
./jira_check_cr.sh ${filter} "esps-auto_ww@oracle.com" $PASS
CR=`cat jira_csv_${filter}_clean.csv | cut -d ',' -f2`
APPROVAL=`cat jira_csv_${filter}_clean.csv | cut -d ',' -f3`
echo $CR > cr.log
echo $APPROVAL >crapp.log
rm USERPASS.txt




