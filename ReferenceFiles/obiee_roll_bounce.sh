#!/bin/bash
###########################################################
# Generic Variables
###########################################################
#
# You may also want to set your PATH environment to avoid having to use
# paths in the commands
# Author : Revathisharmila Ganapathy/Dinkar Bhagia
# Change History :
# 03/08/2018  Dinkar Bhagia  Log Location Change and Improvised Error Handling
# 03/15/2018  Dinkar Bhagia	 Added env and mode parameter for Jenkins Job

export DOMAIN_HOME=/u01/app/oracle/admin/domains/mosbi
export BITOOLS=$DOMAIN_HOME/bitools/bin
export LOGDIR=/u01/app/oracle/out/bounce
export LOGFILE=obiee_roll_bounce.log_$(date '+%Y%m%d_%H%M')
env=$1
mode=$2
echo "Environment : ${env}"
echo "Mode : ${mode}"

if [ ${env} = 'UAT' ] then BIPROC=14 else if [ ${env} = 'PROD' ] then BIPROC=16 fi fi
echo $BIPROC

check_status()
{
BISTATUS=$(eval $BITOOLS/status.sh|grep bi| grep RUNNING| wc -l)
if [$BISTATUS != $BIPROC ]
then
echo " There is some issue while restarting services please check" |tee -a $LOGDIR/$LOGFILE
exit 1
else 
echo " Service Check completed please proceed" | tee -a $LOGDIR/$LOGFILE
fi
}

if [ ${mode} = "DUMMY" ]
then 
check_status
else if [ ${mode} = "LIVE" ]
then
cd $BITOOLS
echo "Bouncing obiee on Node 1" | tee -a "$LOGDIR/$LOGFILE"
./stop.sh -i obiccs1,obisch1,obips1,obijh1,obis1,obips3,obijh3,bi_server1 |tee -a "$LOGDIR/$LOGFILE"
sleep 30
./status.sh |tee -a $LOGDIR/$LOGFILE
./start.sh -i bi_server1,obiccs1,obips1,obijh1,obis1,obips3,obijh3 |tee -a "$LOGDIR/$LOGFILE"
sleep 30
./status.sh | tee -a $LOGDIR/$LOGFILE
sleep 30
check_status
echo "Bounce on Node 1 is completed" |tee -a $LOGDIR/$LOGFILE

echo "Bouncing obiee on Node 2" | tee -a $LOGDIR/$LOGFILE
./stop.sh -i obiccs2,obisch2,obips2,obijh2,obis2,obips4,obijh4,bi_server2 |tee -a $LOGDIR/$LOGFILE
sleep 30
./status.sh  | tee -a $LOGDIR/$LOGFILE
./start.sh -i bi_server2,obiccs2,obips2,obijh2,obis2,obips4,obijh4 |tee -a $LOGDIR/$LOGFILE
sleep 30
./status.sh | tee -a $LOGDIR/$LOGFILE
sleep 30
check_status
echo "Bounce on Node 2 is completed" |tee -a $LOGDIR/$LOGFILE
fi
fi