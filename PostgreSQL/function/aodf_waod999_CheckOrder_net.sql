--***********************************************************
--*  処理概要：ジョブ発注受付チェック用データ（Output）作成
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod999_CheckOrder_net(
    IN wUsFlagOff                       numeric, --フラグＯＦＦ
    IN wUsFlagOn                        numeric, --フラグＯＮ

    IN wUsErrorMsg_ABC10001             varchar,
    IN wUsErrorMsg_ABC10002             varchar,
    IN wUsErrorMsg_ABC10003             varchar,
    IN wUsErrorMsg_ABC10004             varchar,
    IN wUsErrorMsg_ABC10005             varchar,
    IN wUsErrorMsg_ABC10006             varchar,
    IN wUsErrorMsg_ABC10007             varchar,
    IN wUsErrorMsg_ABC10008             varchar,
    IN wUsErrorMsg_ABC10009             varchar,
    
    IN wUsItemValidTypeStop             numeric, --商品取扱停止区分＿取扱停止
    IN wUsOrderTargetTypeOff            numeric, --発注対象区分＿対象外

    OUT wUsInputCnt                     numeric, --入力件数
    OUT wUsOutputCnt                    numeric, --出力件数
    OUT wUsRet                          numeric, --関数戻り値
    OUT wUsSqlState                     varchar  --SRQエラーコード

) AS $BODY$

  DECLARE
  
    /* 変数定義 */
    vSqlState           text;
    vSqlErrMsg          text;
    vRowCnt             integer;

    wCmUserID           varchar;
    wCmAplName          varchar;

    wUsLastDlvyReserveDate  timestamp;
    
    PAR_LT_Net_Sun   varchar;
    PAR_LT_Net_Mon   varchar;
    PAR_LT_Net_Tue   varchar;
    PAR_LT_Net_Wed   varchar;
    PAR_LT_Net_Thu   varchar;
    PAR_LT_Net_Fri   varchar;
    PAR_LT_Net_Sat   varchar;

  BEGIN
        RAISE WARNING 'START FUNCTION aodf_waod999_CheckOrder_net' ;

        wUsInputCnt     := 0;
        wUsOutputCnt    := 0;
        wUsRet          := 0;
        wUsSqlState     := '00000';
        
        wCmUserID       := 'batch';
        wCmAplName      := 'AOD999c_ne';
        
        wUsLastDlvyReserveDate  := NULL;
        
        --日曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Sun
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sun'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --月曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Mon
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Mon'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --火曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Tue
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Tue'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --水曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Wed
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Wed'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --木曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Thu
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Thu'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --金曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Fri
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Fri'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --土曜日の納品リードタイムを取得
        SELECT value
            INTO PAR_LT_Net_Sat
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sat'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;


        --********************************************************
        -- １．ジョブ発注データ（Input）を元に
        --     商品、組織ユニットマスタ情報を取得
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table1;
        CREATE TABLE aodw_order_work_table1 AS
        SELECT
             A.bf_job_id                        -- ジョブ識別ＩＤ
            ,A.input_seq                        -- 入力順
            ,A.ht_send_date_time                -- HT送信日時
            ,A.order_input_type_id              -- 発注発生区分ＩＤ
            ,A.order_input_type                 -- 発注発生区分
            ,A.home_office_ship_type_id         -- 本部送込区分ＩＤ
            ,A.home_office_ship_type            -- 本部送込区分
            ,B.item_id                          -- 商品ＩＤ
            ,B.item_cd                          -- 商品ＣＤ
            ,B.item_nm                          -- 商品ＮＭ
            ,B.standard_nm                      -- 規格名
            ,A.order_plan_qty AS order_recommendation_input_qty -- 発注数
            ,A.order_date                       -- 発注日
            ,B.order_cntl_type_id               -- 発注対象区分ＩＤ
            ,B.dealing_off_type_id              -- 商品取扱停止区分ＩＤ
            ,C.bu_gp_id AS bu_gp_store_id       -- 店舗ＩＤ
            ,C.bu_gp_cd AS store_cd             -- 店舗ＣＤ
            ,C.bu_gp_nm AS store_nm             -- 店舗ＮＭ
            ,C.close_date                       -- 閉店日
            ,C.order_start_date                 -- 発注開始日
            ,C.order_stop_date                  -- 発注終了日
            ,A.error_msg                        -- エラーメッセージ
        FROM aodw_order_check_job_input AS A
