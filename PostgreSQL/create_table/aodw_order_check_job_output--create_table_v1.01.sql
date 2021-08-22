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



