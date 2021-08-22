--***********************************************************
--*  処理概要：ジョブ発注受付チェック用データ（Input）、
--*            ネット注文取引番号管理作成
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod389002_mainprocess(
    IN  inBusDateTemp                  varchar, -- 業務日付
    IN  inFlagOff                      numeric, -- フラグＯＦＦ
    IN  inFlagOn                       numeric, -- フラグＯＮ
    IN  inJobid                        varchar, -- ジョブ識別ＩＤ
    IN  inOrdInTypeCustOrdId           numeric, -- （0113:発注発生区分 / 4:ネット注文）の区分ID
    IN  inOrdInTypeCustOrdCd           varchar, -- （0113:発注発生区分 / 4:ネット注文）の区分コード
    IN  inHomeOfficeShipTypShipId      numeric, -- （0105:発注発生区分/2:店舗代行）の区分ID
    IN  inHomeOfficeShipTypShipCd      varchar, -- （0105:発注発生区分/2:店舗代行）の区分コード
    OUT outInputCnt                    numeric, -- 入力件数
    OUT outOutputCnt1                  numeric, -- ネット注文取引番号管理 出力件数
    OUT outOutputCnt2                  numeric, -- ジョブ発注受付チェック用データ（Input）出力件数
    OUT outRet                         numeric, -- 関数戻り値
    OUT outSqlState                    varchar  -- SQLエラーコード

) AS $BODY$

  DECLARE
    -- カーソル
    C01 refcursor;
    -- レコード
    pTinAlCur000 record;
    
    /* 変数定義 */
    rowCnt             numeric;
    sqlErrState        text;
    sqlErrMsg          text;
    
    -- 処理時間（登録時間）
    timeStamp        timestamp;
    
    userID           varchar;
    aplName          varchar;
    
    -- SEQNO
    seqNo            numeric;
    -- 入力順
    inputSeq         numeric;
    -- 取引一覧NO
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
    
    --処理開始時間取得
    SELECT CURRENT_TIMESTAMP INTO timeStamp;

    --入力件数の取得
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
        
        
        -- ネット注文取引番号管理．SEQNO の取得
        IF pTinAlCur000.TRAN_SERIAL_NUM LIKE tranSerialNum THEN
             seqNo := seqNo + 1;
        ELSE
            seqNo := 1;
        END IF
        ;
        
        --*******************************************************
        --１ ネット注文取引番号管理 登録
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
        RAISE INFO '1-1 INSERT INTO aodt_net_order_mng: %件', outOutputCnt1 ;
        
        tranSerialNum := pTinAlCur000.TRAN_SERIAL_NUM;
        
        -- ジョブ発注受付チェック用データ（Input）．入力順の加算
        inputSeq := inputSeq + 1;
        
        
        --*******************************************************
        --２ ジョブ発注受付チェック用データ（Input） 登録
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
        RAISE INFO '1-1 INSERT INTO aodw_order_check_job_input: %件', outOutputCnt2 ;

    END LOOP; --FETCH C01 INTO pTinAlCur000

    CLOSE C01;

    EXCEPTION WHEN OTHERS THEN

        GET STACKED DIAGNOSTICS  sqlErrState = RETURNED_SQLSTATE, sqlErrMsg = MESSAGE_TEXT;
        RAISE INFO 'SQL EXCEPTION % : %', sqlErrState, sqlErrMsg;
        outSqlState := sqlErrState;
        outRet := 1;
        RETURN;

END $BODY$ LANGUAGE plpgsql;
