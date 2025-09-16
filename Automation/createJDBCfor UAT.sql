DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_BUG',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_BUG',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt11-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = GGATE01_bugau.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'Gg4t3');

DBMS_OUTPUT.put_line(res);
END;
/


DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_SURE',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_SURE',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt09-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = ggate01_surect.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'ggatecc');
DBMS_OUTPUT.put_line(res);
END;
/


DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_NGCCR',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_NGCCR',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt09-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = GGATE01_CCRCT.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'welcome2');
DBMS_OUTPUT.put_line(res);
END;
/


DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_CMS',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_CMS',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt09-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = ggate01_ornct.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'Gg4t3');
DBMS_OUTPUT.put_line(res);
END;
/


DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_GCCA',
    p_env      => 'Stage',
    p_db_alias => 'JDBC_GCCA',
    p_jdbc_url => '(DESCRIPTION = (FAILOVER = ON) (LOAD_BALANCE = ON) (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = wd0669-vip.us.oracle.com)(PORT = 1521)) (ADDRESS = (PROTOCOL = TCP)(HOST = wd0672-vip.us.oracle.com)(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = accastg.us.oracle.com) (FAILOVER_MODE = (TYPE = SESSION) (METHOD = BASIC))))',
    p_user     => 'GGATE',
    p_pwd      => 'welcome2');
DBMS_OUTPUT.put_line(res);
END;
/



DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_MOS_CC',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_MOS_CC',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt09-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = ggate01_ornct.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'Gg4t3');
DBMS_OUTPUT.put_line(res);
END;
/



DECLARE
res varchar2(2000);
BEGIN
--DBMS_JAVA.set_output(10000);
res := urm_java_db_link.create_jdbc_connection (
    p_app_name => 'JDBC_ODS_MOS',
    p_env      => 'UAT',
    p_db_alias => 'JDBC_ODS_MOS',
    p_jdbc_url => '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = umogridxt09-scan) (PORT = 1529)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = ggate01_ornct.us.oracle.com)))',
    p_user     => 'GGATE',
    p_pwd      => 'Gg4t3');
DBMS_OUTPUT.put_line(res);
END;
/