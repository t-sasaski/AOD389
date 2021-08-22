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



