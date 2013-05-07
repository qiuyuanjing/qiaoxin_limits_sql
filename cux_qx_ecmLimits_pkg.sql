CREATE OR REPLACE PACKAGE CUX_QX_ECMLIMITS_PKG IS

  /**********************************
  *  ��ȡ<��ͬ>����Ȩ�������ķ���.
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_GETLIMITS_HT(HT_ID IN VARCHAR2) RETURN VARCHAR;

  /**********************************
  *  ��ȡ<����>����Ȩ�������ķ���.
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_GETLIMITS_JB(ZB_ID IN VARCHAR2) RETURN VARCHAR;

  /**********************************
  *  ��ȡ<�б�>����Ȩ�������ķ���.
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_GETLIMITS_ZB(ZB_ID IN VARCHAR2, XTYPE IN VARCHAR2)
    RETURN VARCHAR;

  /**********************************
  *  ��ȡ<�б�>����Ȩ�������ķ���.(�÷�����ȥ�жϸ��б��Ƿ��ѷ�����ֱ�ӻ�ȡ������Ա��Ȩ��)
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_GETLIMITS_ZB2(ZB_ID IN VARCHAR2, XTYPE IN VARCHAR2)
    RETURN VARCHAR;

  /**********************************
  *  ��ȡ<�ر�>����Ȩ�������ķ���.
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_GETLIMITS_HB(ZB_ID IN VARCHAR2,
                                 XTYPE IN VARCHAR2,
                                 HB_ID IN VARCHAR2) RETURN VARCHAR;

  /**********************************
  *  ����<�б�>id����������ļ���Ȩ��
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_UPDATE_LIMITSUSER(HT_ID    IN VARCHAR2,
                                      MYUSERID IN VARCHAR2) RETURN INTEGER;

  /**********************************
  *  ����<�б�>��ɾ������ļ���Ȩ��
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_DELETE_LIMITSUSER(HT_ID    IN VARCHAR2,
                                      MYUSERID IN VARCHAR2) RETURN INTEGER;

  /**********************************
  *  �ر귢��ʱ�����ӹ�Ӧ�̵�Ȩ�޵������еķ���
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_LIMITS_UPDATE_HB(ZB_ID IN VARCHAR2) RETURN INTEGER;

  /**********************************
  *  �б귢��ʱ�����ӹ�Ӧ�̵�Ȩ�޵������еķ���
  *  ���ߣ�qyj
  *  ʱ�䣺2013-5-7
  ***********************************/
  FUNCTION CUS_FUNC_LIMITS_UPDATE_ZB(ZB_ID IN VARCHAR2) RETURN INTEGER;
