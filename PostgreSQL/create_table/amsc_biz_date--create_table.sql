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


