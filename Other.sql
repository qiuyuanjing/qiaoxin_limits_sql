---��ECM�����һ��job������ͬ����ע�����ļ���Ȩ��
--what =�� DECLARE temp VARCHAR2(22); begin temp := CUS_QYJ_FUNC_UPDATE_MARKUP(); end;
--Next date=�� sysdate
--Interval =�� TRUNC(sysdate,'mi') + 1/ (24*60)
GRANT ALL ON DEV1_OCS.DOCMETA TO SYSTEM;

CREATE OR REPLACE FUNCTION CUS_QYJ_FUNC_UPDATE_MARKUP RETURN VARCHAR AS
  TEMP VARCHAR2(4);
BEGIN
  TEMP := '0';
  UPDATE DEV1_OCS.DOCMETA A
     SET A.XCLBRAUSERLIST = (SELECT B.XCLBRAUSERLIST
                               FROM DEV1_OCS.DOCMETA B
                              WHERE B.DID = A.XMARKUP_BASEDID)
   WHERE A.XMARKUP_BASEDID <> 0;
  COMMIT;
  RETURN TEMP;
END;


 --�� ECM �����ݿ������
 --�������ӵ�EBS��dbLink
 --drop database link to_EBS_Dev 
create database link to_EBS_Dev 
connect to system identified by manager   
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.62.227)(PORT=1531))(CONNECT_DATA=(SID=DEV)))';--����Ҫ����ʵ������޸�TNS

 --�� EBS �����ݿ������
 --�������ӵ�ECM�Ĺ�����dbLink
 --drop public database link to_ECM_Dev 
create public database link to_ECM_Dev 
connect to system identified by manager   
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=172.16.60.163)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=DEV)))';--����Ҫ����ʵ������޸�TNS
