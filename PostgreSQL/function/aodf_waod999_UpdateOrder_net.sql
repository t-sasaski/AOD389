--***********************************************************
--*  処理概要：発注受付データ登録・更新処理
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod999_UpdateOrder_net(
    IN  wUsFlagOff                      numeric, -- フラグＯＦＦ
    IN  wUsFlagOn                       numeric, -- フラグＯＮ
    IN  wUsBfJobId                      varchar, -- ジョブ識別ＩＤ
    IN  wUsOrderInputType4              numeric, -- （0113:発注発生区分 / 4:ネット注文）
    OUT wUsInputCnt                     numeric, -- 入力件数
    OUT wUsAodtOrderDataInsCnt          numeric, -- 出力件数（発注受付データ 登録件数）
    OUT wUsAodtNetOrderUpdCnt           numeric, -- 更新件数（ネット注文取引番号管理 更新件数）
    OUT wUsRet                          numeric, -- 関数戻り値
    OUT wUsSqlState                     varchar  -- SQLエラーコード
) AS $BODY$

  DECLARE

    /* 変数定義 */
    vRowCnt             integer;
    vSqlState           text;
    vSqlErrMsg          text;
    
    -- 処理時間
    wUsTimeStamp        timestamp;
    
    wCmUserID           varchar;
    wCmAplName          varchar;
    
  BEGIN

        wUsInputCnt                 := 0;
        wUsAodtOrderDataInsCnt      := 0;
        wUsAodtNetOrderUpdCnt        := 0;
        wUsRet                      := 0;
        wUsSqlState                 := '00000';
        
        vRowCnt                     := 0;
        vSqlState                   := '';
        vSqlErrMsg                  := '';
        
        wCmUserID                  := 'batch';
        wCmAplName                 := 'AOD999u_ne';
        
        -- 処理開始時間取得
        SELECT CURRENT_TIMESTAMP INTO wUsTimeStamp;
        
        RAISE INFO 'START FUNCTION aodf_waod999_UpdateOrder_net' ;
        
        --*********************************************************
        -- １．発注受付データ登録
        --********************************************************
        INSERT INTO aodt_order_data (
             order_tran_number
            ,order_input_type_id
            ,order_input_type
            ,home_office_ship_type_id
            ,home_office_ship_type
            ,item_id
            ,item_cd
            ,item_nm
            ,standard_nm
            ,base_cost_unit_price
            ,cost_amt
            ,r_price
            ,retail_amt
            ,bu_gp_store_id
            ,store_cd
            ,store_nm
            ,order_plan_qty
            ,order_plan_piece_qty
            ,tot_order_unit_qty
            ,order_date
            ,last_dlvy_reserve_date
            ,error_msg
            ,ht_send_date_time
            ,del_flag
            ,approva_flag
            ,ins_oper_cd
            ,ins_program_cd
            ,ins_date_time
            ,fw_upd_prog_nm
            ,fw_upd_user_id
            ,fw_upd_date
            ,version
            ,ht_input_order_qty
            ,destination_cd
        )
        SELECT
            CASE
                WHEN T01_ORDER_TRAN_NUMBER IS NULL THEN
                    nextval('aod_order_tran_seq')
                ELSE
                    T01_ORDER_TRAN_NUMBER
            END AS ORDER_TRAN_NUMBER
           ,T01_ORDER_INPUT_TYPE_ID
           ,T01_ORDER_INPUT_TYPE
           ,T01_HOME_OFFICE_SHIP_TYPE_ID
           ,T01_HOME_OFFICE_SHIP_TYPE
           ,T01_ITEM_ID
           ,T01_ITEM_CD
           ,T01_ITEM_NM
           ,T01_STANDARD_NM
           ,T01_BASE_COST_UNIT_PRICE
           ,T01_COST_AMT
           ,T01_R_PRICE
           ,T01_RETAIL_AMT
           ,T01_BU_GP_STORE_ID
           ,T01_STORE_CD
           ,T01_STORE_NM
           ,T01_ORDER_PLAN_QTY
           ,T01_ORDER_PLAN_PIECE_QTY
           ,T01_TOT_ORDER_UNIT_QTY
           ,T01_ORDER_DATE
           ,T01_LAST_DLVY_RESERVE_DATE
           ,T01_ERROR_MSG
           ,T01_HT_SEND_DATE_TIME
           ,T01_DEL_FLAG
           ,T01_APPROVA_FLAG
           ,wCmUserID
           ,wCmAplName
           ,wUsTimeStamp
           ,wCmAplName
           ,wCmUserID
           ,wUsTimeStamp
           ,1
           ,T01_HT_INPUT_ORDER_QTY
           ,T01_DESTINATION_CD
        FROM
            (
            SELECT
                T01.order_tran_number                   AS T01_ORDER_TRAN_NUMBER
               ,T01.order_input_type_id                 AS T01_ORDER_INPUT_TYPE_ID
               ,T01.order_input_type                    AS T01_ORDER_INPUT_TYPE
               ,T01.home_office_ship_type_id            AS T01_HOME_OFFICE_SHIP_TYPE_ID
               ,T01.home_office_ship_type               AS T01_HOME_OFFICE_SHIP_TYPE
               ,coalesce(T01.item_id, 0)                AS T01_ITEM_ID
               ,coalesce(T01.item_cd,'')                AS T01_ITEM_CD
               ,T01.item_nm                             AS T01_ITEM_NM
               ,T01.standard_nm                         AS T01_STANDARD_NM
               ,coalesce(T01.base_cost_unit_price, 0)   AS T01_BASE_COST_UNIT_PRICE
               ,coalesce(T01.cost_amt, 0)               AS T01_COST_AMT
               ,coalesce(T01.r_price, 0)                AS T01_R_PRICE
               ,coalesce(T01.retail_amt, 0)             AS T01_RETAIL_AMT
               ,coalesce(T01.bu_gp_store_id, 0)         AS T01_BU_GP_STORE_ID
               ,coalesce(T01.store_cd, '')              AS T01_STORE_CD
               ,T01.store_nm                            AS T01_STORE_NM
               ,T01.order_plan_qty                      AS T01_ORDER_PLAN_QTY
               ,T01.order_plan_piece_qty                AS T01_ORDER_PLAN_PIECE_QTY
               ,T01.tot_order_unit_qty                  AS T01_TOT_ORDER_UNIT_QTY
               ,T01.order_date                          AS T01_ORDER_DATE
               ,T01.last_dlvy_reserve_date              AS T01_LAST_DLVY_RESERVE_DATE
               ,T01.error_msg                           AS T01_ERROR_MSG
               ,T01.ht_send_date_time                   AS T01_HT_SEND_DATE_TIME
               ,T01.del_flag                            AS T01_DEL_FLAG
               ,T01.approva_flag                        AS T01_APPROVA_FLAG
               ,T01.ht_input_order_qty                  AS T01_HT_INPUT_ORDER_QTY
               ,T01.destination_cd                      AS T01_DESTINATION_CD
            FROM aodw_order_check_job_output T01
            WHERE
                T01.bf_job_id   = wUsBfJobId
            ORDER BY
                T01.input_seq
            ) AS FOO
        ;
        
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        wUsInputCnt := vRowCnt;
        wUsAodtOrderDataInsCnt := vRowCnt;
        RAISE INFO '1. INSERT INTO aodt_order_data: %件', vRowCnt;
        
        
        --*********************************************************
        -- ２．景品注文取引番号管理更新
        --      ・ジョブ発注受付チェック用データ（Output）を元に
        --        エラーメッセージを更新
        --********************************************************

        UPDATE aodt_net_order_mng
        SET
            error_msg               = CASE 
                                        WHEN T01.del_flag = wUsFlagOn OR aodt_net_order_mng.error_msg = ''THEN
                                            T01.error_msg
                                        ELSE
                                            aodt_net_order_mng.error_msg
                                      END
           ,order_date              = T01.order_date
           ,last_dlvy_reserve_date  = T01.last_dlvy_reserve_date
           ,del_flag                = CASE 
                                        WHEN T01.del_flag = wUsFlagOn THEN
                                            wUsFlagOn
                                        ELSE
                                            wUsFlagOff
                                      END
           ,approva_flag            = CASE
                                        WHEN T01.del_flag = wUsFlagOn OR T01.error_msg != '' OR aodt_net_order_mng.error_msg != '' THEN
                                            wUsFlagOff
                                        ELSE
                                            wUsFlagOn
                                      END
           ,upd_oper_cd             = wCmUserID
           ,upd_program_cd          = wCmAplName
           ,upd_date_time           = wUsTimeStamp
           ,fw_upd_prog_nm          = wCmAplName
           ,fw_upd_date             = wUsTimeStamp
           ,fw_upd_user_id          = wCmUserID
           ,version                 = aodt_net_order_mng.version + 1
        FROM aodw_order_check_job_output T01
        WHERE
            T01.bf_job_id           = wUsBfjobId
        AND T01.order_input_type_id = wUsOrderInputType4
        AND T01.order_tran_number   = aodt_net_order_mng.order_tran_number
        ;
        
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        wUsAodtNetOrderUpdCnt := vRowCnt;
        RAISE INFO '2. UPDATE aodt_net_order_mng: %件', vRowCnt;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS  vSqlState = RETURNED_SQLSTATE, vSqlErrMsg = MESSAGE_TEXT;
        RAISE WARNING 'SQL EXCEPTION % : %', vSqlState, vSqlErrMsg ;
        wUsSqlState := vSqlState;
        wUsRet := 1;
        RETURN;
    
END $BODY$ LANGUAGE plpgsql;

