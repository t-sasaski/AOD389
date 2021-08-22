/*
 * ==================================================================
 * File Name ：FAODI3891.java
 * Outline   ：ネット注文データ（FAODI3891）のカラム情報
 * ==================================================================
 */

package com.logic.dto;

import lombok.Data;

@Data
public class FAODI3891 {
	
	/* 店舗コード（会計） */
	private String storeCdAc;
	
	/* 取引日付 */
	private String tranDate;
	
	/* 取引時刻 */
	private String tranTime;
	
	/* 取引一連NO */
	private String tranSerialNum;
	
	/* 営業日 */
	private String bizDay;
	
	/* 店舗コード（注文受取） */
	private String storeCdOrder;
	
	/* 処理区分 */
	private int operateType;
	
	/* 商品コード */
	private String itemCd;
	
	/* 商品名称 */
	private String itemNm;
	
	/* 注文商品フラグ */
	private int itemFlag;
	
	/* 注文数量 */
	private int itemNum;
	
	/* 会員No．*/
	private String memberNo;
	
	/* 予備 */
	private String posFreeItem;
	
	public FAODI3891(){
	} //このコンストラクターがないとエラーになる
	
	
	public FAODI3891(String storeCdAc, String tranDate,
			String tranTime, String tranSerialNum, String bizDay,
			String storeCdOrder, int operateType, String itemCd,
			String itemNm, int itemFlag, int itemNum,
			String memberNo, String posFreeItem
			
			) {
		this.storeCdAc = storeCdAc;
		this.tranDate = tranDate;
		this.tranTime = tranTime;
		this.tranSerialNum = tranSerialNum;
		this.bizDay = bizDay;
		this.storeCdOrder = storeCdOrder;
		this.operateType = operateType;
		this.itemCd = itemCd;
		this.itemNm = itemNm;
		this.itemFlag = itemFlag;
		this.itemNum = itemNum;
		this.memberNo = memberNo;
		this.posFreeItem = posFreeItem;
	}


}