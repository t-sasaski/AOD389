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