END;
/
CREATE OR REPLACE PACKAGE BODY CUX_QX_ECMLIMITS_PKG IS

 FUNCTION CUS_FUNC_GETLIMITS_HT(HT_ID IN VARCHAR2)
  RETURN VARCHAR AS
  USER_NAME VARCHAR2(50);
  USERLIST  VARCHAR2(300) := '';
  MYCOUNT   INT := 1;
  CURSOR CUR_USER_NAME_LIST IS
    SELECT PUI.USER_NAME
      FROM PO.PO_HEADERS_ALL PHA, APPS.PON_USER_INFO_V PUI
     WHERE PHA.PO_HEADER_ID = HT_ID
       AND PHA.CREATED_BY = PUI.USER_ID
    UNION
    SELECT PUI.USER_NAME
      FROM PO.PO_ACTION_HISTORY PAH, APPS.PON_USER_INFO_V PUI
     WHERE PAH.OBJECT_ID = HT_ID
       AND PAH.EMPLOYEE_ID = PUI.PERSON_ID
    UNION
    SELECT C.TO_ROLE
      FROM APPS.WF_COMMENTS C
     WHERE C.NOTIFICATION_ID =
           (SELECT MAX(NTFATTRIBSEO.NOTIFICATION_ID)
              FROM APPS.WF_MESSAGE_ATTRIBUTES_VL   MSGATTRIBSEO,
                   APPS.WF_NOTIFICATION_ATTRIBUTES NTFATTRIBSEO,
                   APPS.WF_NOTIFICATIONS           NTFEO,
                   PO.PO_HEADERS_ALL               PHA
             WHERE (MSGATTRIBSEO.NAME = NTFATTRIBSEO.NAME)
               AND (NTFATTRIBSEO.NOTIFICATION_ID = NTFEO.NOTIFICATION_ID)
               AND PHA.PO_HEADER_ID = HT_ID
               AND PHA.SEGMENT1 = NTFATTRIBSEO.TEXT_VALUE
               AND (NTFEO.NOTIFICATION_ID = NTFATTRIBSEO.NOTIFICATION_ID AND
                   NTFEO.MESSAGE_TYPE = MSGATTRIBSEO.MESSAGE_TYPE AND
                   NTFEO.MESSAGE_NAME = MSGATTRIBSEO.MESSAGE_NAME AND
                   MSGATTRIBSEO.NAME = NTFATTRIBSEO.NAME AND
                   MSGATTRIBSEO.NAME = 'DOCUMENT_NUMBER'))
    UNION
    SELECT C.TO_ROLE
      FROM APPS.WF_COMMENTS C
     WHERE C.NOTIFICATION_ID =
           (SELECT MAX(NTFATTRIBSEO.NOTIFICATION_ID)
              FROM APPS.WF_MESSAGE_ATTRIBUTES_VL   MSGATTRIBSEO,
                   APPS.WF_NOTIFICATION_ATTRIBUTES NTFATTRIBSEO,
                   APPS.WF_NOTIFICATIONS           NTFEO,
                   PO.PO_HEADERS_ALL               PHA
             WHERE (MSGATTRIBSEO.NAME = NTFATTRIBSEO.NAME)
               AND (NTFATTRIBSEO.NOTIFICATION_ID = NTFEO.NOTIFICATION_ID)
               AND PHA.PO_HEADER_ID = HT_ID
               AND PHA.SEGMENT1 = NTFATTRIBSEO.TEXT_VALUE
               AND (NTFEO.NOTIFICATION_ID = NTFATTRIBSEO.NOTIFICATION_ID AND
                   NTFEO.MESSAGE_TYPE = MSGATTRIBSEO.MESSAGE_TYPE AND
                   NTFEO.MESSAGE_NAME = MSGATTRIBSEO.MESSAGE_NAME AND
                   MSGATTRIBSEO.NAME = NTFATTRIBSEO.NAME AND
                   MSGATTRIBSEO.NAME = 'DOCUMENT_NUMBER'));
BEGIN
  OPEN CUR_USER_NAME_LIST;
  LOOP
    FETCH CUR_USER_NAME_LIST
      INTO USER_NAME;
    EXIT WHEN CUR_USER_NAME_LIST%NOTFOUND;
    BEGIN
      IF MYCOUNT = 1 THEN
        USERLIST := '&&' || UPPER(USER_NAME) || '(RWDA)';
        MYCOUNT  := 2;
      ELSE
        USERLIST := USERLIST || ',&&' || UPPER(USER_NAME) || '(RWDA)';
      END IF;
    END;
  END LOOP;
  CLOSE CUR_USER_NAME_LIST;
  RETURN USERLIST;
END;

FUNCTION CUS_FUNC_GETLIMITS_JB(ZB_ID IN VARCHAR2)
  RETURN VARCHAR AS
  USER_NAME VARCHAR2(50);
  USERLIST  VARCHAR2(300) := '';
  MYCOUNT   INT := 1;
  CURSOR CUR_USER_NAME_LIST IS
    SELECT DECODE(HIST.ACTION_USER_ID, 0, NULL, PUI.USER_NAME) APPROVER_NAME
      FROM APPS.PON_ACTION_HISTORY HIST,
           APPS.FND_USER           USERS,
           APPS.PER_ALL_PEOPLE_F   EMP,
           APPS.FND_LOOKUP_VALUES  LOOKUPS,
           APPS.PON_USER_INFO_V    PUI
     WHERE HIST.OBJECT_ID = ZB_ID
       AND PUI.PERSON_ID = EMP.PERSON_ID
       AND HIST.OBJECT_TYPE_CODE = 'NEGOTIATION_AWARD'
       AND HIST.ACTION_TYPE IN
           ('AWARD_APPROVAL_SUBMIT', 'AWARD_APPROVAL_PENDING',
            'AWARD_APPROVE', 'AWARD_REJECT', 'AWARD_APPROVAL_FORWARD',
            'AWARD_APPROVE_AND_FORWARD')
       AND HIST.ACTION_USER_ID = USERS.USER_ID
       AND USERS.EMPLOYEE_ID = EMP.PERSON_ID(+)
       AND LOOKUPS.LOOKUP_TYPE = 'PON_AWARD_APPROVAL_ACTION'
       AND HIST.ACTION_TYPE = LOOKUPS.LOOKUP_CODE
       AND LOOKUPS.LANGUAGE = USERENV('LANG')
       AND LOOKUPS.VIEW_APPLICATION_ID = 0
       AND LOOKUPS.SECURITY_GROUP_ID = 0
       AND TRUNC(SYSDATE) BETWEEN EMP.EFFECTIVE_START_DATE(+) AND
           EMP.EFFECTIVE_END_DATE(+)
    UNION
    SELECT UPPER(C.DDOCAUTHOR)
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV A, DEV1_OCS.REVISIONS@TO_ECM_DEV C
     WHERE A.DDOCNAME = C.DDOCNAME
       AND A.DAFBUSINESSOBJECT = ZB_ID
       AND DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL';
