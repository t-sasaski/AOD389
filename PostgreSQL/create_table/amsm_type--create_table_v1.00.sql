--‹æ•ªƒ}ƒXƒ^
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



