DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_GCCA');
DBMS_OUTPUT.put_line(res);
END;
/

DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_BUG');
DBMS_OUTPUT.put_line(res);
END;
/


DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_SURE');
DBMS_OUTPUT.put_line(res);
END;
/

DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_NGCCR');
DBMS_OUTPUT.put_line(res);
END;
/

DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_CMS');
DBMS_OUTPUT.put_line(res);
END;
/

DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_MOS_CC');
DBMS_OUTPUT.put_line(res);
END;
/

DECLARE
res varchar2(2000);
BEGIN
res := urm_java_db_link.delete_jdbc_connection (p_db_alias => 'JDBC_ODS_MOS');
DBMS_OUTPUT.put_line(res);
END;
/
