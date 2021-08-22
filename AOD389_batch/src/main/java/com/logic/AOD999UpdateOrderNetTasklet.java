/*
 * ==================================================================
 * File Name ：AOD999UpdateOrderNetTasklet.java
 * Outline   ：発注受付データ登録・更新処理
 * ==================================================================
 */

package com.logic;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import com.logic.common.CommonClass;
import com.logic.repository.AOD999UpdateOrderNetMapper;

@Component
public class AOD999UpdateOrderNetTasklet implements Tasklet {
	
	@Autowired
	private AOD999UpdateOrderNetMapper aOD999UpdateOrderNetMapper;
	
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
		
		/* ジョブ識別ＩＤ */
		final String jobId = "jobid_AOD389";
		
		/*   0113:発注発生区分 / 4:ネット注文 の区分ID */
		final HashMap<String, Object> ordInTypeHashmap = commonClass.getType("0113", 4, 1);
		final int orderInputType4Int = (int) ordInTypeHashmap.get("id");
		final BigDecimal orderInputType4 = new BigDecimal(orderInputType4Int);

		
		Map parameters = new HashMap();
		
		// ストアドファンクションのINパラメータをセット
		parameters.put("IN_FLAG_OFF",flagOff);
		parameters.put("IN_FLAG_ON",flagOn);
		parameters.put("IN_BF_JOB_ID", jobId);
		parameters.put("IN_ORDER_INPUT_TYPE_4", orderInputType4);
		
		// ストアドファンクションを実行
		aOD999UpdateOrderNetMapper.aodf_waod999_UpdateOrder_net(parameters);

		BigDecimal inputCnt = (BigDecimal)parameters.get("OUT_INPUT_CNT");
		BigDecimal aodtOrderDataInsCnt = (BigDecimal)parameters.get("OUT_AODT_ORDER_DATA_INS_CNT");
		BigDecimal aodtNetOrderUpdCnt = (BigDecimal)parameters.get("OUT_AODT_NET_ORDER_UPD_CNT");
		BigDecimal ret = (BigDecimal)parameters.get("OUT_RET");
		String sqlState = (String)parameters.get("OUT_SQL_STATE");
				
		// ★sqlstateで正常終了か、異常終了かを判断
		
		return RepeatStatus.FINISHED;
	}
	
}