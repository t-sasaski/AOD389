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


