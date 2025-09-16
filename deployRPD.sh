#!/bin/bash

echo
echo "This script should be run on Target Environmen's Patching Node"
echo

#####################
# General env setup #
#####################
#PREL=`more root.cfg | grep -w svn_release_folder| grep = | cut -d '/' -f2`
PREL=$1
ENVIRONMENT=$2
PVER=`cat /home/oracle/deploy_kit/cfg/root.cfg | grep = |grep -w kit_folder | cut -d '/' -f2-`
PVER=${PVER:0:${#PVER}-1}
echo $PVER
#PVER=18_2_0_0_0_2
RPDREL=Orion_MR${PREL}
TENV=`cat /etc/ems_env_info | cut -d ' ' -f1`
WLSID=weblogic
TWLSPW=`/envadmin/Environments/$TENV/bin/passwdtool -q -c ANALYTICSBI12C/OracleBI -a weblogic | cut -d ':' -f3`
SRPDPW=`/envadmin/Environments/$TENV/bin/passwdtool -q -c ANALYTICSBI12C/OracleBI -a dev_rpdAdmin | cut -d ':' -f3`
TRPDPW=`/envadmin/Environments/$TENV/bin/passwdtool -q -c ANALYTICSBI12C/OracleBI -a rpdAdmin | cut -d ':' -f3`
UPLOADDIR=/u01/app/oracle/out/patching/upload
WORKDIR=/u01/app/oracle/out/patching/log
DEPLOYLOG=deployRPD.log_$(date '+%Y%m%d_%H%M')
BKPLOC=/u01/app/oracle/out/patching/archive/BKPRPD_$(date '+%Y%m%d_%H%M')
DOMAINHOME=/u01/app/oracle/admin/domains/mosbi
BINHOME=${DOMAINHOME}/bitools/bin
VarVal=`echo "$PREL" | sed s/_//`


if [ $ENVIRONMENT == 'PROD' ]
then
        TENV_DB='ANALYTICS01_ODMAP.us.oracle.com'
elif [ $ENVIRONMENT == 'UAT' ]
then
        TENV_DB='ANALYTICS01_ODMCT.us.oracle.com'
elif [ $ENVIRONMENT == 'STAGE' ]
then
        TENV_DB='odmems.us.oracle.com'
fi
echo $TENV_DB

echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step I - Download RPD from Release Server, Change Password and Update JSON" |tee -a ${WORKDIR}/${DEPLOYLOG} 
sleep 3
scp -r siebel@wd2037:/app/Release/orion/Analytics/Move_to_Test_and_Prod/ORION_MR${PREL}/${PVER}/RPD_And_Metadata/${RPDREL}.rpd ${UPLOADDIR}
scp -r siebel@wd2037:/app/Release/orion/Analytics/Move_to_Test_and_Prod/ORION_MR${PREL}/${PVER}/RPD_And_Metadata/${RPDREL}_rpd_var.json ${UPLOADDIR}

if [ -f ${UPLOADDIR}/${RPDREL}.rpd ] && [ -f ${UPLOADDIR}/${RPDREL}_rpd_var.json ] 
then echo "RPD and RPD var json downloaded from release server"|tee -a ${WORKDIR}/${DEPLOYLOG}
ls -l ${UPLOADDIR}/${RPDREL}.rpd|tee -a ${WORKDIR}/${DEPLOYLOG}
ls -l ${UPLOADDIR}/${RPDREL}_rpd_var.json|tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Updating RPD Variable JSON"
sed -i "s/ue_${VarVal}dev_mos_odmems/${TENV_DB}/g" ${UPLOADDIR}/${RPDREL}_rpd_var.json
sleep 3
else 
echo "RPD download failed from release server. Exit ..." 
rm ${WORKDIR}/${DEPLOYLOG}
exit 1
fi

mv $UPLOADDIR/${RPDREL}.rpd $UPLOADDIR/${RPDREL}.rpd_bef_pwdchg
echo $SRPDPW >  $UPLOADDIR/rpdpwd.input
echo $TRPDPW | tee -a $UPLOADDIR/rpdpwd.input
$BINHOME/obieerpdpwdchg.sh -I $UPLOADDIR/${RPDREL}.rpd_bef_pwdchg -O $UPLOADDIR/${RPDREL}.rpd < $UPLOADDIR/rpdpwd.input

# Stopping Scheduler before deployment
#echo " Stopping obisch1,obisch2 "
#if [ $ENVIRONMENT == 'PROD' ]
#then 
#echo "Stopping Scheduler in Production"
#cd ${BINHOME}
#./stop.sh -i obisch1,obisch2
#fi

echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step II - Backup Target ${TENV} RPD and Connetion Pool and Variables" |tee -a ${WORKDIR}/${DEPLOYLOG} sleep 3
mkdir -p ${BKPLOC}
$BINHOME/datamodel.sh downloadrpd -O ${BKPLOC}/${TENV}.rpd -W ${TRPDPW} -U ${WLSID} -P ${TWLSPW}  -SI ssi -Y |tee -a ${WORKDIR}/${DEPLOYLOG}
if [ -f ${BKPLOC}/${TENV}.rpd ] 
then echo "Target ${TENV} RPD is download to ${BKPLOC}/${TENV}.rpd" |tee -a ${WORKDIR}/${DEPLOYLOG}
ls -l ${BKPLOC}/${TENV}.rpd |tee -a ${WORKDIR}/${DEPLOYLOG} 
sleep 3 
else echo " Target ${TENV} RPD backup failed . Exit ..."
rm ${WORKDIR}/${DEPLOYLOG}
exit 1
fi

echo |tee -a ${WORKDIR}/${DEPLOYLOG}
$BINHOME/datamodel.sh listConnectionpool -SI ssi -U ${WLSID} -P ${TWLSPW} -O ${BKPLOC}/${TENV}_con_pool.json -V true |tee -a ${WORKDIR}/${DEPLOYLOG}
if [ -f ${BKPLOC}/${TENV}_con_pool.json ] 
then echo "Target ${TENV} RPD's Connetion Pool is downloaded to ${BKPLOC}/${TENV}_con_pool.json" |tee -a ${WORKDIR}/${DEPLOYLOG} 
ls -l $BKPLOC/${TENV}_con_pool.json |tee -a ${WORKDIR}/${DEPLOYLOG}
else echo  "Target RPD connection pool download is not  successful. Exit ..."
rm ${WORKDIR}/${DEPLOYLOG}
exit 1
fi

echo |tee -a ${WORKDIR}/${DEPLOYLOG}
$BINHOME/datamodel.sh listrpdvariables -SI ssi -U ${WLSID} -P ${TWLSPW} -O ${BKPLOC}/${TENV}_rpd_var.json |tee -a ${WORKDIR}/${DEPLOYLOG}
if [ -f ${BKPLOC}/${TENV}_rpd_var.json ]
then echo "Target ${TENV} RPD's Variables is downloaded to ${BKPLOC}/${TENV}_rpd_var.json" |tee -a ${WORKDIR}/${DEPLOYLOG}
ls -l $BKPLOC/${TENV}_rpd_var.json |tee -a ${WORKDIR}/${DEPLOYLOG}
else echo  "Target RPD Variables download is failed. Exit ..."
rm ${WORKDIR}/${DEPLOYLOG}
exit 1
fi

echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step III - Upload RPD to Target ${TENV}" |tee -a ${WORKDIR}/${DEPLOYLOG}
${BINHOME}/datamodel.sh uploadrpd -I ${UPLOADDIR}/${RPDREL}.rpd -W ${TRPDPW} -U ${WLSID} -P ${TWLSPW} -SI ssi |tee -a ${WORKDIR}/${DEPLOYLOG}
grep "Step III - Upload RPD" -A 4 ${WORKDIR}/${DEPLOYLOG}|grep "RPD upload completed successfully">/dev/null
if [ $? -ne 0 ]
then echo  "Upload RPD to Target ${TENV} failed . Exit ..."
rm ${WORKDIR}/${DEPLOYLOG} 
exit 1
fi

echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step IV -  Update Target RPD Variables" |tee -a ${WORKDIR}/${DEPLOYLOG}
$BINHOME/datamodel.sh updaterpdvariables -C ${UPLOADDIR}/${RPDREL}_rpd_var.json  -SI ssi -U ${WLSID} -P  ${TWLSPW} |tee -a ${WORKDIR}/${DEPLOYLOG}
grep "Step IV -  Update Target RPD Variables" -A 4 ${WORKDIR}/${DEPLOYLOG}|grep "Rpd variables update completed successfully." >/dev/null
if [ $? -ne 0 ]
then
echo "Update Target RPD Variables failed . Exit ..."  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Please manually restore variables by following command"|tee -a ${WORKDIR}/${DEPLOYLOG}
echo "$BINHOME/datamodel.sh updaterpdvariables -C ${BKPLOC}/${TENV}_rpd_var.json  -SI ssi -U ${WLSID} -P ${TWLSPW}" |tee -a ${WORKDIR}/${DEPLOYLOG}
echo  >>${WORKDIR}/${DEPLOYLOG}
echo "RPD DEPLOYMENT SUMMARY: ${WORKDIR}/${DEPLOYLOG} " |tee -a ${WORKDIR}/${DEPLOYLOG}
exit 1
fi

echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step V -  Update Target RPD Connection Pool" |tee -a ${WORKDIR}/${DEPLOYLOG}
$BINHOME/datamodel.sh updateConnectionpool -C ${BKPLOC}/${TENV}_con_pool.json -SI ssi -U ${WLSID} -P ${TWLSPW} |tee -a ${WORKDIR}/${DEPLOYLOG}
grep "Step V -  Update Target RPD Connection Pool" -A 4 ${WORKDIR}/${DEPLOYLOG}|grep "Connection pool update completed successfully" >/dev/null
if [ $? -ne 0 ] 
then echo "Update Target RPD Connection Pool failed . Exit ..."  |tee -a ${WORKDIR}/${DEPLOYLOG} 
echo "Please manually restore connection pool by following command"|tee -a ${WORKDIR}/${DEPLOYLOG} echo "$BINHOME/datamodel.sh updateConnectionpool -C ${BKPLOC}/${TENV}_con_pool.json  -SI ssi -U ${WLSID} -P ${TWLSPW}" |tee -a ${WORKDIR}/${DEPLOYLOG} 
echo  >>${WORKDIR}/${DEPLOYLOG}
echo "RPD DEPLOYMENT SUMMARY: ${WORKDIR}/${DEPLOYLOG} " |tee -a ${WORKDIR}/${DEPLOYLOG} 
exit 1 
fi

if [[ $ENVIRONMENT == 'PROD' || $ENVIRONMENT == 'UAT' ]]
then
echo  |tee -a ${WORKDIR}/${DEPLOYLOG}
echo "Step VI - Rolling Bounce OBIEE "|tee -a ${WORKDIR}/${DEPLOYLOG}
cd ${BINHOME}
echo "Bounce bi_server1,obiccs1,obisch1,obips1,obijh1,obis1,obips3,obijh3"|tee -a ${WORKDIR}/${DEPLOYLOG}
./stop.sh -i  bi_server1,obiccs1,obisch1,obips1,obijh1,obis1,obips3,obijh3
rm -rf /app/oracle/bidata/catalog/service_instances/ssi/metadata/datamodel/customizations/connectionPools
cp -p /app/oracle/bidata/catalog/service_instances/ssi/metadata/datamodel/customizations_good/customization_order.xml  /app/oracle/bidata/catalog/service_instances/ssi/metadata/datamodel/customizations/
rm -rf /u01/app/oracle/admin/domains/mosbi/tmp/ssi/datamodel/customizations/connectionPools
cp -p /app/oracle/bidata/catalog/service_instances/ssi/metadata/datamodel/customizations_good/customization_order.xml  /u01/app/oracle/admin/domains/mosbi/tmp/ssi/datamodel/customizations/

./start.sh -i bi_server1,obiccs1,obips1,obijh1,obis1,obips3,obijh3
echo "Bounce bi_server2,obiccs2,obisch2,obips2,obijh2,obis2,obips4,obijh4"|tee -a ${WORKDIR}/${DEPLOYLOG}
./stop.sh -i  bi_server2,obiccs2,obisch2,obips2,obijh2,obis2,obips4,obijh4

ssh oracle@amomv2002 "rm -rf /u01/app/oracle/admin/domains/mosbi/tmp/ssi/datamodel/customizations/connectionPools"
ssh oracle@amomv2002 "cp -p /app/oracle/bidata/catalog/service_instances/ssi/metadata/datamodel/customizations_good/customization_order.xml  /u01/app/oracle/admin/domains/mosbi/tmp/ssi/datamodel/customizations/"
./start.sh -i bi_server2,obiccs2,obips2,obijh2,obis2,obips4,obijh4
fi

if [ $ENVIRONMENT == 'PROD' ]
then 
echo "Starting Scheduler in Production"
cd ${BINHOME}
./start.sh -i obisch1,obisch2
fi

if [ $ENVIRONMENT == 'STAGE' ]
then 
echo "Starting Scheduler in Production"
cd ${BINHOME}
./stop.sh -i bi_server1,obiccs1,obisch1,obips1,obijh1,obis1
./start.sh -i bi_server1,obiccs1,obips1,obijh1,obis1
fi

$BINHOME/status.sh|grep bi >>${WORKDIR}/${DEPLOYLOG}

BISTATUS=$(eval $BINHOME/status.sh|grep bi)

echo  >>${WORKDIR}/${DEPLOYLOG}
echo "RPD DEPLOYMENT SUMMARY: ${WORKDIR}/${DEPLOYLOG} " |tee -a ${WORKDIR}/${DEPLOYLOG} sleep 3
cat ${WORKDIR}/${DEPLOYLOG}

