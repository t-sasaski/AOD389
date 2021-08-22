/*
 * ==================================================================
 * File Name ：CommonClass.java
 * Outline   ：共通で使用するメソッドを定義したクラス
 * ==================================================================
 */

package com.logic.common;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class CommonClass {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	/*
	 * テーブル削除
	 * @param table テーブル名
	 */
	public void truncateTable(String table) {
		
			String truncateSql = "truncate table " + table + ";";
			jdbcTemplate.execute(truncateSql);
		
	}
	
	/* 業務日付取得
	 * @param busTypeId 業務区分ＩＤ
	 * @param model 型（Date or String）
	 */
	
	public Object getWorkDate(int busTypeId, String model) {
		
		String workDateSql = "select bus_date from amsc_biz_date where bus_type_id = " + busTypeId + ";";
		Date workDate = jdbcTemplate.queryForObject(workDateSql,Date.class);
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		final String workDateStr = dateFormat.format(workDate);	
		
		// 第２引数で戻り値の型を指定
		if (model.equals("Date")) {
			//第２引数に"Date"を指定した場合 Date型の業務日付を返す
			return workDate;
		} else {
			// 第２引数に"String"を指定した場合 String型の業務日付を返す（YYYYMMDD）
			return workDateStr;
		}	
	}
	
	/*
	 * 区分取得
	 * @param typeTypeCd 区分タイプコード
	 * @param typaId 区分ＩＤ
	 * @param cultureTypeId カルチャー区分ＩＤ
	 * 
	 */
	public HashMap<String, Object> getType(String typeTypeCd, int typeId, int cultureTypeId) {
		
		String typeCodeSql = "select type_cd from amsm_type "
				+ " where type_type_cd = '" + typeTypeCd + "' "
				+ " and type_id = '" + typeId + "' "
				+ " and culture_type_id = '" + cultureTypeId + "';";
		String resultTypeCd = (String)jdbcTemplate.queryForObject(typeCodeSql,String.class);
		// ★取得できなかった場合の例外処理を考える
		
		HashMap<String, Object> hm = new HashMap<String, Object>();
		
		hm.put("id", typeId);
		hm.put("code", resultTypeCd);
		
		return hm;
	}
}