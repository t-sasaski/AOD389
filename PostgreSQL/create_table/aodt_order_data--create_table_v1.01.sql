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

