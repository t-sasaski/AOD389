/*
 * ==================================================================
 * File Name ：WAOD389001ItemProcessor.java
 * Outline   ：取得したアイテム（CSV）加工・データチェッククラス
 * ==================================================================
 */

package com.logic;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import org.springframework.batch.item.ItemProcessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.logic.common.CommonClass;
import com.logic.dto.AOD389AodwNetOrderDataDto;
import com.logic.dto.FAODI3891;


public class WAOD389001ItemProcessor implements ItemProcessor<FAODI3891, AOD389AodwNetOrderDataDto> {

	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private CommonClass commonClass;
	
	@Override
	public AOD389AodwNetOrderDataDto process(final FAODI3891 fAODI3891) throws Exception {
		
		String tranDate = fAODI3891.getTranDate();
		String tranTime = fAODI3891.getTranTime();
		String tranSerialNum = fAODI3891.getTranSerialNum();		
		String storeCdOrder = fAODI3891.getStoreCdOrder();
		String itemCd = fAODI3891.getItemCd();
		int itemNum = fAODI3891.getItemNum();
		
		String message = "";
		boolean  messageFlag = false;
		
		// 業務日付取得		
		Date workDate = (Date) commonClass.getWorkDate(2, "Date");
		
		// 取引日付チェック
		if (!messageFlag) {
			try {
				DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
				df.setLenient(false);
				df.format(df.parse(tranDate));
			} catch (ParseException p) {
				// 有効な日付出ない場合はエラーメッセージを設定
				message = messageSource.getMessage("ABC00001", null, Locale.JAPAN);
				messageFlag = true;
			}
		}
		if (tranDate.length() > 10) {
			// 10桁より大きい場合はエラーになるため初期化
			tranDate = "";
		}
		
		
		// 取引時刻チェック
		if (!messageFlag && tranTime.length() != 8) {
			// 8桁以外の場合はエラーメッセージを設定
			message = messageSource.getMessage("ABC00002", null, Locale.JAPAN);
			messageFlag = true;
		}
		if (tranTime.length() > 8) {
			// 8桁より大きい場合はエラーになるため初期化
			tranTime = "";
		}
		
		
		// 取引時刻チェック 
		if (!messageFlag) {
			try {
				Integer.parseInt(tranSerialNum); 
			} catch (NumberFormatException e){
				// 型がNUMERICではない場合はエラーメッセージを設定
				message = messageSource.getMessage("ABC00003", null, Locale.JAPAN);
				messageFlag = true;
			}
		}
		if (!messageFlag && tranSerialNum.length() != 8) {
			// 8桁以外の場合はエラーメッセージを設定
			message = messageSource.getMessage("ABC00003", null, Locale.JAPAN);
			messageFlag = true;
		}
		
		
		// 店舗コード存在チェック
		String storeSql = "SELECT bu_gp_id FROM amsm_bu_grp"
				+ " WHERE bu_gp_cd ='" + storeCdOrder + "'"
				+ " AND app_start_date <= '" + workDate + "'"
				+ " AND app_end_date >= '" + workDate + "'"
				+ " AND del_flag = '0'"        // 区分：FLAG_OFF
				+ " AND approva_flag = '1'"    // 区分：FLAG_ON
				+ " AND bu_gp_type_id = '04'"  // 区分：組織ユニット区分（04：BU）
				+ ";";
		
		int storeIdResult = 0;
		try {
			storeIdResult = jdbcTemplate.queryForObject(storeSql,Integer.class);
		} catch (EmptyResultDataAccessException e) {
			storeIdResult = 0;
		}
		
		if (!messageFlag && storeIdResult == 0) {
			// 組織ユニットマスタに存在しない場合はエラーメッセージを設定
			message = messageSource.getMessage("ABC00004", null, Locale.JAPAN);
			messageFlag = true;
		}
		
		// 商品コード存在チェック
		String itemSql = "SELECT item_id  FROM amsm_item"
				+ " WHERE item_cd = '" + itemCd + "'"
				+ " AND app_start_date <= '" + workDate + "'"
				+ " AND app_end_date >= '" + workDate + "'"
				+ " AND del_flag = 0"        // 区分：FLAG_OFF
				+ " AND approva_flag = 1"    // 区分：FLAG_ON
				+ " ;";

		int itemIdResult = 0;
		try {
			itemIdResult = jdbcTemplate.queryForObject(itemSql,Integer.class);
		} catch (EmptyResultDataAccessException e) {
			itemIdResult = 0;
		}

//		int itemIdResultInt = itemIdResult.intValue();
		
		if (!messageFlag && itemIdResult == 0) {
			// 商品マスタに存在しない場合はエラーメッセージを設定
			message = messageSource.getMessage("ABC00005", null, Locale.JAPAN);
			messageFlag = true;
		}
		
		// 注文数量チェック
		if (!messageFlag && String.valueOf(itemNum).length() >= 5) {
			// 5桁以上の場合はエラーメッセージを設定
			message = messageSource.getMessage("ABC00006", null, Locale.JAPAN);
			messageFlag = true;
		}
		if (String.valueOf(itemNum).length() > 7) {
			// 7桁より大きい場合はエラーになるため初期化
			itemNum = '0';
		}
		
		
		final AOD389AodwNetOrderDataDto transformColumns = new AOD389AodwNetOrderDataDto(tranDate, tranTime,
				tranSerialNum, storeIdResult, storeCdOrder, 
				itemIdResult, itemCd, itemNum, message);
		
		return transformColumns;
	}

}