--ÉlÉbÉgíçï∂éÊà¯î‘çÜä«óù
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


