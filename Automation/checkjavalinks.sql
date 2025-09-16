SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_CMS','SELECT ENGAGEMENT_ID FROM mos.cms_engagement where rownum < 5' ));

/*RETURN_STRING
--------------------------------------------------------------------------------
0
1
21
22
*/
SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_MOS_CC','SELECT sr_num FROM siebel.S_SRV_REQ where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- 1-10000646
-- 1-10010576
-- 1-10010586
-- 1-10010691

SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_ODS_MOS','SELECT sr_num FROM siebel.S_SRV_REQ where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- 1-10000646
-- 1-10010576
-- 1-10010586
-- 1-10010691

SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_GCCA','SELECT USERID FROM adminccastg.USERS where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- 10221
-- 10176
-- 10178
-- 10253

SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_NGCCR','SELECT USERNAME FROM sysman.CSP_SUPPRESSIONS where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- 6BDAFA2F6BD45E96E0401490BEAB2741
-- 6BDAFA2F6BD45E96E0401490BEAB2741
-- 6BDAFA2F6BD45E96E0401490BEAB2741
-- 6BDAFA2F6BD45E96E0401490BEAB2741

SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_SURE','SELECT TITLE FROM km.HP_ACTION where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- RCA Cycle Test Cycle for Jennifer: Testing RCA functionality
-- Review Alert document 477830.1
-- Review Alert document 477817.1
-- Review Alert document 763195.1

SELECT * FROM TABLE(ggate.urm_java_db_link.jdbc_run_query_get_Strings('JDBC_BUG','SELECT rptno FROM bug.rpthead# where rownum < 5' ));

-- RETURN_STRING
------------------------------------------------------------------------------
-- 208141
-- 208142
-- 208143
-- 208144