--シーケンス削除
DROP SEQUENCE aod_order_tran_seq CASCADE;


--業務日付マスタ
DROP TABLE amsc_biz_date CASCADE;

--組織ユニットマスタ
DROP TABLE amsm_bu_grp CASCADE;

--商品マスタ
DROP TABLE amsm_item CASCADE;

--商品発注制御マスタ
DROP TABLE amsm_item_cntl_order CASCADE;

--商品販売制御マスタ
DROP TABLE amsm_item_cntl_sales CASCADE;

--区分マスタ
DROP TABLE amsm_type CASCADE;

--ネット注文取引番号管理
DROP TABLE aodt_net_order_mng CASCADE;

--発注受付データ
DROP TABLE aodt_order_data CASCADE;

--ネット注文データワーク
DROP TABLE aodw_net_order_data CASCADE;

--ジョブ発注受付チェック用データ(Input)
DROP TABLE aodw_order_check_job_input CASCADE;

--ジョブ発注受付チェック用データ(Output)
DROP TABLE aodw_order_check_job_output CASCADE;

--テナントパラメータ格納テーブル
DROP TABLE tenant_parameter CASCADE;