BEGIN
  OPEN CUR_USER_NAME_LIST;
  LOOP
    FETCH CUR_USER_NAME_LIST
      INTO USER_NAME;
    EXIT WHEN CUR_USER_NAME_LIST%NOTFOUND;
    BEGIN
      IF MYCOUNT = 1 THEN
        USERLIST := '&&' || UPPER(USER_NAME) || '(RWDA)';
        MYCOUNT  := 2;
      ELSE
        USERLIST := USERLIST || ',&&' || UPPER(USER_NAME) || '(RWDA)';
      END IF;
    END;
  END LOOP;
  CLOSE CUR_USER_NAME_LIST;
  RETURN USERLIST;
END;

FUNCTION CUS_FUNC_GETLIMITS_ZB(ZB_ID IN VARCHAR2,
                                                     XTYPE IN VARCHAR2)
  RETURN VARCHAR AS
  USER_NAME VARCHAR2(50);
  USERLIST  VARCHAR2(300) := '';
  MYCOUNT   INT := 1;
  CURSOR CUR_USER_NAME_LIST IS
    SELECT FR.USER_NAME
      FROM APPS.PON_NEG_TEAM_MEMBERS    TM,
           APPS.FND_USER                FR,
           APPS.QX_PEOPLE_ATT_VIEW_RESP RES
     WHERE TM.USER_ID = FR.USER_ID
       AND TM.AUCTION_HEADER_ID = ZB_ID
       AND FR.USER_ID = RES.USER_ID
       AND RES.CATEGORY_TYPE = XTYPE
    UNION
    SELECT FU.USER_NAME
      FROM FND_USER                 FU,
           FND_FLEX_VALUE_SETS      FVS,
           FND_FLEX_VALUES          FFV,
           APPS.PON_BIDDING_PARTIES PBP,
           APPS.PON_AUCTION_HEADERS_ALL PAH
     WHERE EMPLOYEE_ID IS NULL
       AND FVS.FLEX_VALUE_SET_NAME = 'QX_JOB_DOC_TYPE'
       AND FVS.FLEX_VALUE_SET_ID = FFV.FLEX_VALUE_SET_ID
       AND FFV.PARENT_FLEX_VALUE_LOW = '��Ӧ��'
       AND PBP.TRADING_PARTNER_CONTACT_ID = FU.CUSTOMER_ID
       AND PBP.AUCTION_HEADER_ID = ZB_ID
       AND FFV.ENABLED_FLAG = 'Y'
       AND FFV.FLEX_VALUE = XTYPE
       AND PBP.AUCTION_HEADER_ID = PAH.AUCTION_HEADER_ID
       AND PAH.AUCTION_STATUS <> 'DRAFT'  
    UNION
    SELECT UPPER(C.DDOCAUTHOR)
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV A, DEV1_OCS.REVISIONS@TO_ECM_DEV C
     WHERE A.DDOCNAME = C.DDOCNAME
       AND A.DAFBUSINESSOBJECT = ZB_ID
       AND DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL';
BEGIN
  OPEN CUR_USER_NAME_LIST;
  LOOP
    FETCH CUR_USER_NAME_LIST
      INTO USER_NAME;
    EXIT WHEN CUR_USER_NAME_LIST%NOTFOUND;
    BEGIN
      IF MYCOUNT = 1 THEN
        USERLIST := '&&' || UPPER(USER_NAME) || '(RWDA)';
        MYCOUNT  := 2;
      ELSE
        USERLIST := USERLIST || ',&&' || UPPER(USER_NAME) || '(RWDA)';
      END IF;
    END;
  END LOOP;
  CLOSE CUR_USER_NAME_LIST;
  RETURN USERLIST;
END;