--        INNER JOIN amsm_item AS B
        LEFT JOIN amsm_item AS B
--        ON  B.item_id          = A.item_id
        ON  A.item_id          = B.item_id
        AND B.app_start_date  <= A.order_date
        AND B.app_end_date    >= A.order_date
--        INNER JOIN amsm_bu_grp AS C
        LEFT JOIN amsm_bu_grp AS C
--        ON  C.bu_gp_id   = A.bu_gp_store_id
        ON  A.bu_gp_store_id   = C.bu_gp_id
        AND C.app_start_date  <= A.order_date
        AND C.app_end_date    >= A.order_date
        ;

        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '1. INSERT aodw_order_work_table1  : %件', vRowCnt ;


        --********************************************************
        -- ２．商品発注制御マスタ情報を取得
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table2;
        CREATE TABLE aodw_order_work_table2 AS
        SELECT
             A.bf_job_id                        -- ジョブ識別ＩＤ
            ,A.input_seq                        -- 入力順
            ,A.ht_send_date_time                -- HT送信日時
            ,A.order_input_type_id              -- 発注発生区分ＩＤ
            ,A.order_input_type                 -- 発注発生区分
            ,A.home_office_ship_type_id         -- 本部送込区分ＩＤ
            ,A.home_office_ship_type            -- 本部送込区分
            ,A.item_id                          -- 商品ＩＤ
            ,A.item_cd                          -- 商品ＣＤ
            ,A.item_nm                          -- 商品ＮＭ
            ,A.standard_nm                      -- 規格名
            ,E.excl_tax_cost                    -- 原単価（税抜き）
            ,E.order_qty                        -- 発注単位
            ,A.order_recommendation_input_qty   -- 発注数
            ,A.order_date                       -- 発注日
            ,A.bu_gp_store_id                   -- 店舗ＩＤ
            ,A.store_cd                         -- 店舗ＣＤ
            ,A.store_nm                         -- 店舗ＮＭ
            ,A.order_cntl_type_id               -- 発注対象区分ＩＤ
            ,A.dealing_off_type_id              -- 商品取扱停止区分ＩＤ
            ,E.order_start_date AS order_start_date_item   -- 発注開始日（商品）
            ,E.order_stop_date AS order_stop_date_item     -- 発注終了日（商品）
            ,A.close_date                       -- 閉店日
            ,A.order_start_date                 -- 発注開始日（店舗）
            ,A.order_stop_date                  -- 発注終了日（店舗）
            ,A.error_msg                        -- エラーメッセージ
        FROM aodw_order_work_table1   AS A
        LEFT JOIN amsm_item_cntl_order AS E
