--***********************************************************
--*  �����T�v�F�W���u������t�`�F�b�N�p�f�[�^�iOutput�j�쐬
--***********************************************************
CREATE OR REPLACE FUNCTION aodf_waod999_CheckOrder_net(
    IN wUsFlagOff                       numeric, --�t���O�n�e�e
    IN wUsFlagOn                        numeric, --�t���O�n�m

    IN wUsErrorMsg_ABC10001             varchar,
    IN wUsErrorMsg_ABC10002             varchar,
    IN wUsErrorMsg_ABC10003             varchar,
    IN wUsErrorMsg_ABC10004             varchar,
    IN wUsErrorMsg_ABC10005             varchar,
    IN wUsErrorMsg_ABC10006             varchar,
    IN wUsErrorMsg_ABC10007             varchar,
    IN wUsErrorMsg_ABC10008             varchar,
    IN wUsErrorMsg_ABC10009             varchar,
    
    IN wUsItemValidTypeStop             numeric, --���i�戵��~�敪�Q�戵��~
    IN wUsOrderTargetTypeOff            numeric, --�����Ώۋ敪�Q�ΏۊO

    OUT wUsInputCnt                     numeric, --���͌���
    OUT wUsOutputCnt                    numeric, --�o�͌���
    OUT wUsRet                          numeric, --�֐��߂�l
    OUT wUsSqlState                     varchar  --SRQ�G���[�R�[�h

) AS $BODY$

  DECLARE
  
    /* �ϐ���` */
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
        
        --���j���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Sun
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sun'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --���j���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Mon
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Mon'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --�Ηj���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Tue
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Tue'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --���j���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Wed
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Wed'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --�ؗj���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Thu
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Thu'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --���j���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Fri
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Fri'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;
        
        --�y�j���̔[�i���[�h�^�C�����擾
        SELECT value
            INTO PAR_LT_Net_Sat
        FROM tenant_parameter 
        WHERE key         = 'PAR_LT_Net_Sat'
        AND  del_flag     = wUsFlagOff
        AND  approva_flag = wUsFlagOn
        ;


        --********************************************************
        -- �P�D�W���u�����f�[�^�iInput�j������
        --     ���i�A�g�D���j�b�g�}�X�^�����擾
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table1;
        CREATE TABLE aodw_order_work_table1 AS
        SELECT
             A.bf_job_id                        -- �W���u���ʂh�c
            ,A.input_seq                        -- ���͏�
            ,A.ht_send_date_time                -- HT���M����
            ,A.order_input_type_id              -- ���������敪�h�c
            ,A.order_input_type                 -- ���������敪
            ,A.home_office_ship_type_id         -- �{�������敪�h�c
            ,A.home_office_ship_type            -- �{�������敪
            ,B.item_id                          -- ���i�h�c
            ,B.item_cd                          -- ���i�b�c
            ,B.item_nm                          -- ���i�m�l
            ,B.standard_nm                      -- �K�i��
            ,A.order_plan_qty AS order_recommendation_input_qty -- ������
            ,A.order_date                       -- ������
            ,B.order_cntl_type_id               -- �����Ώۋ敪�h�c
            ,B.dealing_off_type_id              -- ���i�戵��~�敪�h�c
            ,C.bu_gp_id AS bu_gp_store_id       -- �X�܂h�c
            ,C.bu_gp_cd AS store_cd             -- �X�܂b�c
            ,C.bu_gp_nm AS store_nm             -- �X�܂m�l
            ,C.close_date                       -- �X��
            ,C.order_start_date                 -- �����J�n��
            ,C.order_stop_date                  -- �����I����
            ,A.error_msg                        -- �G���[���b�Z�[�W
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
        RAISE WARNING '1. INSERT aodw_order_work_table1  : %��', vRowCnt ;


        --********************************************************
        -- �Q�D���i��������}�X�^�����擾
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table2;
        CREATE TABLE aodw_order_work_table2 AS
        SELECT
             A.bf_job_id                        -- �W���u���ʂh�c
            ,A.input_seq                        -- ���͏�
            ,A.ht_send_date_time                -- HT���M����
            ,A.order_input_type_id              -- ���������敪�h�c
            ,A.order_input_type                 -- ���������敪
            ,A.home_office_ship_type_id         -- �{�������敪�h�c
            ,A.home_office_ship_type            -- �{�������敪
            ,A.item_id                          -- ���i�h�c
            ,A.item_cd                          -- ���i�b�c
            ,A.item_nm                          -- ���i�m�l
            ,A.standard_nm                      -- �K�i��
            ,E.excl_tax_cost                    -- ���P���i�Ŕ����j
            ,E.order_qty                        -- �����P��
            ,A.order_recommendation_input_qty   -- ������
            ,A.order_date                       -- ������
            ,A.bu_gp_store_id                   -- �X�܂h�c
            ,A.store_cd                         -- �X�܂b�c
            ,A.store_nm                         -- �X�܂m�l
            ,A.order_cntl_type_id               -- �����Ώۋ敪�h�c
            ,A.dealing_off_type_id              -- ���i�戵��~�敪�h�c
            ,E.order_start_date AS order_start_date_item   -- �����J�n���i���i�j
            ,E.order_stop_date AS order_stop_date_item     -- �����I�����i���i�j
            ,A.close_date                       -- �X��
            ,A.order_start_date                 -- �����J�n���i�X�܁j
            ,A.order_stop_date                  -- �����I�����i�X�܁j
            ,A.error_msg                        -- �G���[���b�Z�[�W
        FROM aodw_order_work_table1   AS A
        LEFT JOIN amsm_item_cntl_order AS E
--        ON  E.item_id            = A.item_id
        ON  A.item_id            = E.item_id
        AND E.bu_gp_order_gp_id  = A.bu_gp_store_id
        AND E.approva_flag       = wUsFlagOn
        AND E.app_end_date      >= A.order_date
        ;
     
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '2. INSERT aodw_order_work_table2: %��', vRowCnt ;


        --********************************************************
        -- �R�D���i�̔���������擾
        --********************************************************

        DROP TABLE IF EXISTS aodw_order_work_table3;
        CREATE TABLE aodw_order_work_table3 AS 
        SELECT
             A.bf_job_id                        -- �W���u���ʂh�c
            ,A.input_seq                        -- ���͏�
            ,A.ht_send_date_time                -- HT���M����
            ,A.order_input_type_id              -- ���������敪�h�c
            ,A.order_input_type                 -- ���������敪
            ,A.home_office_ship_type_id         -- �{�������敪�h�c
            ,A.home_office_ship_type            -- �{�������敪
            ,A.item_id                          -- ���i�h�c
            ,A.item_cd                          -- ���i�b�c
            ,A.item_nm                          -- ���i�m�l
            ,A.standard_nm                      -- �K�i��
            ,A.excl_tax_cost                    -- ���P���i�Ŕ����j
            ,A.order_qty                        -- �����P��
            ,A.order_recommendation_input_qty   -- ������
            ,A.order_date                       -- ������
            ,CASE                               -- �ŏI�[�i��[�i�\��� -- �����[�h�^�C���̓e�i���g�p�����[�^���g�p����悤�ɏC��
                -- ���j���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '1' THEN
                    A.order_date + CAST(PAR_LT_Net_Sun || ' days' AS INTERVAL)
                -- ���j���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '2' THEN
                    A.order_date + CAST(PAR_LT_Net_Mon || ' days' AS INTERVAL)
                -- �Ηj���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '3' THEN
                    A.order_date + CAST(PAR_LT_Net_Tue || ' days' AS INTERVAL)
                -- ���j���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '4' THEN
                    A.order_date + CAST(PAR_LT_Net_Wed || ' days' AS INTERVAL)
                -- �ؗj���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '5' THEN
                    A.order_date + CAST(PAR_LT_Net_Thu || ' days' AS INTERVAL)
                -- ���j���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '6' THEN
                    A.order_date + CAST(PAR_LT_Net_Fri || ' days' AS INTERVAL)
                -- �y�j���̏ꍇ
                WHEN TO_CHAR(A.order_date, 'D') = '7' THEN
                    A.order_date + CAST(PAR_LT_Net_Sat || ' days' AS INTERVAL)
                ELSE
                    wUsLastDlvyReserveDate
             END AS last_dlvy_reserve_date
            ,A.bu_gp_store_id                       -- �X�܂h�c
            ,A.store_cd                             -- �X�܂b�c
            ,A.store_nm                             -- �X�܂m�l
            ,A.order_cntl_type_id                   -- �����Ώۋ敪�h�c
            ,A.dealing_off_type_id                  -- ���i�戵��~�敪�h�c
            ,A.order_start_date_item                -- �����J�n���i���i�j
            ,A.order_stop_date_item                 -- �����I�����i���i�j
            ,A.close_date                           -- �X��
            ,A.order_start_date                     -- �����J�n���i�X�܁j
            ,A.order_stop_date                      -- ������~���i�X�܁j
            ,B.standard_excl_tax_r_price            -- ����
            ,B.sales_period_start_date              -- �̔��J�n���i�Ƒԁj
            ,B.sales_period_end_date                -- �̔��I�����i�Ƒԁj
            ,A.error_msg                        -- �G���[���b�Z�[�W
        FROM aodw_order_work_table2 AS A
        LEFT JOIN amsm_item_cntl_sales AS B
--        ON  B.item_id               = A.item_id
        ON  A.item_id               = B.item_id
        AND B.bu_gp_sales_gp_id     = A.bu_gp_store_id
        AND B.app_start_date       <= A.order_date
        AND B.app_end_date         >= A.order_date
        ;
        
        GET DIAGNOSTICS vRowCnt = ROW_COUNT;
        RAISE WARNING '3. INSERT aodw_order_work_table3: %��',vRowCnt ;


        --********************************************************
        -- �S�D�W���u������t�`�F�b�N�p�f�[�^�iOutput�j���쐬
        --********************************************************

        INSERT INTO aodw_order_check_job_output(           -- �W���u������t�`�F�b�N�p�f�[�^�iOutput�j
             bf_job_id                                              -- �W���u���ʂh�c
            ,input_seq                                              -- ���͏�
            ,order_input_type_id                                    -- ���������敪�h�c
            ,order_input_type                                       -- ���������敪
            ,home_office_ship_type_id                               -- �{�������敪�h�c
            ,home_office_ship_type                                  -- �{�������敪
            ,item_id                                                -- ���i�h�c
            ,item_cd                                                -- ���i�R�[�h
            ,item_nm                                                -- ���i����
            ,standard_nm                                            -- �K�i����
            ,base_cost_unit_price                                   -- ���P��
            ,cost_amt                                               -- �������z
            ,r_price                                                -- ���P��
            ,retail_amt                                             -- �������z
            ,bu_gp_store_id                                         -- �g�D���j�b�g�h�c�i�X�܁j
            ,store_cd                                               -- �X�܃R�[�h
            ,store_nm                                               -- �X�ܖ���
            ,order_plan_qty                                         -- �����\�萔
            ,order_plan_piece_qty                                   -- �����\�萔�i�o���j
            ,tot_order_unit_qty                                     -- �����P�ʐ��ʍ��v
            ,order_date                                             -- ������
            ,last_dlvy_reserve_date                                 -- �ŏI�[�i��[�i�\���
            ,error_msg                                              -- �G���[���e
            ,ht_send_date_time                                      -- HT���M����
            ,del_flag                                               -- �폜�t���O
            ,approva_flag                                           -- ���F�t���O
            ,ht_input_order_qty                                     -- �g�s���͔�������
            ,ins_oper_cd                                            -- �o�^���[�U�[�R�[�h
            ,ins_program_cd                                         -- �o�^�v���O�����R�[�h
            ,ins_date_time                                          -- �o�^����
            ,fw_upd_prog_nm                                         -- FW�X�V�v���O������
            ,fw_upd_user_id                                         -- FW�X�V���[�U�h�c
            ,fw_upd_date                                            -- FW�X�V����
            ,version                                                -- �o�[�W����
            
             )
            SELECT
             A.bf_job_id                                            -- �W���u���ʂh�c
            ,A.input_seq                                            -- ���͏�
            ,A.order_input_type_id                                  -- ���������敪�h�c
            ,A.order_input_type                                     -- ���������敪
            ,A.home_office_ship_type_id                             -- �{�������敪�h�c
            ,A.home_office_ship_type                                -- �{�������敪
            ,A.item_id                                              -- ���i�h�c
            ,A.item_cd                                              -- ���i�R�[�h
            ,A.item_nm                                              -- ���i����
            ,A.standard_nm                                          -- �K�i����
            ,A.excl_tax_cost                                        -- ���P��
            ,A.excl_tax_cost * A.order_recommendation_input_qty              -- �������z
            ,A.standard_excl_tax_r_price                            -- ���P��
            ,A.standard_excl_tax_r_price * A.order_recommendation_input_qty  -- �������z
            ,A.bu_gp_store_id                                       -- �g�D���j�b�g�h�c�i�X�܁j
            ,A.store_cd                                             -- �X�܃R�[�h
            ,A.store_nm                                             -- �X�ܖ���
            ,A.order_recommendation_input_qty AS order_plan_qty              -- �����\�萔
            ,A.order_recommendation_input_qty AS order_plan_piece_qty        -- �����\�萔�i�o���j
            ,A.order_qty                                            -- �����P�ʐ��ʍ��v
            ,A.order_date                                           -- ������
            ,A.last_dlvy_reserve_date                               -- �ŏI�[�i��[�i�\���
            ,CASE                                                   -- �G���[���e
                WHEN A.error_msg = '' THEN
                    CASE                                                   
                        -- 1 ���i�戵��~�敪�h�c   �u��舵��Ȃ��v�̏ꍇ�̓G���[
                        WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                            wUsErrorMsg_ABC10001
                        -- 2 �����Ώۋ敪�h�c       �u�ΏۊO�v�̏ꍇ�̓G���[
                        WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                            wUsErrorMsg_ABC10002
                        -- 3 �����J�n�����m�t�k�k�̏ꍇ�̓G���[ ���X�܂̔����J�n���`�F�b�N
                        WHEN A.order_start_date IS NULL THEN
                            wUsErrorMsg_ABC10003
                        -- 4 �����J�n�����i�[�i���̌���j������̔������̏ꍇ�̓G���[
                        WHEN A.order_start_date > A.order_date THEN
                            wUsErrorMsg_ABC10004
                        -- 5 �����I�������m�t�k�k�@���@�����I�������i�[�i���̌���j������̔������̏ꍇ�̓G���[ ���X�܂̔����J�n���`�F�b�N
                        WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                            wUsErrorMsg_ABC10005
                        -- 6 �X�����m�t�k�k�@���@�X�����i�[�i���̌���j������̔[�i���̏ꍇ�̓G���[
                        WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                            wUsErrorMsg_ABC10006
                        -- RAISE WARNING '16 sales_period_end_date';
                        -- 7 �̔��I�������m�t�k�k ���� �̔��I�������i�������[�i���̌���j������̔������̏ꍇ�̓G���[
                        WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                            wUsErrorMsg_ABC10001
                        -- RAISE WARNING '23 tot_order_unit_qty';
                        -- 8 �����P�ʐ��ʍ��v���u0�i�[���j�v�@�܂��́@��̏ꍇ�̓G���[
                        WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                            wUsErrorMsg_ABC10008
                        -- RAISE WARNING '27 order_start_date';
                        -- 9 �����J�n�� �� (�[�i���̌���)������̔������̏ꍇ�̓G���[ �����i�̔����J�n���`�F�b�N
                        WHEN A.order_start_date_item > A.order_date THEN
                            wUsErrorMsg_ABC10007
                        -- 10 �ŏI�[�i��[�i�����m�t�k�k�̏ꍇ�A�܂��́A�������Ɠ����ꍇ�̓G���[
                        WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                            wUsErrorMsg_ABC10009
                        ELSE
                            ''
                    END
                ELSE
                    A.error_msg
             END AS error_msg
            ,A.ht_send_date_time                                        -- HT���M����
            ,wUsFlagOff AS del_flag                                 -- �폜�t���O
            ,CASE                                                   -- ���F�t���O
                -- 1 ���i�戵��~�敪�h�c   �u��舵��Ȃ��v�̏ꍇ�̓G���[
                WHEN A.dealing_off_type_id = wUsItemValidTypeStop THEN
                    wUsFlagOff
                -- 2 �����Ώۋ敪�h�c       �u�ΏۊO�v�̏ꍇ�̓G���[
                WHEN A.order_cntl_type_id = wUsOrderTargetTypeOff THEN
                    wUsFlagOff
                -- 3 �����J�n�����m�t�k�k�̏ꍇ�̓G���[ ���X�܂̔����J�n���`�F�b�N
                WHEN A.order_start_date IS NULL THEN
                    wUsFlagOff
                -- 4 �����J�n�����i�[�i���̌���j������̔������̏ꍇ�̓G���[
                WHEN A.order_start_date > A.order_date THEN
                    wUsFlagOff
                -- 5 �����I�������m�t�k�k�@���@�����I�������i�[�i���̌���j������̔������̏ꍇ�̓G���[ ���X�܂̔����J�n���`�F�b�N
                WHEN A.order_stop_date IS NOT NULL AND A.order_stop_date < A.order_date THEN
                    wUsFlagOff
                -- 6 �X�����m�t�k�k�@���@�X�����i�[�i���̌���j������̔[�i���̏ꍇ�̓G���[
                WHEN A.close_date IS NOT NULL AND A.close_date < A.last_dlvy_reserve_date THEN
                    wUsFlagOff
                -- 7 �̔��I�������m�t�k�k ���� �̔��I�������i�������[�i���̌���j������̔������̏ꍇ�̓G���[
                WHEN A.sales_period_end_date IS NOT NULL AND A.sales_period_end_date < A.order_date THEN
                    wUsFlagOff
                -- 8 �����P�ʐ��ʍ��v���u0�i�[���j�v�@�܂��́@��̏ꍇ�̓G���[
                WHEN A.order_qty = 0 OR A.order_qty IS NULL THEN
                    wUsFlagOff
                -- 9 �����J�n�����������̏ꍇ�̓G���[
                WHEN A.order_start_date_item > A.order_date THEN
                    wUsFlagOff
                -- 10 �ŏI�[�i��[�i�����m�t�k�k�̏ꍇ�A�܂��́A�������Ɠ����ꍇ�̓G���[
                WHEN A.last_dlvy_reserve_date IS NULL OR (A.last_dlvy_reserve_date = A.order_date) THEN
                    wUsFlagOff
                ELSE
                    wUsFlagOn
              END AS approva_flag
            ,A.order_recommendation_input_qty           -- �g�s���͔�������
            ,wCmUserID                                  -- �o�^���[�U�[�R�[�h
            ,wCmAplName                                 -- �o�^�v���O�����R�[�h
            ,now()                                      -- �o�^����
            ,wCmAplName                                 -- FW�X�V�v���O������
            ,wCmUserID                                  -- FW�X�V���[�U�h�c
            ,now()                                      -- FW�X�V����
            ,1                                          -- �o�[�W����
        FROM aodw_order_work_table3 AS A
        ;

        GET DIAGNOSTICS vRowCnt = ROW_COUNT;

        RAISE WARNING '4. INSERT aodw_order_check_job_output: %��', vRowCnt ;
        wUsInputCnt     := vRowCnt;
        wUsOutputCnt    := vRowCnt;
    RAISE WARNING 'END FUNCTION aodf_waod999_CheckOrder_net' ;

    -- �s�v���[�N�e�[�u���폜
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