FUNCTION CUS_FUNC_GETLIMITS_HB(ZB_ID IN VARCHAR2,
                                                     XTYPE IN VARCHAR2,
                                                     HB_ID IN VARCHAR2)
  RETURN VARCHAR AS
  USER_NAME VARCHAR2(50);
  USERLIST  VARCHAR2(300) := '';
  MYCOUNT   INT := 1;
  CURSOR CUR_USER_NAME_LIST IS
    SELECT FR.USER_NAME
      FROM APPS.PON_NEG_TEAM_MEMBERS    TM,
           APPS.FND_USER                FR,
           APPS.QX_PEOPLE_ATT_VIEW_RESP RES
     WHERE TM.USER_ID = FR.USER_ID
       AND TM.AUCTION_HEADER_ID = ZB_ID
       AND FR.USER_ID = RES.USER_ID
       AND RES.CATEGORY_TYPE = XTYPE
    UNION
    SELECT UPPER(C.DDOCAUTHOR)
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV A, DEV1_OCS.REVISIONS@TO_ECM_DEV C
     WHERE A.DDOCNAME = C.DDOCNAME
       AND A.DAFBUSINESSOBJECT = HB_ID
       AND DAFBUSINESSOBJECTTYPE = 'PON_BID_HEADERS';
BEGIN
  OPEN CUR_USER_NAME_LIST;
  LOOP
    FETCH CUR_USER_NAME_LIST
      INTO USER_NAME;
    EXIT WHEN CUR_USER_NAME_LIST%NOTFOUND;
    BEGIN
      IF MYCOUNT = 1 THEN
        USERLIST := '&&' || UPPER(USER_NAME) || '(RWDA)';
        MYCOUNT  := 2;
      ELSE
        USERLIST := USERLIST || ',&&' || UPPER(USER_NAME) || '(RWDA)';
      END IF;
    END;
  END LOOP;
  CLOSE CUR_USER_NAME_LIST;
  RETURN USERLIST;
END;

FUNCTION CUS_FUNC_GETLIMITS_ZB2(ZB_ID IN VARCHAR2,
                                                     XTYPE IN VARCHAR2)
  RETURN VARCHAR AS
  USER_NAME VARCHAR2(50);
  USERLIST  VARCHAR2(300) := '';
  MYCOUNT   INT := 1;
  CURSOR CUR_USER_NAME_LIST IS
    SELECT FR.USER_NAME
      FROM APPS.PON_NEG_TEAM_MEMBERS    TM,
           APPS.FND_USER                FR,
           APPS.QX_PEOPLE_ATT_VIEW_RESP RES
     WHERE TM.USER_ID = FR.USER_ID
       AND TM.AUCTION_HEADER_ID = ZB_ID
       AND FR.USER_ID = RES.USER_ID
       AND RES.CATEGORY_TYPE = XTYPE
    UNION
    SELECT FU.USER_NAME
      FROM FND_USER                 FU,
           FND_FLEX_VALUE_SETS      FVS,
           FND_FLEX_VALUES          FFV,
           APPS.PON_BIDDING_PARTIES PBP
     WHERE EMPLOYEE_ID IS NULL
       AND FVS.FLEX_VALUE_SET_NAME = 'QX_JOB_DOC_TYPE'
       AND FVS.FLEX_VALUE_SET_ID = FFV.FLEX_VALUE_SET_ID
       AND FFV.PARENT_FLEX_VALUE_LOW = '��Ӧ��'
       AND PBP.TRADING_PARTNER_CONTACT_ID = FU.CUSTOMER_ID
       AND PBP.AUCTION_HEADER_ID = ZB_ID
       AND FFV.ENABLED_FLAG = 'Y'
       AND FFV.FLEX_VALUE = XTYPE
    UNION
    SELECT UPPER(C.DDOCAUTHOR)
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV A, DEV1_OCS.REVISIONS@TO_ECM_DEV C
     WHERE A.DDOCNAME = C.DDOCNAME
       AND A.DAFBUSINESSOBJECT = ZB_ID
       AND DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL';
BEGIN
  OPEN CUR_USER_NAME_LIST;
  LOOP
    FETCH CUR_USER_NAME_LIST
      INTO USER_NAME;
    EXIT WHEN CUR_USER_NAME_LIST%NOTFOUND;
    BEGIN
      IF MYCOUNT = 1 THEN
        USERLIST := '&&' || UPPER(USER_NAME) || '(RWDA)';
        MYCOUNT  := 2;
      ELSE
        USERLIST := USERLIST || ',&&' || UPPER(USER_NAME) || '(RWDA)';
      END IF;
    END;
  END LOOP;
  CLOSE CUR_USER_NAME_LIST;
  RETURN USERLIST;