--        ON  E.item_id            = A.item_id
        ON  A.item_id            = E.item_id
        AND E.bu_gp_order_gp_id  = A.bu_gp_store_id
        AND E.approva_flag       = wUsFlagOn
        AND E.app_end_date      >= A.order_date
        ;
     
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '2. INSERT aodw_order_work_table2: %件', vRowCnt ;


        --********************************************************
        -- ３．商品販売制御情報を取得
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table3;
        CREATE TABLE aodw_order_work_table3 AS 
        SELECT
             A.bf_job_id                        -- ジョブ識別ＩＤ
            ,A.input_seq                        -- 入力順
            ,A.ht_send_date_time                -- HT送信日時
            ,A.order_input_type_id              -- 発注発生区分ＩＤ
            ,A.order_input_type                 -- 発注発生区分
            ,A.home_office_ship_type_id         -- 本部送込区分ＩＤ
            ,A.home_office_ship_type            -- 本部送込区分
            ,A.item_id                          -- 商品ＩＤ
            ,A.item_cd                          -- 商品ＣＤ
            ,A.item_nm                          -- 商品ＮＭ
            ,A.standard_nm                      -- 規格名
            ,A.excl_tax_cost                    -- 原単価（税抜き）
            ,A.order_qty                        -- 発注単位
            ,A.order_recommendation_input_qty   -- 発注数
            ,A.order_date                       -- 発注日
            ,CASE                               -- 最終納品先納品予定日 -- ★リードタイムはテナントパラメータを使用するように修正
                -- 日曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '1' THEN
                    A.order_date + CAST(PAR_LT_Net_Sun || ' days' AS INTERVAL)
                -- 月曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '2' THEN
                    A.order_date + CAST(PAR_LT_Net_Mon || ' days' AS INTERVAL)
                -- 火曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '3' THEN
                    A.order_date + CAST(PAR_LT_Net_Tue || ' days' AS INTERVAL)
                -- 水曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '4' THEN
                    A.order_date + CAST(PAR_LT_Net_Wed || ' days' AS INTERVAL)
                -- 木曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '5' THEN
                    A.order_date + CAST(PAR_LT_Net_Thu || ' days' AS INTERVAL)
                -- 金曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '6' THEN
                    A.order_date + CAST(PAR_LT_Net_Fri || ' days' AS INTERVAL)
                -- 土曜日の場合
                WHEN TO_CHAR(A.order_date, 'D') = '7' THEN
                    A.order_date + CAST(PAR_LT_Net_Sat || ' days' AS INTERVAL)
                ELSE
                    wUsLastDlvyReserveDate
             END AS last_dlvy_reserve_date
            ,A.bu_gp_store_id                       -- 店舗ＩＤ
            ,A.store_cd                             -- 店舗ＣＤ
            ,A.store_nm                             -- 店舗ＮＭ
            ,A.order_cntl_type_id                   -- 発注対象区分ＩＤ
            ,A.dealing_off_type_id                  -- 商品取扱停止区分ＩＤ
            ,A.order_start_date_item                -- 発注開始日（商品）
            ,A.order_stop_date_item                 -- 発注終了日（商品）
            ,A.close_date                           -- 閉店日
            ,A.order_start_date                     -- 発注開始日（店舗）
            ,A.order_stop_date                      -- 発注停止日（店舗）
            ,B.standard_excl_tax_r_price            -- 売価
            ,B.sales_period_start_date              -- 販売開始日（業態）
            ,B.sales_period_end_date                -- 販売終了日（業態）
            ,A.error_msg                        -- エラーメッセージ
        FROM aodw_order_work_table2 AS A
        LEFT JOIN amsm_item_cntl_sales AS B
