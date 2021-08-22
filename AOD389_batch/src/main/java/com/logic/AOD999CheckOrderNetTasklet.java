/*
 * ==================================================================
 * File Name ：AOD999CheckOrderNetTasklet.java
 * Outline   ：ジョブ発注受付チェック用データ（Output）作成
 * ==================================================================
 */

package com.logic;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import com.logic.common.CommonClass;
import com.logic.repository.AOD999CheckOrderNetMapper;

@Component
public class AOD999CheckOrderNetTasklet implements Tasklet {
	
	@Autowired
	private AOD999CheckOrderNetMapper aOD999CheckOrderNetMapper;
	
	@Autowired
	private CommonClass commonClass;
	
	@Autowired
	private MessageSource messageSource;
	
	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
				
		/* フラグＯＦＦ */
		final HashMap<String, Object> flagOffHashmap = commonClass.getType("0000", 0, 1);
		final int flagOffInt = (int) flagOffHashmap.get("id");
		final BigDecimal flagOff = new BigDecimal(flagOffInt);
		
		/* フラグＯＮ */
		final HashMap<String, Object> flagOnHashmap = commonClass.getType("0000", 1, 1);
		final int flagOnInt = (int) flagOnHashmap.get("id");
		final BigDecimal flagOn = new BigDecimal(flagOnInt);
		
		/* メッセージを取得 */
		final String msgABC10001 = messageSource.getMessage("ABC10001", null, Locale.JAPAN);
		final String msgABC10002 = messageSource.getMessage("ABC10002", null, Locale.JAPAN);
		final String msgABC10003 = messageSource.getMessage("ABC10003", null, Locale.JAPAN);
		final String msgABC10004 = messageSource.getMessage("ABC10004", null, Locale.JAPAN);
		final String msgABC10005 = messageSource.getMessage("ABC10005", null, Locale.JAPAN);
		final String msgABC10006 = messageSource.getMessage("ABC10006", null, Locale.JAPAN);
		final String msgABC10007 = messageSource.getMessage("ABC10007", null, Locale.JAPAN);
		final String msgABC10008 = messageSource.getMessage("ABC10008", null, Locale.JAPAN);
		final String msgABC10009 = messageSource.getMessage("ABC10009", null, Locale.JAPAN);
		
		/* 商品取扱停止区分＿取扱停止 */ // ★あとで区分に追加
		final BigDecimal itemValidTypeStop = new BigDecimal(0);
		
		/* 発注対象区分＿対象外 */ // ★あとで区分に追加
		final BigDecimal orderTargetTypeOff = new BigDecimal(0);
		
		Map parameters = new HashMap();
		
		// ストアドファンクションのINパラメータをセット
		parameters.put("IN_FLAG_OFF",flagOff);
		parameters.put("IN_FLAG_ON",flagOn);
		parameters.put("IN_ERROR_MSG_ABC10001", msgABC10001);
		parameters.put("IN_ERROR_MSG_ABC10002", msgABC10002);
		parameters.put("IN_ERROR_MSG_ABC10003", msgABC10003);
		parameters.put("IN_ERROR_MSG_ABC10004", msgABC10004);
		parameters.put("IN_ERROR_MSG_ABC10005", msgABC10005);
		parameters.put("IN_ERROR_MSG_ABC10006", msgABC10006);
		parameters.put("IN_ERROR_MSG_ABC10007", msgABC10007);
		parameters.put("IN_ERROR_MSG_ABC10008", msgABC10008);
		parameters.put("IN_ERROR_MSG_ABC10009", msgABC10009);
		parameters.put("IN_ITEM_VALID_TYPE_STOP", itemValidTypeStop);
		parameters.put("IN_ORDER_TARGET_TYPE_OFF", orderTargetTypeOff);
		
		// ストアドファンクションを実行
		aOD999CheckOrderNetMapper.aodf_waod999_CheckOrder_net(parameters);

		BigDecimal inputCnt = (BigDecimal)parameters.get("OUT_INPUT_CNT");
		BigDecimal outputCnt = (BigDecimal)parameters.get("OUT_OUTPUT_CNT");
		BigDecimal ret = (BigDecimal)parameters.get("OUT_RET");
		String sqlState = (String)parameters.get("OUT_SQL_STATE");
		
		// ★sqlstateで正常終了か、異常終了かを判断
		
		return RepeatStatus.FINISHED;
	}

}