END;

FUNCTION CUS_FUNC_UPDATE_LIMITSUSER(ht_id IN VARCHAR2,myUserID IN VARCHAR2)
RETURN INTEGER
AS
   my_docm_did VARCHAR2(50);
   XType    VARCHAR2(50);
   userList VARCHAR2(60);
   tempList VARCHAR2(300);
   myflag   INTEGER;
   CURSOR cur_list IS  
        SELECT r.did, d.xecmtest
          FROM dev1_ocs.afobjects@to_ecm_dev t, DEV1_OCS.REVISIONS@to_ecm_dev r, DEV1_OCS.DOCMETA@to_ecm_dev d
         WHERE t.ddocname = r.ddocname
           AND d.did = r.did
           AND t.DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL'
           AND t.dafbusinessobject = ht_id;
   RESULT INTEGER;
BEGIN
   RESULT := 0;
   SELECT US.USER_NAME INTO userList FROM apps.FND_USER US WHERE US.USER_ID = myUserID;
   OPEN cur_list;
    LOOP
      FETCH cur_list INTO my_docm_did,XType; 
        EXIT WHEN cur_list%NOTFOUND;
           BEGIN
              SELECT COUNT(1) INTO myflag FROM apps.qx_people_att_view_resp res WHERE res.user_id = myUserID AND res.category_type = XType;
              IF myflag>0 THEN
                  SELECT doc.xclbrauserlist INTO tempList FROM DEV1_OCS.DOCMETA@to_ecm_dev doc WHERE doc.did = my_docm_did;
               IF tempList IS NOT NULL THEN 
                  UPDATE DEV1_OCS.DOCMETA@to_ecm_dev a SET a.xclbrauserlist = a.xclbrauserlist || ',&&' || upper(userList) || '(RWDA)' WHERE a.did = my_docm_did OR XMARKUP_BASEDID = my_docm_did;
               ELSE
                  UPDATE DEV1_OCS.DOCMETA@to_ecm_dev a SET a.xclbrauserlist = '&&' || upper(userList) || '(RWDA)' WHERE a.did = my_docm_did OR XMARKUP_BASEDID = my_docm_did;
               END IF;
               RESULT := RESULT + 1;
              END IF;
           END;
    END LOOP;
    CLOSE cur_list;
   RETURN RESULT;
END;

FUNCTION CUS_FUNC_DELETE_LIMITSUSER(HT_ID  IN VARCHAR2, MYUSERID IN VARCHAR2)
  RETURN INTEGER AS
  MY_DOCM_DID VARCHAR2(50);
  XTYPE       VARCHAR2(50);
  USERLIST    VARCHAR2(60);
  TEMPLIST    VARCHAR2(300);
  MYFLAG      INTEGER;
  CURSOR CUR_LIST IS
    SELECT R.DID, D.XECMTEST
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV T,
           DEV1_OCS.REVISIONS@TO_ECM_DEV R,
           DEV1_OCS.DOCMETA@TO_ECM_DEV   D
     WHERE T.DDOCNAME = R.DDOCNAME
       AND D.DID = R.DID
       AND T.DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL'
       AND T.DAFBUSINESSOBJECT = HT_ID;
  RESULT INTEGER;
BEGIN
  RESULT := 0;
  SELECT US.USER_NAME
    INTO USERLIST
    FROM APPS.FND_USER US
   WHERE US.USER_ID = MYUSERID;
  OPEN CUR_LIST;
  LOOP
    FETCH CUR_LIST
      INTO MY_DOCM_DID, XTYPE;
    EXIT WHEN CUR_LIST%NOTFOUND;
    BEGIN
      SELECT COUNT(1)
        INTO MYFLAG
        FROM APPS.QX_PEOPLE_ATT_VIEW_RESP RES
       WHERE RES.USER_ID = MYUSERID
         AND RES.CATEGORY_TYPE = XTYPE;
      IF MYFLAG > 0 THEN
        SELECT DOC.XCLBRAUSERLIST
          INTO TEMPLIST
          FROM DEV1_OCS.DOCMETA@TO_ECM_DEV DOC
         WHERE DOC.DID = MY_DOCM_DID;
        IF TEMPLIST IS NOT NULL THEN
          IF INSTR(TEMPLIST, '&&' || UPPER(USERLIST)) = 1 THEN
            UPDATE DEV1_OCS.DOCMETA@TO_ECM_DEV A
               SET A.XCLBRAUSERLIST = REGEXP_REPLACE(A.XCLBRAUSERLIST,
                                                     '&&' || UPPER(USERLIST) ||
                                                     '\(([A-Z])*\),')
             WHERE A.DID = MY_DOCM_DID OR A.XMARKUP_BASEDID = MY_DOCM_DID;
          ELSE
            UPDATE DEV1_OCS.DOCMETA@TO_ECM_DEV A
               SET A.XCLBRAUSERLIST = REGEXP_REPLACE(A.XCLBRAUSERLIST,
                                                     ',&&' || UPPER(USERLIST) ||
                                                     '\(([A-Z])*\)')
             WHERE A.DID = MY_DOCM_DID OR A.XMARKUP_BASEDID = MY_DOCM_DID;
          END IF;
        END IF;
        RESULT := RESULT + 1;
      END IF;
    END;
  END LOOP;
  CLOSE CUR_LIST;
  RETURN RESULT;
