#!/bin/ksh

source /etc/init.d/oracle_wds_functions
chgsid rmsap1

SCHEMA=$1
DP_MGRPW=`/envadmin/Environments/prod/bin/passwdtool -q -c RMSDB/rmsems -a DP_MGR -e prod| cut -d ':' -f3`
SLOC='/ccr_refresh/rmsap_badges_export'
TLOC='/orn_refresh/rmsau_badges_import'
SCRIPTLOG=${SLOC}


DATE=$(date '+%Y%m%d_%H%M')

echo "Export Schema : "${SCHEMA}

expdp DP_MGR/${DP_MGRPW} dumpfile=${SCHEMA}.dmp directory=RMSAP_BADGES_EXPORT logfile=${SCHEMA}_exp_${DATE}.log schemas=${SCHEMA} parallel=8 exclude=STATISTICS

echo "Copying Schema DMP to target Environments"
scp -r ${SLOC}/${SCHEMA}.dmp oracle@umodx4095.us.oracle.com:${TLOC}