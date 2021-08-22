--***********************************************************
--*  �����T�v�F�W���u������t�`�F�b�N�p�f�[�^�iInput�j�A
--*            �l�b�g��������ԍ��Ǘ��쐬
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod389002_mainprocess(
    IN  inBusDateTemp                  varchar, -- �Ɩ����t
    IN  inFlagOff                      numeric, -- �t���O�n�e�e
    IN  inFlagOn                       numeric, -- �t���O�n�m
    IN  inJobid                        varchar, -- �W���u���ʂh�c
    IN  inOrdInTypeCustOrdId           numeric, -- �i0113:���������敪 / 4:�l�b�g�����j�̋敪ID
    IN  inOrdInTypeCustOrdCd           varchar, -- �i0113:���������敪 / 4:�l�b�g�����j�̋敪�R�[�h
    IN  inHomeOfficeShipTypShipId      numeric, -- �i0105:���������敪/2:�X�ܑ�s�j�̋敪ID
    IN  inHomeOfficeShipTypShipCd      varchar, -- �i0105:���������敪/2:�X�ܑ�s�j�̋敪�R�[�h
    OUT outInputCnt                    numeric, -- ���͌���
    OUT outOutputCnt1                  numeric, -- �l�b�g��������ԍ��Ǘ� �o�͌���
    OUT outOutputCnt2                  numeric, -- �W���u������t�`�F�b�N�p�f�[�^�iInput�j�o�͌���
    OUT outRet                         numeric, -- �֐��߂�l
    OUT outSqlState                    varchar  -- SQL�G���[�R�[�h

) AS $BODY$

  DECLARE
    -- �J�[�\��
    C01 refcursor;
    -- ���R�[�h
    pTinAlCur000 record;
    
    /* �ϐ���` */
    rowCnt             numeric;
    sqlErrState        text;
    sqlErrMsg          text;
    
    -- �������ԁi�o�^���ԁj
    timeStamp        timestamp;
    
    userID           varchar;
    aplName          varchar;
    
    -- SEQNO
    seqNo            numeric;
    -- ���͏�
    inputSeq         numeric;
    -- ����ꗗNO
    tranSerialNum    varchar;


BEGIN

    outInputCnt      := 0;
    outOutputCnt1    := 0;
    outOutputCnt2    := 0;
    outRet           := 0;
    outSqlState      := '';
    sqlErrMsg        := '';
    
    rowCnt           := 0;
    sqlErrState      := '';
    
    userID           := 'batch';
    aplName          := 'WAOD389002';
    
    seqNo            := 1;
    inputSeq         := 0;
    tranSerialNum    := '';
    
    --�����J�n���Ԏ擾
    SELECT CURRENT_TIMESTAMP INTO timeStamp;

    --���͌����̎擾
    SELECT COUNT(*) INTO outInputCnt FROM AODW_NET_ORDER_DATA;


    OPEN C01 FOR
        SELECT
            T01.TRAN_DATE,
            T01.TRAN_TIME,
            T01.TRAN_SERIAL_NUM,
            T01.BU_GP_STORE_ID,
            T01.BU_GP_CD,
            T01.ITEM_ID,
            T01.ITEM_CD,
            T01.ORDER_QUANTITY,
            T01.ORDER_TRAN_NUMBER,
            T01.ERROR_MSG
        FROM
            AODW_NET_ORDER_DATA T01
        ORDER BY
            T01.TRAN_SERIAL_NUM
        ;
        
    LOOP
    
        FETCH C01 INTO pTinAlCur000;
        
        IF NOT FOUND THEN
            
            EXIT;
            
        END IF;
        
        
        -- �l�b�g��������ԍ��Ǘ��DSEQNO �̎擾
        IF pTinAlCur000.TRAN_SERIAL_NUM LIKE tranSerialNum THEN
             seqNo := seqNo + 1;
        ELSE
            seqNo := 1;
        END IF
        ;
        
        --*******************************************************
        --�P �l�b�g��������ԍ��Ǘ� �o�^
        --*******************************************************
        INSERT INTO AODT_NET_ORDER_MNG (
            BU_GP_STORE_ID,
            BU_GP_CD,
            TRAN_DATE,
            TRAN_TIME,
            TRAN_SERIAL_NUM,
            SEQ_NO,
            ORDER_TRAN_NUMBER,
            ITEM_ID,
            ITEM_CD,
            ORDER_QUANTITY,
            SEND_FLAG,
            ERROR_MSG,
            DEL_FLAG,
            APPROVA_FLAG,
            INS_OPER_CD,
            INS_PROGRAM_CD,
            INS_DATE_TIME,
            FW_UPD_PROG_NM,
            FW_UPD_USER_ID,
            FW_UPD_DATE,
            VERSION
        ) VALUES (
            pTinAlCur000.BU_GP_STORE_ID,
            pTinAlCur000.BU_GP_CD,
            pTinAlCur000.TRAN_DATE,
            pTinAlCur000.TRAN_TIME,
            pTinAlCur000.TRAN_SERIAL_NUM,
            seqNo,
            pTinAlCur000.ORDER_TRAN_NUMBER,
            pTinAlCur000.ITEM_ID,
            pTinAlCur000.ITEM_CD,
            pTinAlCur000.ORDER_QUANTITY,
            inFlagOff,
            pTinAlCur000.ERROR_MSG,
            inFlagOff,
            CASE WHEN pTinAlCur000.ERROR_MSG = '' THEN inFlagOn ELSE inFlagOff END,
            userID,
            aplName,
            timeStamp,
            aplName,
            userID,
            timeStamp,
            1
        );
        
        GET DIAGNOSTICS rowCnt = ROW_COUNT;
        outOutputCnt1  := outOutputCnt1 + rowCnt;
        RAISE INFO '1-1 INSERT INTO aodt_net_order_mng: %��', outOutputCnt1 ;
        
        tranSerialNum := pTinAlCur000.TRAN_SERIAL_NUM;
        
        -- �W���u������t�`�F�b�N�p�f�[�^�iInput�j�D���͏��̉��Z
        inputSeq := inputSeq + 1;
        
        
        --*******************************************************
        --�Q �W���u������t�`�F�b�N�p�f�[�^�iInput�j �o�^
        --*******************************************************
        INSERT INTO AODW_ORDER_CHECK_JOB_INPUT (
            BF_JOB_ID,
            INPUT_SEQ,
            ORDER_TRAN_NUMBER,
            ORDER_INPUT_TYPE_ID,
            ORDER_INPUT_TYPE,
            HOME_OFFICE_SHIP_TYPE_ID,
            HOME_OFFICE_SHIP_TYPE,
            ITEM_ID,
            ITEM_CD,
            BU_GP_STORE_ID,
            STORE_CD,
            ORDER_PLAN_QTY,
            ORDER_PLAN_PIECE_QTY,
            ORDER_DATE,
            ERROR_MSG,
            HT_SEND_DATE_TIME,
            DEL_FLAG,
            APPROVA_FLAG,
            INS_OPER_CD,
            INS_PROGRAM_CD,
            INS_DATE_TIME,
            FW_UPD_PROG_NM,
            FW_UPD_USER_ID,
            FW_UPD_DATE,
            VERSION,
            HT_INPUT_ORDER_QTY,
            DESTINATION_CD
        ) VALUES (
            inJobid,
            inputSeq,
            pTinAlCur000.ORDER_TRAN_NUMBER,
            inOrdInTypeCustOrdId,
            inOrdInTypeCustOrdCd,
            inHomeOfficeShipTypShipId,
            inHomeOfficeShipTypShipCd,
            pTinAlCur000.ITEM_ID,
            pTinAlCur000.ITEM_CD,
            pTinAlCur000.BU_GP_STORE_ID,
            pTinAlCur000.BU_GP_CD,
            pTinAlCur000.ORDER_QUANTITY,
            pTinAlCur000.ORDER_QUANTITY,
            TO_TIMESTAMP(inBusDateTemp,'YYYYMMDDHH24MISS'),
            pTinAlCur000.ERROR_MSG,
            CASE WHEN pTinAlCur000.ERROR_MSG = '' THEN TO_TIMESTAMP(CONCAT( to_char(cast(pTinAlCur000.TRAN_DATE as date), 'YYYY-MM-DD') ,' ' ,pTinAlCur000.TRAN_TIME ), 'YYYY-MM-DD HH24:MI:SS') ELSE NULL END,
            inFlagOff,
            inFlagOn,
            userID,
            aplName,
            timeStamp,
            aplName,
            userID,
            timeStamp,
            1,
            pTinAlCur000.ORDER_QUANTITY,
            pTinAlCur000.TRAN_SERIAL_NUM
        );

        GET DIAGNOSTICS rowCnt = ROW_COUNT;
        outOutputCnt2  := outOutputCnt2 + rowCnt;
        RAISE INFO '1-1 INSERT INTO aodw_order_check_job_input: %��', outOutputCnt2 ;

    END LOOP; --FETCH C01 INTO pTinAlCur000

    CLOSE C01;

    EXCEPTION WHEN OTHERS THEN

        GET STACKED DIAGNOSTICS  sqlErrState = RETURNED_SQLSTATE, sqlErrMsg = MESSAGE_TEXT;
        RAISE INFO 'SQL EXCEPTION % : %', sqlErrState, sqlErrMsg;
        outSqlState := sqlErrState;
        outRet := 1;
        RETURN;

END $BODY$ LANGUAGE plpgsql;