END;

FUNCTION CUS_FUNC_LIMITS_UPDATE_HB(ZB_ID IN VARCHAR2)
  RETURN INTEGER AS
  MY_DOCM_DID VARCHAR2(100);
  XTYPE       VARCHAR2(100);
  MY_HB_ID    VARCHAR2(100);
  TEMPLIST    VARCHAR2(600);
  CURSOR CUR_LIST IS
    SELECT R.DID, D.XECMTEST ,BH.BID_NUMBER
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV T,
           DEV1_OCS.REVISIONS@TO_ECM_DEV R,
           DEV1_OCS.DOCMETA@TO_ECM_DEV   D,
           PON_BID_HEADERS BH
     WHERE T.DDOCNAME = R.DDOCNAME
       AND D.DID = R.DID
       AND T.DAFBUSINESSOBJECTTYPE = 'PON_BID_HEADERS'
       AND T.DAFBUSINESSOBJECT = BH.BID_NUMBER
       AND BH.AUCTION_HEADER_ID = ZB_ID;
  RESULT INTEGER;
BEGIN
  RESULT := 0;
  OPEN CUR_LIST;
  LOOP
    FETCH CUR_LIST
      INTO MY_DOCM_DID, XTYPE , MY_HB_ID;
    EXIT WHEN CUR_LIST%NOTFOUND;
    BEGIN
      RESULT   := RESULT + 1;
      TEMPLIST := CUS_FUNC_GETLIMITS_HB(ZB_ID, XTYPE ,MY_HB_ID);
      UPDATE DEV1_OCS.DOCMETA@TO_ECM_DEV A SET A.XCLBRAUSERLIST = TEMPLIST WHERE A.DID = MY_DOCM_DID OR A.XMARKUP_BASEDID = MY_DOCM_DID;
    END;
  END LOOP;
  CLOSE CUR_LIST;
  RETURN RESULT;
END;

FUNCTION CUS_FUNC_LIMITS_UPDATE_ZB(ZB_ID IN VARCHAR2)
  RETURN INTEGER AS
  MY_DOCM_DID VARCHAR2(50);
  XTYPE       VARCHAR2(50);
  TEMPLIST    VARCHAR2(300);
  CURSOR CUR_LIST IS
    SELECT R.DID, D.XECMTEST
      FROM DEV1_OCS.AFOBJECTS@TO_ECM_DEV T,
           DEV1_OCS.REVISIONS@TO_ECM_DEV R,
           DEV1_OCS.DOCMETA@TO_ECM_DEV   D
     WHERE T.DDOCNAME = R.DDOCNAME
       AND D.DID = R.DID
       AND T.DAFBUSINESSOBJECTTYPE = 'PON_AUCTION_HEADERS_ALL'
       AND T.DAFBUSINESSOBJECT = ZB_ID;
  RESULT INTEGER;
BEGIN
  RESULT := 0;
  OPEN CUR_LIST;
  LOOP
    FETCH CUR_LIST
      INTO MY_DOCM_DID, XTYPE;
    EXIT WHEN CUR_LIST%NOTFOUND;
    BEGIN
      RESULT   := RESULT + 1;
      TEMPLIST := CUS_FUNC_GETLIMITS_ZB2(ZB_ID, XTYPE);
      UPDATE DEV1_OCS.DOCMETA@TO_ECM_DEV A SET A.XCLBRAUSERLIST = TEMPLIST WHERE A.DID = MY_DOCM_DID OR A.XMARKUP_BASEDID = MY_DOCM_DID;
    END;
  END LOOP;
  CLOSE CUR_LIST;
  RETURN RESULT;
END;

END;
/