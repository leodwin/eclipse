## Need Application Name and Env as inputs.
##Version 2.8
##Author: Sanoop.sooryanarayanan@oracle.com

#target=$1;
appName=$1;
env=$2;


##Set Runtime Environment.
export JAVA_HOME=/u01/app/system/scripts/gsaoem/emcli/emcli_13.2.0.0/jdk1.8.0_102/jre/
export BINHOME=/u01/app/system_scripts/local/bin
export passwordtool_path=/u01/app/system/scripts/local/scripts/
export PATH=/u01/app/system/scripts/gsaoem/emcli/emcli_13.2.0.0:$JAVA_HOME/bin:$BINHOME:$PATH:$passwordtool_path
export CONF_FILE=$BINHOME/emcc_target_conf.lst
user=`echo $USER`
export EMCLI_TEMP_DIR=/home/$user
export EMCLI_STATE_DIR=$EMCLI_TEMP_DIR


mkdir -p /home/$user/emcli-domain-refresh

## Get the Application name and its WLS Domain name entry for respective env.
#appName=`grep -i "${target}" $CONF_FILE | awk -F"=" '{print $2}' | cut -d "_" -f 1`
domain=`grep -i "${appName}"  $CONF_FILE | grep -i "$env" | grep -i ":weblogic_domain" | awk -F"=" '{print $2}'| awk -F":" '{print $1}'`


##Set log directory to oracle user home directory.
export LOGDIR=$EMCLI_TEMP_DIR/emcli-domain-refresh
export LOGFILE="$appName"_DomainRefresh_JenkinsJob.log_$(date '+%Y%m%d_%H%M')





##Nullify refresh.csv and then add necessary entry to refresh add/remove for the wls domain to refresh.
cd ~
#. /home/${user}/.emcli_mos_prod_notify.properties  #This should hold the password for emcc user.
cp /dev/null refresh.csv
echo "${domain},E"  >  refresh_${appName}_${env}.csv
echo "${domain},R"  >>  refresh_${appName}_${env}.csv

#Logout from the default emcli user the utility is loggedin as and connect with MOS_PROD_NOTIFY.
emcli logout
#emcli login username=MOS_PROD_NOTIFY -password=$password
emcli login -username=MOS_PROD_NOTIFY -password=`${passwordtool_path}/passwdtool -q -c CCDB/ornems -e prod -a mos_prod_notify | awk -F':' '{print $3}'`

#Run the refresh
emcli refresh_wls -input_file=domain_refresh_file:refresh_${appName}_${env}.csv -debug | tee -a "$LOGDIR/$LOGFILE"

#W#ait for 10mins before disable the job.
sleep 600

#Nullify refresh.csv and update it to disable the  refresh job on wls domain.
#cp /dev/null refresh_${appName}_${env}.csv
rm -f ~/refresh_${appName}_${env}.csv
echo "${domain},D"  >  refresh_${appName}_${env}_D.csv

emcli refresh_wls -input_file=domain_refresh_file:refresh_${appName}_${env}_D.csv -debug | tee -a "$LOGDIR/$LOGFILE"

rm -f ~/refresh_${appName}_${env}_D.csv

#Remove refresh logs older than 10Days if any.
find $LOGDIR -type f -name "*_DomainRefresh_JenkinsJob.log_*" -mtime +2 -exec rm -rf {} \;


exit;

