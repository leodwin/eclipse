#!/bin/ksh

source /etc/init.d/oracle_wds_functions
chgsid rmsau1

SCHEMA=$1
DP_MGRPW=`/envadmin/Environments/test/bin/passwdtool -q -c RMSDB/rmsems -a DP_MGR -e test| cut -d ':' -f3`
SLOC='/ccr_refresh/rmsap_badges_export'
TLOC='/orn_refresh/rmsau_badges_import'
SCRIPTLOG=${SLOC}

echo "Backing up Grants"
sqlplus -s '/as sysdba' <<HERE1 > post_ref_grants_${SCHEMA}.sql
@/home/oracle/jenkins/rms_badges_grants.sql ${SCHEMA}
HERE1

echo "Backing up Passwords"
sqlplus -s '/as sysdba' <<HERE2 > post_ref_passwd_${SCHEMA}.sql
select 'alter user '||a.name||' identified by values '''||a.password||''' profile '||b.profile||';' from user$ a,dba_users b where a.user#=b.user_id and b.username='$user_name';
HERE2

DATE=$(date '+%Y%m%d_%H%M')

echo "Dropping User"${SCHEMA}

sqlplus -s / as sysdba << EOF
drop user ${SCHEMA} cascade;
EOF


echo "Import Schema : "${SCHEMA}

impdp DP_MGR/${DP_MGRPW} dumpfile=${SCHEMA}.dmp directory=RMSAU_BADGES_IMPORT logfile=${SCHEMA}_imp_${DATE}.log schemas=${SCHEMA} parallel=8

sqlplus -s '/as sysdba' <<HERE1 > post_steps.log
@post_ref_passwd_${SCHEMA}.sql
@post_ref_grants_${SCHEMA}.sql
HERE1