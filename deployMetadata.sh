export UPLOADDIR=/u01/app/oracle/out/patching/upload
export BI_SHARED=/app/oracle/bidata
export METADATA=${BI_SHARED}/metadata
export LOGDIR=/home/oracle/metadata
export LOGFILE=metadata-deploy.log_$(date '+%Y%m%d_%H%M')
PREL=$1
PVER=`cat /home/oracle/deploy_kit/cfg/root.cfg | grep = |grep -w kit_folder | cut -d '/' -f2`
PVER=${PVER:0:${#PVER}-1}
RPDREL=Orion_MR${PREL}
#TENV=`cat /etc/ems_env_info | cut -d ' ' -f1`

echo  |tee -a ${LOGDIR}/${LOGFILE}
echo "Step I - Download Metadata from Release Server" |tee -a ${LOGDIR}/${LOGFILE}
sleep 3
scp -r siebel@wd2037:/app/Release/orion/Analytics/Move_to_Test_and_Prod/ORION_MR${PREL}/${PVER}/RPD_And_Metadata/${RPDREL}.tar.gz ${UPLOADDIR}

if [ -f ${UPLOADDIR}/${RPDREL}.tar.gz ]
then echo "Metadata downloaded from release server"|tee -a ${LOGDIR}/${LOGFILE}
ls -l ${UPLOADDIR}/${RPDREL}.tar.gz|tee -a ${LOGDIR}/${LOGFILE}
sleep 3
else
echo "Metadata download failed from release server. Exit ..."
rm ${LOGDIR}/${LOGFILE}
exit 1
fi

mkdir ${METADATA}/${PVER}
tar -xzvf ${UPLOADDIR}/${RPDREL}.tar.gz --directory ${METADATA}/${PVER}
mv ${METADATA}/empty ${METADATA}/empty_$(date '+%Y%m%d_%H%M')
mkdir ${METADATA}/empty
mv ${METADATA}/${PVER}/${RPDREL}/* ${METADATA}/empty/
rm -rf ${METADATA}/${PVER}