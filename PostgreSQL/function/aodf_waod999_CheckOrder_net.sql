--***********************************************************
--*  TvFWu­σt`FbNpf[^iOutputjμ¬
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod999_CheckOrder_net(
    IN wUsFlagOff                       numeric, --tOnee
    IN wUsFlagOn                        numeric, --tOnm

    IN wUsErrorMsg_ABC10001             varchar,
    IN wUsErrorMsg_ABC10002             varchar,
    IN wUsErrorMsg_ABC10003             varchar,
    IN wUsErrorMsg_ABC10004             varchar,
    IN wUsErrorMsg_ABC10005             varchar,
    IN wUsErrorMsg_ABC10006             varchar,
    IN wUsErrorMsg_ABC10007             varchar,
    IN wUsErrorMsg_ABC10008             varchar,
    IN wUsErrorMsg_ABC10009             varchar,
    
    IN wUsItemValidTypeStop             numeric, --€iζ΅β~ζͺQζ΅β~
    IN wUsOrderTargetTypeOff            numeric, --­ΞΫζͺQΞΫO

    OUT wUsInputCnt                     numeric, --όΝ
    OUT wUsOutputCnt                    numeric, --oΝ
    OUT wUsRet                          numeric, --Φίθl
    OUT wUsSqlState                     varchar  --SRQG[R[h

) AS $BODY$

  DECLARE
  
    /* Οθ` */
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
        
        --ϊjϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Sun
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sun'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --jϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Mon
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Mon'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --ΞjϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Tue
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Tue'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --jϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Wed
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Wed'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --ΨjϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Thu
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Thu'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --ΰjϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Fri
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Fri'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --yjϊΜ[i[h^CπζΎ
        SELECT value
            INTO PAR_LT_Net_Sat
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sat'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;


        --********************************************************
        -- PDWu­f[^iInputjπ³Ι
        --     €iAgDjbg}X^ξρπζΎ
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table1;
        CREATE TABLE aodw_order_work_table1 AS
        SELECT
             A.bf_job_id                        -- Wu―Κhc
            ,A.input_seq                        -- όΝ
            ,A.ht_send_date_time                -- HTMϊ
            ,A.order_input_type_id              -- ­­Άζͺhc
            ,A.order_input_type                 -- ­­Άζͺ
            ,A.home_office_ship_type_id         -- {ζͺhc
            ,A.home_office_ship_type            -- {ζͺ
            ,B.item_id                          -- €ihc
            ,B.item_cd                          -- €ibc
            ,B.item_nm                          -- €iml
            ,B.standard_nm                      -- KiΌ
            ,A.order_plan_qty AS order_recommendation_input_qty -- ­
            ,A.order_date                       -- ­ϊ
            ,B.order_cntl_type_id               -- ­ΞΫζͺhc
            ,B.dealing_off_type_id              -- €iζ΅β~ζͺhc
            ,C.bu_gp_id AS bu_gp_store_id       -- Xάhc
            ,C.bu_gp_cd AS store_cd             -- Xάbc
            ,C.bu_gp_nm AS store_nm             -- Xάml
            ,C.close_date                       -- ΒXϊ
            ,C.order_start_date                 -- ­Jnϊ
            ,C.order_stop_date                  -- ­IΉϊ
            ,A.error_msg                        -- G[bZ[W
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
        RAISE WARNING '1. INSERT aodw_order_work_table1  : %', vRowCnt ;


        --********************************************************
        -- QD€i­§δ}X^ξρπζΎ
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table2;
        CREATE TABLE aodw_order_work_table2 AS
        SELECT
             A.bf_job_id                        -- Wu―Κhc
            ,A.input_seq                        -- όΝ
            ,A.ht_send_date_time                -- HTMϊ
            ,A.order_input_type_id              -- ­­Άζͺhc
            ,A.order_input_type                 -- ­­Άζͺ
            ,A.home_office_ship_type_id         -- {ζͺhc
            ,A.home_office_ship_type            -- {ζͺ
            ,A.item_id                          -- €ihc
            ,A.item_cd                          -- €ibc
            ,A.item_nm                          -- €iml
            ,A.standard_nm                      -- KiΌ
            ,E.excl_tax_cost                    -- ΄PΏiΕ²«j
            ,E.order_qty                        -- ­PΚ
            ,A.order_recommendation_input_qty   -- ­
            ,A.order_date                       -- ­ϊ
            ,A.bu_gp_store_id                   -- Xάhc
            ,A.store_cd                         -- Xάbc
            ,A.store_nm                         -- Xάml
            ,A.order_cntl_type_id               -- ­ΞΫζͺhc
            ,A.dealing_off_type_id              -- €iζ΅β~ζͺhc
            ,E.order_start_date AS order_start_date_item   -- ­Jnϊi€ij
            ,E.order_stop_date AS order_stop_date_item     -- ­IΉϊi€ij
            ,A.close_date                       -- ΒXϊ
            ,A.order_start_date                 -- ­JnϊiXάj
            ,A.order_stop_date                  -- ­IΉϊiXάj
            ,A.error_msg                        -- G[bZ[W
        FROM aodw_order_work_table1   AS A
        LEFT JOIN amsm_item_cntl_order AS E
--        ON  E.item_id            = A.item_id
        ON  A.item_id            = E.item_id
        AND E.bu_gp_order_gp_id  = A.bu_gp_store_id
        AND E.approva_flag       = wUsFlagOn
        AND E.app_end_date      >= A.order_date
        ;
     
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '2. INSERT aodw_order_work_table2: %', vRowCnt ;


        --********************************************************
        -- RD€iΜ§δξρπζΎ
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table3;
        CREATE TABLE aodw_order_work_table3 AS 
        SELECT
             A.bf_job_id                        -- Wu―Κhc
            ,A.input_seq                        -- όΝ
            ,A.ht_send_date_time                -- HTMϊ
            ,A.order_input_type_id              -- ­­Άζͺhc
            ,A.order_input_type                 -- ­­Άζͺ
            ,A.home_office_ship_type_id         -- {ζͺhc
            ,A.home_office_ship_type            -- {ζͺ
            ,A.item_id                          -- €ihc
            ,A.item_cd                          -- €ibc
            ,A.item_nm                          -- €iml
            ,A.standard_nm                      -- KiΌ
            ,A.excl_tax_cost                    -- ΄PΏiΕ²«j
            ,A.order_qty                        -- ­PΚ
            ,A.order_recommendation_input_qty   -- ­
            ,A.order_date                       -- ­ϊ
            ,CASE                               -- ΕI[iζ[i\θϊ -- [h^CΝeigp[^πgp·ιζ€ΙC³
                -- ϊjϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '1' THEN
                    A.order_date + CAST(PAR_LT_Net_Sun || ' days' AS INTERVAL)
                -- jϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '2' THEN
                    A.order_date + CAST(PAR_LT_Net_Mon || ' days' AS INTERVAL)
                -- ΞjϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '3' THEN
                    A.order_date + CAST(PAR_LT_Net_Tue || ' days' AS INTERVAL)
                -- jϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '4' THEN
                    A.order_date + CAST(PAR_LT_Net_Wed || ' days' AS INTERVAL)
                -- ΨjϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '5' THEN
                    A.order_date + CAST(PAR_LT_Net_Thu || ' days' AS INTERVAL)
                -- ΰjϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '6' THEN
                    A.order_date + CAST(PAR_LT_Net_Fri || ' days' AS INTERVAL)
                -- yjϊΜκ
                WHEN TO_CHAR(A.order_date, 'D') = '7' THEN
                    A.order_date + CAST(PAR_LT_Net_Sat || ' days' AS INTERVAL)
                ELSE
                    wUsLastDlvyReserveDate
             END AS last_dlvy_reserve_date
            ,A.bu_gp_store_id                       -- Xάhc
            ,A.store_cd                             -- Xάbc
            ,A.store_nm                             -- Xάml
            ,A.order_cntl_type_id                   -- ­ΞΫζͺhc
            ,A.dealing_off_type_id                  -- €iζ΅β~ζͺhc
            ,A.order_start_date_item                -- ­Jnϊi€ij
            ,A.order_stop_date_item                 -- ­IΉϊi€ij
            ,A.close_date                           -- ΒXϊ
            ,A.order_start_date                     -- ­JnϊiXάj
            ,A.order_stop_date                      -- ­β~ϊiXάj
            ,B.standard_excl_tax_r_price            -- Ώ
            ,B.sales_period_start_date              -- ΜJnϊiΖΤj
            ,B.sales_period_end_date                -- ΜIΉϊiΖΤj
            ,A.error_msg                        -- G[bZ[W
        FROM aodw_order_work_table2 AS A
        LEFT JOIN amsm_item_cntl_sales AS B
--        ON  B.item_id               = A.item_id
        ON  A.item_id               = B.item_id
        AND B.bu_gp_sales_gp_id     = A.bu_gp_store_id
        AND B.app_start_date       <= A.order_date
        AND B.app_end_date         >= A.order_date
        ;
        
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '3. INSERT aodw_order_work_table3: %',vRowCnt ;


        --********************************************************
        -- SDWu­σt`FbNpf[^iOutputjπμ¬
        --********************************************************

        INSERT INTO aodw_order_check_job_output(           -- Wu­σt`FbNpf[^iOutputj
             bf_job_id                                              -- Wu―Κhc
            ,input_seq                                              -- όΝ
            ,order_input_type_id                                    -- ­­Άζͺhc
            ,order_input_type                                       -- ­­Άζͺ
            ,home_office_ship_type_id                               -- {ζͺhc
            ,home_office_ship_type                                  -- {ζͺ
            ,item_id                                                -- €ihc
            ,item_cd                                                -- €iR[h
            ,item_nm                                                -- €iΌΜ
            ,standard_nm                                            -- KiΌΜ
            ,base_cost_unit_price                                   -- ΄PΏ
            ,cost_amt                                               -- ΄Ώΰz
            ,r_price                                                -- PΏ
            ,retail_amt                                             -- Ώΰz
            ,bu_gp_store_id                                         -- gDjbghciXάj
            ,store_cd                                               -- XάR[h
            ,store_nm                                               -- XάΌΜ
            ,order_plan_qty                                         -- ­\θ
            ,order_plan_piece_qty                                   -- ­\θioj
            ,tot_order_unit_qty                                     -- ­PΚΚv
            ,order_date                                             -- ­ϊ
            ,last_dlvy_reserve_date                                 -- ΕI[iζ[i\θϊ
            ,error_msg                                              -- G[ΰe
            ,ht_send_date_time                                      -- HTMϊ
            ,del_flag                                               -- νtO
            ,approva_flag                                           -- ³FtO
            ,ht_input_order_qty                                     -- gsόΝ­Κ
            ,ins_oper_cd                                            -- o^[U[R[h
            ,ins_program_cd                                         -- o^vOR[h
            ,ins_date_time                                          -- o^ϊ
            ,fw_upd_prog_nm                                         -- FWXVvOΌ
            ,fw_upd_user_id                                         -- FWXV[Uhc
            ,fw_upd_date                                            -- FWXVϊ
            ,version                                                -- o[W
            
             )
            SELECT
             A.bf_job_id                                            -- Wu―Κhc
            ,A.input_seq                                            -- όΝ
            ,A.order_input_type_id                                  -- ­­Άζͺhc
            ,A.order_input_type                                     -- ­­Άζͺ
            ,A.home_office_ship_type_id                             -- {ζͺhc
            ,A.home_office_ship_type                                -- {ζͺ
            ,A.item_id                                              -- €ihc
            ,A.item_cd                                              -- €iR[h
            ,A.item_nm                                              -- €iΌΜ
            ,A.standard_nm                                          -- KiΌΜ
            ,A.excl_tax_cost                                        -- ΄PΏ
            ,A.excl_tax_cost * A.order_recommendation_input_qty              -- ΄Ώΰz
            ,A.standard_excl_tax_r_price                            -- PΏ
            ,A.standard_excl_tax_r_price * A.order_recommendation_input_qty  -- Ώΰz
            ,A.bu_gp_store_id                                       -- gDjbghciXάj
            ,A.store_cd                                             -- XάR[h
            ,A.store_nm                                             -- XάΌΜ
            ,A.order_recommendation_input_qty AS order_plan_qty              -- ­\θ
            ,A.order_recommendation_input_qty AS order_plan_piece_qty        -- ­\θioj
            ,A.order_qty                                            -- ­PΚΚv
            ,A.order_date                                           -- ­ϊ
            ,A.last_dlvy_reserve_date                               -- ΕI[iζ[i\θϊ
            ,CASE                                                   -- G[ΰe
                WHEN A.error_msg = '' THEN
                    CASE                                                   
                        -- 1 €iζ΅β~ζͺhc   uζθ΅νΘ’vΜκΝG[
                        WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                            wUsErrorMsg_ABC10001
                        -- 2 ­ΞΫζͺhc       uΞΫOvΜκΝG[
                        WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                            wUsErrorMsg_ABC10002
                        -- 3 ­JnϊͺmtkkΜκΝG[ ¦XάΜ­Jnϊ`FbN
                        WHEN A.order_start_date IS NULL THEN
                            wUsErrorMsg_ABC10003
                        -- 4 ­Jnϊi[iϊΜθjγΜ­ϊΜκΝG[
                        WHEN A.order_start_date > A.order_date THEN
                            wUsErrorMsg_ABC10004
                        -- 5 ­IΉϊmtkk@©Β@­IΉϊi[iϊΜθjγΜ­ϊΜκΝG[ ¦XάΜ­Jnϊ`FbN
                        WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                            wUsErrorMsg_ABC10005
                        -- 6 ΒXϊmtkk@©Β@ΒXϊi[iϊΜθjγΜ[iϊΜκΝG[
                        WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                            wUsErrorMsg_ABC10006
                        -- RAISE WARNING '16 sales_period_end_date';
                        -- 7 ΜIΉϊmtkk ©Β ΜIΉϊi­ϊ[iϊΜθjγΜ­ϊΜκΝG[
                        WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                            wUsErrorMsg_ABC10001
                        -- RAISE WARNING '23 tot_order_unit_qty';
                        -- 8 ­PΚΚvu0i[jv@ά½Ν@σΜκΝG[
                        WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                            wUsErrorMsg_ABC10008
                        -- RAISE WARNING '27 order_start_date';
                        -- 9 ­Jnϊ  ([iϊΜθ)γΜ­ϊΜκΝG[ ¦€iΜ­Jnϊ`FbN
                        WHEN A.order_start_date_item > A.order_date THEN
                            wUsErrorMsg_ABC10007
                        -- 10 ΕI[iζ[iϊmtkkΜκAά½ΝA­ϊΖ―ΆκΝG[
                        WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                            wUsErrorMsg_ABC10009
                        ELSE
                            ''
                    END
                ELSE
                    A.error_msg
             END AS error_msg
            ,A.ht_send_date_time                                        -- HTMϊ
            ,wUsFlagOff AS del_flag                                 -- νtO
            ,CASE                                                   -- ³FtO
                -- 1 €iζ΅β~ζͺhc   uζθ΅νΘ’vΜκΝG[
                WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                    wUsFlagOff
                -- 2 ­ΞΫζͺhc       uΞΫOvΜκΝG[
                WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                    wUsFlagOff
                -- 3 ­JnϊͺmtkkΜκΝG[ ¦XάΜ­Jnϊ`FbN
                WHEN A.order_start_date IS NULL THEN
                    wUsFlagOff
                -- 4 ­Jnϊi[iϊΜθjγΜ­ϊΜκΝG[
                WHEN A.order_start_date > A.order_date THEN
                    wUsFlagOff
                -- 5 ­IΉϊmtkk@©Β@­IΉϊi[iϊΜθjγΜ­ϊΜκΝG[ ¦XάΜ­Jnϊ`FbN
                WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                    wUsFlagOff
                -- 6 ΒXϊmtkk@©Β@ΒXϊi[iϊΜθjγΜ[iϊΜκΝG[
                WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                    wUsFlagOff
                -- 7 ΜIΉϊmtkk ©Β ΜIΉϊi­ϊ[iϊΜθjγΜ­ϊΜκΝG[
                WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                    wUsFlagOff
                -- 8 ­PΚΚvu0i[jv@ά½Ν@σΜκΝG[
                WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                    wUsFlagOff
                -- 9 ­Jnϊ­ϊΜκΝG[
                WHEN A.order_start_date_item > A.order_date THEN
                    wUsFlagOff
                -- 10 ΕI[iζ[iϊmtkkΜκAά½ΝA­ϊΖ―ΆκΝG[
                WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                    wUsFlagOff
                ELSE
                    wUsFlagOn
              END AS approva_flag
            ,A.order_recommendation_input_qty           -- gsόΝ­Κ
            ,wCmUserID                                  -- o^[U[R[h
            ,wCmAplName                                 -- o^vOR[h
            ,now()                                      -- o^ϊ
            ,wCmAplName                                 -- FWXVvOΌ
            ,wCmUserID                                  -- FWXV[Uhc
            ,now()                                      -- FWXVϊ
            ,1                                          -- o[W
        FROM aodw_order_work_table3 AS A
        ;

        GET DIAGNOSTICS vRowCnt = ROW_COUNT;

        RAISE WARNING '4. INSERT aodw_order_check_job_output: %', vRowCnt ;
        wUsInputCnt     := vRowCnt;
        wUsOutputCnt    := vRowCnt;
    RAISE WARNING 'END FUNCTION aodf_waod999_CheckOrder_net' ;

    -- sv[Ne[uν
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


