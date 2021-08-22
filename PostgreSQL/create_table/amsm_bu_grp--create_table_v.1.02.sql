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


