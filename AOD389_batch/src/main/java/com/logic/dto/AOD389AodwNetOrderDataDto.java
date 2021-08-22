/*
 * ==================================================================
 * File Name ：AOD389AodwNetOrderDataDto.java
 * Outline   ：ネット注文データワーク（aodw_net_order_data）のカラム定義
 * ==================================================================
 */

package com.logic.dto;

import lombok.Data;

@Data
public class AOD389AodwNetOrderDataDto {
	
	/* 取引日付 */
	private String tranDate;
	
	/* 取引時刻 */
	private String tranTime;
	
	/* 取引一連NO */
	private String tranSerialNum;
	
	/* 組織ユニットＩＤ（店舗） */
	private int buGpStoreId;
	
	/* 組織ユニットコード */
	private String buGpCd;
	
	/* 商品ＩＤ */
	private int itemId;
	
	/* 商品コード */
	private String itemCd;
	
	/* 発注数 */
	private int orderQuantity;
	
	/* 発注トラン番号 */
	// order_tran_numberは、テーブル登録時に連番が設定される
	
	/* エラー内容 */
	private String errorMsg;
	
	public AOD389AodwNetOrderDataDto(){
	} //このコンストラクターがないとエラーになる
	
	
	public AOD389AodwNetOrderDataDto(String tranDate, String tranTime,
			String tranSerialNum, int buGpStoreId, String buGpCd,
			int itemId, String itemCd, int orderQuantity, String errorMsg
			) {
		this.tranDate = tranDate;
		this.tranTime = tranTime;
		this.tranSerialNum = tranSerialNum;
		this.buGpStoreId = buGpStoreId;
		this.buGpCd = buGpCd;
		this.itemId = itemId;
		this.itemCd = itemCd;
		this.orderQuantity = orderQuantity;
		this.errorMsg = errorMsg;
	}


}