--シーケンス作成
CREATE SEQUENCE aod_order_tran_seq
    INCREMENT BY 1         --新しいシーケンス値を作成する際の増加量
    MAXVALUE 9999999999999 --シーケンスの最大値
    START WITH 1           --1からスタート
    NO CYCLE               --最大値に達した時、シーケンスを周回させない
;

