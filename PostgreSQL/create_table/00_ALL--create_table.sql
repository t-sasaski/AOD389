--シーケンス作成
CREATE SEQUENCE aod_order_tran_seq
    INCREMENT BY 1         --新しいシーケンス値を作成する際の増加量
    MAXVALUE 9999999999999 --シーケンスの最大値
    START WITH 1           --1からスタート
    NO CYCLE               --最大値に達した時、シーケンスを周回させない
;


--業務日付マスタ
-- CREATE amsc_biz_date

--DROP TABLE amsc_biz_date CASCADE;

CREATE TABLE amsc_biz_date
(
    bus_type_id             NUMERIC(3,0)            NOT NULL,
    bus_date                TIMESTAMP               NOT NULL,
    fw_upd_prog_nm          CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date             TIMESTAMP               NOT NULL,
    fw_upd_user_id          CHARACTER VARYING(256)  NOT NULL,
    version                 NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsc_biz_date DROP CONSTRAINT amsc_biz_date_pk;
ALTER TABLE amsc_biz_date ADD CONSTRAINT amsc_biz_date_pk PRIMARY KEY (bus_type_id);


--組織ユニットマスタ
-- CREATE amsm_bu_grp

--DROP TABLE amsm_bu_grp CASCADE;

CREATE TABLE amsm_bu_grp
(
    bu_gp_id                            NUMERIC(9,0)            NOT NULL,
    app_start_date                      TIMESTAMP               NOT NULL,
    app_end_date                        TIMESTAMP               NOT NULL,
    bu_gp_cd                            CHARACTER VARYING(20)   NOT NULL,
    bu_gp_nm                            CHARACTER VARYING(40),
    bu_gp_kana                          CHARACTER VARYING(40),
    bu_gp_type_id                       NUMERIC(3,0)            NOT NULL,
    open_date                           TIMESTAMP               NOT NULL,
    close_date                          TIMESTAMP               NOT NULL,
    order_start_date                    TIMESTAMP               NOT NULL,
    order_stop_date                     TIMESTAMP               NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(20)   NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(10)   NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsm_bu_grp DROP CONSTRAINT amsm_bu_grp_pk;
ALTER TABLE amsm_bu_grp ADD CONSTRAINT amsm_bu_grp_pk PRIMARY KEY (bu_gp_id,app_start_date);

--DROP INDEX amsm_bu_grp_i1;
CREATE INDEX amsm_bu_grp_i1 ON amsm_bu_grp (bu_gp_type_id,bu_gp_cd);


--商品マスタ
-- CREATE amsm_item

--DROP TABLE amsm_item CASCADE;

CREATE TABLE amsm_item
(
    item_id                             NUMERIC(9,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    app_start_date                      TIMESTAMP               NOT NULL,
    app_end_date                        TIMESTAMP               NOT NULL,
    item_cd                             CHARACTER VARYING(14)   NOT NULL,
    item_nm                             CHARACTER VARYING(60),
    item_nm_kana                        CHARACTER VARYING(60),
    standard_nm                         CHARACTER VARYING(50),
    standard_nm_kana                    CHARACTER VARYING(50),
    order_cntl_type_id                  NUMERIC(3,0)            NOT NULL,
    dealing_off_type_id                 NUMERIC(3,0)            NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsm_item DROP CONSTRAINT amsm_item_pk;
ALTER TABLE amsm_item ADD CONSTRAINT amsm_item_pk PRIMARY KEY (item_id,approva_flag,app_start_date);

--DROP INDEX amsm_item_i1;
CREATE INDEX amsm_item_i1 ON amsm_item (order_cntl_type_id,item_cd);

--DROP INDEX amsm_item_i2;
CREATE INDEX amsm_item_i2 ON amsm_item (dealing_off_type_id,item_cd);



--商品マスタ
-- CREATE amsm_item_cntl_order

--DROP TABLE amsm_item_cntl_order CASCADE;

CREATE TABLE amsm_item_cntl_order
(
    item_id                             NUMERIC(9,0)            NOT NULL,
    bu_gp_order_gp_id                   NUMERIC(9,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    app_start_date                      TIMESTAMP               NOT NULL,
    app_end_date                        TIMESTAMP               NOT NULL,
    excl_tax_cost                       NUMERIC(18,5)           NOT NULL,
    incl_tax_cost                       NUMERIC(18,5)           NOT NULL,
    order_qty                           NUMERIC(9,2)            NOT NULL,
    order_start_date                    TIMESTAMP               NOT NULL,
    order_stop_date                     TIMESTAMP               NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsm_item_cntl_order DROP CONSTRAINT amsm_item_cntl_order_pk;
ALTER TABLE amsm_item_cntl_order ADD CONSTRAINT amsm_item_cntl_order_pk PRIMARY KEY (item_id, bu_gp_order_gp_id, approva_flag, app_start_date);


--商品販売制御マスタ
-- CREATE amsm_item_cntl_sales

--DROP TABLE amsm_item_cntl_sales CASCADE;

CREATE TABLE amsm_item_cntl_sales
(
    item_id                             NUMERIC(9,0)            NOT NULL,
    bu_gp_sales_gp_id                   NUMERIC(9,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    app_start_date                      TIMESTAMP               NOT NULL,
    app_end_date                        TIMESTAMP               NOT NULL,
    standard_excl_tax_r_price           NUMERIC(18,5)           NOT NULL,
    sales_period_start_date             TIMESTAMP               NOT NULL,
    sales_period_end_date               TIMESTAMP               NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsm_item_cntl_sales DROP CONSTRAINT amsm_item_cntl_sales_pk;
ALTER TABLE amsm_item_cntl_sales ADD CONSTRAINT amsm_item_cntl_sales_pk PRIMARY KEY (item_id, bu_gp_sales_gp_id, approva_flag, app_start_date);




--区分マスタ
-- CREATE amsm_type

--DROP TABLE amsm_type CASCADE;

CREATE TABLE amsm_type
(
    type_type_cd                        CHARACTER VARYING(5)    NOT NULL,
    type_id                             NUMERIC(3,0)            NOT NULL,
    culture_type_id                     NUMERIC(3,0)            NOT NULL,
    type_cd                             CHARACTER VARYING(20)   NOT NULL,
    type_nm                             CHARACTER VARYING(80)   NOT NULL,
    type_outside_cd                     CHARACTER VARYING(20),
    type_outside_nm                     CHARACTER VARYING(80),
    dspl_sequence_number                NUMERIC(4,0)            NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE amsm_type DROP CONSTRAINT amsm_type_pk;
ALTER TABLE amsm_type ADD CONSTRAINT amsm_type_pk PRIMARY KEY (type_type_cd,type_id,culture_type_id);

--DROP INDEX amsm_type_u1;
CREATE INDEX amsm_type_u1 ON amsm_type (type_type_cd,type_cd,culture_type_id);



--ネット注文取引番号管理
-- CREATE aodt_net_order_mng

--DROP TABLE aodt_net_order_mng CASCADE;

CREATE TABLE aodt_net_order_mng
(
    bu_gp_store_id                      NUMERIC(9,0),
    bu_gp_cd                            CHARACTER VARYING(20),
    tran_date                           CHARACTER VARYING(10),
    tran_time                           CHARACTER VARYING(8),
    tran_serial_num                     CHARACTER VARYING(8),
    seq_no                              NUMERIC(6,0),
    order_tran_number                   NUMERIC(13,0),
    slip_number                         NUMERIC(9,0),
    line_number                         NUMERIC(9,0),
    order_date                          TIMESTAMP,
    last_dlvy_reserve_date              TIMESTAMP,
    item_id                             NUMERIC(9,0),
    item_cd                             CHARACTER VARYING(14),
    order_quantity                      NUMERIC(9,2),
    send_flag                           NUMERIC(1,0),
    error_msg                           CHARACTER VARYING(60),
    del_flag                            NUMERIC(1,0),
    approva_flag                        NUMERIC(1,0),
    ins_oper_cd                         CHARACTER VARYING(20),
    ins_program_cd                      CHARACTER VARYING(10),
    ins_date_time                       TIMESTAMP,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256),
    fw_upd_user_id                      CHARACTER VARYING(256),
    fw_upd_date                         TIMESTAMP,
    version                             NUMERIC(10,0)
)
;

--ALTER TABLE aodt_net_order_mng DROP CONSTRAINT aodt_net_order_mng_pk;
ALTER TABLE aodt_net_order_mng ADD CONSTRAINT aodt_net_order_mng_pk PRIMARY KEY (order_tran_number);

--DROP INDEX aodt_net_order_mng_i1;
CREATE INDEX aodt_net_order_mng_i1 ON aodt_net_order_mng (slip_number,line_number);

--DROP INDEX aodt_net_order_mng_i2;
CREATE INDEX aodt_net_order_mng_i2 ON aodt_net_order_mng (bu_gp_store_id,tran_date,tran_serial_num,seq_no);

--DROP INDEX aodt_net_order_mng_i3;
CREATE INDEX aodt_net_order_mng_i3 ON aodt_net_order_mng (item_id);


--発注受付データ
-- CREATE aodt_order_data

--DROP TABLE aodt_order_data CASCADE;

CREATE TABLE aodt_order_data
(
    order_tran_number                   NUMERIC(13,0)           NOT NULL,
    order_input_type_id                 NUMERIC(3,0)            NOT NULL,
    order_input_type                    CHARACTER VARYING(2)    NOT NULL,
    home_office_ship_type_id            NUMERIC(3,0)            NOT NULL,
    home_office_ship_type               CHARACTER VARYING(2)    NOT NULL,
    item_id                             NUMERIC(9,0)            NOT NULL,
    item_cd                             CHARACTER VARYING(14)   NOT NULL,
    item_nm                             CHARACTER VARYING(60),
    standard_nm                         CHARACTER VARYING(50),
    base_cost_unit_price                NUMERIC(18,5)           NOT NULL,
    cost_amt                            NUMERIC(18,5)           NOT NULL,
    r_price                             NUMERIC(18,5)           NOT NULL,
    retail_amt                          NUMERIC(18,5)           NOT NULL,
    bu_gp_store_id                      NUMERIC(9,0)            NOT NULL,
    store_cd                            CHARACTER VARYING(20)   NOT NULL,
    store_nm                            CHARACTER VARYING(40),
    order_plan_qty                      NUMERIC(9,2)            NOT NULL,
    order_plan_piece_qty                NUMERIC(9,2)            NOT NULL,
    tot_order_unit_qty                  NUMERIC(9,2),
    order_date                          TIMESTAMP               NOT NULL,
    last_dlvy_reserve_date              TIMESTAMP,
    error_msg                           CHARACTER VARYING(60),
    ht_send_date_time                   TIMESTAMP,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL,
    ht_input_order_qty                  NUMERIC(9,2),
    destination_cd                      CHARACTER VARYING(8)
)
;

--ALTER TABLE aodt_order_data DROP CONSTRAINT aodt_order_data_pk;
ALTER TABLE aodt_order_data ADD CONSTRAINT aodt_order_data_pk PRIMARY KEY (order_tran_number);

--DROP INDEX aodt_order_data_i1;
CREATE INDEX aodt_order_data_i1 ON aodt_order_data (item_cd,store_cd,order_date,order_input_type);

--DROP INDEX aodt_order_data_i2;
CREATE INDEX aodt_order_data_i2 ON aodt_order_data (bu_gp_store_id,item_id);

--ネット注文データワーク
-- CREATE aodw_net_order_data

--DROP TABLE aodw_net_order_data CASCADE;

CREATE TABLE aodw_net_order_data
(
    tran_date              CHARACTER VARYING(10),
    tran_time              CHARACTER VARYING(8),
    tran_serial_num        CHARACTER VARYING(8),
    bu_gp_store_id         NUMERIC(9,0),
    bu_gp_cd               CHARACTER VARYING(20),
    item_id                NUMERIC(9,0),
    item_cd                CHARACTER VARYING(14),
    order_quantity         NUMERIC(9,2),
    order_tran_number      NUMERIC(13,0) DEFAULT nextval('aod_order_tran_seq') NOT NULL,
    --order_tran_number      NUMERIC(13,0) NOT NULL,
    error_msg              CHARACTER VARYING(60),
    pos_free_item          CHARACTER VARYING(56)
)
;

--ALTER TABLE aodw_net_order_data DROP CONSTRAINT aodw_net_order_data_pk;
ALTER TABLE aodw_net_order_data ADD CONSTRAINT aodw_net_order_data_pk PRIMARY KEY (order_tran_number);


--ジョブ発注受付チェック用データ(Input)
-- CREATE aodw_order_check_job_input

--DROP TABLE aodw_order_check_job_input CASCADE;

CREATE TABLE aodw_order_check_job_input
(
    bf_job_id                           CHARACTER VARYING(70)   NOT NULL,
    input_seq                           NUMERIC(13,0)           NOT NULL,
    order_tran_number                   NUMERIC(13,0),
    order_input_type_id                 NUMERIC(3,0),
    order_input_type                    CHARACTER VARYING(2),
    home_office_ship_type_id            NUMERIC(3,0),
    home_office_ship_type               CHARACTER VARYING(2),
    item_id                             NUMERIC(9,0),
    item_cd                             CHARACTER VARYING(14),
    item_nm                             CHARACTER VARYING(60),
    standard_nm                         CHARACTER VARYING(50),
    base_cost_unit_price                NUMERIC(18,5),
    cost_amt                            NUMERIC(18,5),
    r_price                             NUMERIC(18,5),
    retail_amt                          NUMERIC(18,5),
    bu_gp_store_id                      NUMERIC(9,0),
    store_cd                            CHARACTER VARYING(20),
    store_nm                            CHARACTER VARYING(40),
    order_plan_qty                      NUMERIC(9,2),
    order_plan_piece_qty                NUMERIC(9,2),
    tot_order_unit_qty                  NUMERIC(9,2),
    order_date                          TIMESTAMP,
    last_dlvy_reserve_date              TIMESTAMP,
    error_msg                           CHARACTER VARYING(60),
    ht_send_date_time                   TIMESTAMP,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL,
    ht_input_order_qty                  NUMERIC(9,2),
    destination_cd                      CHARACTER VARYING(8)
)
;

--ALTER TABLE aodw_order_check_job_input DROP CONSTRAINT aodw_order_check_job_input_pk;
ALTER TABLE aodw_order_check_job_input ADD CONSTRAINT aodw_order_check_job_input_pk PRIMARY KEY (bf_job_id,input_seq);

--DROP INDEX aodw_order_check_job_input_i1;
CREATE INDEX aodw_order_check_job_input_i1 ON aodw_order_check_job_input (bf_job_id);

--DROP INDEX aodw_order_check_job_input_i2;
CREATE INDEX aodw_order_check_job_input_i2 ON aodw_order_check_job_input (item_id);


--ジョブ発注受付チェック用データ(Output)
-- CREATE aodw_order_check_job_output

--DROP TABLE aodw_order_check_job_output CASCADE;

CREATE TABLE aodw_order_check_job_output
(
    bf_job_id                           CHARACTER VARYING(70)   NOT NULL,
    input_seq                           NUMERIC(7,0)           NOT NULL,
    order_tran_number                   NUMERIC(13,0),
    order_input_type_id                 NUMERIC(3,0),
    order_input_type                    CHARACTER VARYING(2),
    home_office_ship_type_id            NUMERIC(3,0),
    home_office_ship_type               CHARACTER VARYING(2),
    item_id                             NUMERIC(9,0),
    item_cd                             CHARACTER VARYING(14),
    item_nm                             CHARACTER VARYING(60),
    standard_nm                         CHARACTER VARYING(50),
    base_cost_unit_price                NUMERIC(18,5),
    cost_amt                            NUMERIC(18,5),
    r_price                             NUMERIC(18,5),
    retail_amt                          NUMERIC(18,5),
    bu_gp_store_id                      NUMERIC(9,0),
    store_cd                            CHARACTER VARYING(20),
    store_nm                            CHARACTER VARYING(40),
    order_plan_qty                      NUMERIC(9,2),
    order_plan_piece_qty                NUMERIC(9,2),
    tot_order_unit_qty                  NUMERIC(9,2),
    order_date                          TIMESTAMP,
    last_dlvy_reserve_date              TIMESTAMP,
    error_msg                           CHARACTER VARYING(60),
    ht_send_date_time                   TIMESTAMP,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    upd_oper_cd                         CHARACTER VARYING(20),
    upd_program_cd                      CHARACTER VARYING(10),
    upd_date_time                       TIMESTAMP,
    del_oper_cd                         CHARACTER VARYING(20),
    del_program_cd                      CHARACTER VARYING(10),
    del_date_time                       TIMESTAMP,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL,
    ht_input_order_qty                  NUMERIC(9,2),
    destination_cd                      CHARACTER VARYING(8)
)
;

--ALTER TABLE aodw_order_check_job_output DROP CONSTRAINT aodw_order_check_job_output_pk;
ALTER TABLE aodw_order_check_job_output ADD CONSTRAINT aodw_order_check_job_output_pk PRIMARY KEY (bf_job_id,input_seq);

--DROP INDEX aodw_order_check_job_output_i1;
CREATE INDEX aodw_order_check_job_output_i1 ON aodw_order_check_job_output (bf_job_id);



--テナントパラメータ格納テーブル
-- CREATE tenant_parameter

--DROP TABLE tenant_parameter CASCADE;

CREATE TABLE tenant_parameter
(
    key                                 VARCHAR                 NOT NULL,
    value                               VARCHAR                 NOT NULL,
    del_flag                            NUMERIC(1,0)            NOT NULL,
    approva_flag                        NUMERIC(1,0)            NOT NULL,
    ins_oper_cd                         CHARACTER VARYING(20)   NOT NULL,
    ins_program_cd                      CHARACTER VARYING(10)   NOT NULL,
    ins_date_time                       TIMESTAMP               NOT NULL,
    fw_upd_prog_nm                      CHARACTER VARYING(256)  NOT NULL,
    fw_upd_date                         TIMESTAMP               NOT NULL,
    fw_upd_user_id                      CHARACTER VARYING(256)  NOT NULL,
    version                             NUMERIC(10,0)           NOT NULL
)
;

--ALTER TABLE tenant_parameter DROP CONSTRAINT tenant_parameter_pk;
ALTER TABLE tenant_parameter ADD CONSTRAINT tenant_parameter_pk PRIMARY KEY (key,value);


