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