--        ON  B.item_id               = A.item_id
        ON  A.item_id               = B.item_id
        AND B.bu_gp_sales_gp_id     = A.bu_gp_store_id
        AND B.app_start_date       <= A.order_date
        AND B.app_end_date         >= A.order_date
        ;
        
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '3. INSERT aodw_order_work_table3: %件',vRowCnt ;


        --********************************************************
        -- ４．ジョブ発注受付チェック用データ（Output）を作成
        --********************************************************

        INSERT INTO aodw_order_check_job_output(           -- ジョブ発注受付チェック用データ（Output）
             bf_job_id                                              -- ジョブ識別ＩＤ
            ,input_seq                                              -- 入力順
            ,order_input_type_id                                    -- 発注発生区分ＩＤ
            ,order_input_type                                       -- 発注発生区分
            ,home_office_ship_type_id                               -- 本部送込区分ＩＤ
            ,home_office_ship_type                                  -- 本部送込区分
            ,item_id                                                -- 商品ＩＤ
            ,item_cd                                                -- 商品コード
            ,item_nm                                                -- 商品名称
            ,standard_nm                                            -- 規格名称
            ,base_cost_unit_price                                   -- 原単価
            ,cost_amt                                               -- 原価金額
            ,r_price                                                -- 売単価
            ,retail_amt                                             -- 売価金額
            ,bu_gp_store_id                                         -- 組織ユニットＩＤ（店舗）
            ,store_cd                                               -- 店舗コード
            ,store_nm                                               -- 店舗名称
            ,order_plan_qty                                         -- 発注予定数
            ,order_plan_piece_qty                                   -- 発注予定数（バラ）
            ,tot_order_unit_qty                                     -- 発注単位数量合計
            ,order_date                                             -- 発注日
            ,last_dlvy_reserve_date                                 -- 最終納品先納品予定日
            ,error_msg                                              -- エラー内容
            ,ht_send_date_time                                      -- HT送信日時
            ,del_flag                                               -- 削除フラグ
            ,approva_flag                                           -- 承認フラグ
            ,ht_input_order_qty                                     -- ＨＴ入力発注数量
            ,ins_oper_cd                                            -- 登録ユーザーコード
            ,ins_program_cd                                         -- 登録プログラムコード
            ,ins_date_time                                          -- 登録日時
            ,fw_upd_prog_nm                                         -- FW更新プログラム名
            ,fw_upd_user_id                                         -- FW更新ユーザＩＤ
            ,fw_upd_date                                            -- FW更新日時
            ,version                                                -- バージョン
            
             )
            SELECT
             A.bf_job_id                                            -- ジョブ識別ＩＤ
            ,A.input_seq                                            -- 入力順
            ,A.order_input_type_id                                  -- 発注発生区分ＩＤ
            ,A.order_input_type                                     -- 発注発生区分
            ,A.home_office_ship_type_id                             -- 本部送込区分ＩＤ
            ,A.home_office_ship_type                                -- 本部送込区分
            ,A.item_id                                              -- 商品ＩＤ
            ,A.item_cd                                              -- 商品コード
            ,A.item_nm                                              -- 商品名称
            ,A.standard_nm                                          -- 規格名称
            ,A.excl_tax_cost                                        -- 原単価
            ,A.excl_tax_cost * A.order_recommendation_input_qty              -- 原価金額
            ,A.standard_excl_tax_r_price                            -- 売単価
            ,A.standard_excl_tax_r_price * A.order_recommendation_input_qty  -- 売価金額
            ,A.bu_gp_store_id                                       -- 組織ユニットＩＤ（店舗）
            ,A.store_cd                                             -- 店舗コード
            ,A.store_nm                                             -- 店舗名称
            ,A.order_recommendation_input_qty AS order_plan_qty              -- 発注予定数
            ,A.order_recommendation_input_qty AS order_plan_piece_qty        -- 発注予定数（バラ）
            ,A.order_qty                                            -- 発注単位数量合計
            ,A.order_date                                           -- 発注日
            ,A.last_dlvy_reserve_date                               -- 最終納品先納品予定日
            ,CASE                                                   -- エラー内容
                WHEN A.error_msg = '' THEN
                    CASE                                                   
                        -- 1 商品取扱停止区分ＩＤ   「取り扱わない」の場合はエラー
                        WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                            wUsErrorMsg_ABC10001
                        -- 2 発注対象区分ＩＤ       「対象外」の場合はエラー
                        WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                            wUsErrorMsg_ABC10002
                        -- 3 発注開始日がＮＵＬＬの場合はエラー ※店舗の発注開始日チェック
                        WHEN A.order_start_date IS NULL THEN
                            wUsErrorMsg_ABC10003
                        -- 4 発注開始日＞（納品日の決定）処理後の発注日の場合はエラー
                        WHEN A.order_start_date > A.order_date THEN
                            wUsErrorMsg_ABC10004
                        -- 5 発注終了日≠ＮＵＬＬ　かつ　発注終了日＜（納品日の決定）処理後の発注日の場合はエラー ※店舗の発注開始日チェック
                        WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                            wUsErrorMsg_ABC10005
                        -- 6 閉店日≠ＮＵＬＬ　かつ　閉店日＜（納品日の決定）処理後の納品日の場合はエラー
                        WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                            wUsErrorMsg_ABC10006
                        -- RAISE WARNING '16 sales_period_end_date';
                        -- 7 販売終了日≠ＮＵＬＬ かつ 販売終了日＜（発注日納品日の決定）処理後の発注日の場合はエラー
                        WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                            wUsErrorMsg_ABC10001
                        -- RAISE WARNING '23 tot_order_unit_qty';
                        -- 8 発注単位数量合計＝「0（ゼロ）」　または　空の場合はエラー
                        WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                            wUsErrorMsg_ABC10008
                        -- RAISE WARNING '27 order_start_date';
                        -- 9 発注開始日 ＞ (納品日の決定)処理後の発注日の場合はエラー ※商品の発注開始日チェック
                        WHEN A.order_start_date_item > A.order_date THEN
                            wUsErrorMsg_ABC10007
                        -- 10 最終納品先納品日＝ＮＵＬＬの場合、または、発注日と同じ場合はエラー
                        WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                            wUsErrorMsg_ABC10009
                        ELSE
                            ''
                    END
                ELSE
                    A.error_msg
             END AS error_msg
            ,A.ht_send_date_time                                        -- HT送信日時
            ,wUsFlagOff AS del_flag                                 -- 削除フラグ
            ,CASE                                                   -- 承認フラグ
                -- 1 商品取扱停止区分ＩＤ   「取り扱わない」の場合はエラー
                WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                    wUsFlagOff
                -- 2 発注対象区分ＩＤ       「対象外」の場合はエラー
                WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                    wUsFlagOff
                -- 3 発注開始日がＮＵＬＬの場合はエラー ※店舗の発注開始日チェック
                WHEN A.order_start_date IS NULL THEN
                    wUsFlagOff
                -- 4 発注開始日＞（納品日の決定）処理後の発注日の場合はエラー
                WHEN A.order_start_date > A.order_date THEN
                    wUsFlagOff
                -- 5 発注終了日≠ＮＵＬＬ　かつ　発注終了日＜（納品日の決定）処理後の発注日の場合はエラー ※店舗の発注開始日チェック
                WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                    wUsFlagOff
                -- 6 閉店日≠ＮＵＬＬ　かつ　閉店日＜（納品日の決定）処理後の納品日の場合はエラー
                WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                    wUsFlagOff
                -- 7 販売終了日≠ＮＵＬＬ かつ 販売終了日＜（発注日納品日の決定）処理後の発注日の場合はエラー
                WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                    wUsFlagOff
                -- 8 発注単位数量合計＝「0（ゼロ）」　または　空の場合はエラー
                WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                    wUsFlagOff
                -- 9 発注開始日＞発注日の場合はエラー
                WHEN A.order_start_date_item > A.order_date THEN
                    wUsFlagOff
                -- 10 最終納品先納品日＝ＮＵＬＬの場合、または、発注日と同じ場合はエラー
                WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                    wUsFlagOff
                ELSE
                    wUsFlagOn
              END AS approva_flag
            ,A.order_recommendation_input_qty           -- ＨＴ入力発注数量
            ,wCmUserID                                  -- 登録ユーザーコード
            ,wCmAplName                                 -- 登録プログラムコード
            ,now()                                      -- 登録日時
            ,wCmAplName                                 -- FW更新プログラム名
            ,wCmUserID                                  -- FW更新ユーザＩＤ
            ,now()                                      -- FW更新日時
            ,1                                          -- バージョン
        FROM aodw_order_work_table3 AS A
        ;

        GET DIAGNOSTICS vRowCnt = ROW_COUNT;

        RAISE WARNING '4. INSERT aodw_order_check_job_output: %件', vRowCnt ;
        wUsInputCnt     := vRowCnt;
        wUsOutputCnt    := vRowCnt;
    RAISE WARNING 'END FUNCTION aodf_waod999_CheckOrder_net' ;

    -- 不要ワークテーブル削除
    DROP TABLE IF EXISTS aodw_order_work_table1;
    DROP TABLE IF EXISTS aodw_order_work_table2;
    DROP TABLE IF EXISTS aodw_order_work_table3;
    
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS  vSqlState = RETURNED_SQLSTATE, vSqlErrMsg = MESSAGE_TEXT;
        RAISE WARNING 'SQL EXCEPTION % : %', vSqlState, vSqlErrMsg ;
        wUsSqlState := vSqlState;
        wUsRet := 1;
        RETURN;
    
    
END $BODY$ LANGUAGE plpgsql;


