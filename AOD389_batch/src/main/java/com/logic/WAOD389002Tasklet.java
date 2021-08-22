/*
 * ==================================================================
 * File Name ：WAOD389002Tasklet.java
 * Outline   ：ジョブ発注受付チェック用データ（Input）、
 *             ネット注文取引番号管理作成
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
import org.springframework.stereotype.Component;

import com.logic.common.CommonClass;
import com.logic.repository.WAOD389002Mapper;



@Component
public class WAOD389002Tasklet implements Tasklet {
	
	@Autowired
	private WAOD389002Mapper wAOD389002Mapper;
	
	@Autowired
	private CommonClass commonClass;
	
	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
		
		/* 業務日付 */
		final String workDateStr = (String) commonClass.getWorkDate(2, "String");
		
		/* フラグＯＦＦ */
		final HashMap<String, Object> flagOffHashmap = commonClass.getType("0000", 0, 1);
		final int flagOffInt = (int) flagOffHashmap.get("id");
		final BigDecimal flagOff = new BigDecimal(flagOffInt);
		
		/* フラグＯＮ */
		final HashMap<String, Object> flagOnHashmap = commonClass.getType("0000", 1, 1);
		final int flagOnInt = (int) flagOnHashmap.get("id");
		final BigDecimal flagOn = new BigDecimal(flagOnInt);
		
		/* ジョブ識別ＩＤ */
		final String jobId = "jobid_AOD389"; //★あとで設定の方法考える
		
		
		/*   0113:発注発生区分 / 4:ネット注文 の区分ID */
		final HashMap<String, Object> ordInTypeHashmap = commonClass.getType("0113", 4, 1);
		final int ordInTypeCustOrdIdInt = (int) ordInTypeHashmap.get("id");
		final BigDecimal ordInTypeCustOrdId = new BigDecimal(ordInTypeCustOrdIdInt);
		
		/*  0113:発注発生区分 / 4:ネット注文 の区分コード */
		final String ordInTypeCustOrdCd = (String) ordInTypeHashmap.get("code");
		
		
		/*  0105:発注発生区分 / 2:店舗代行 の区分ID */ 
		final HashMap<String, Object> homeOfficeShipTypHashmap = commonClass.getType("0105", 2, 1);
		final int homeOfficeShipTypShipIdInt = (int) homeOfficeShipTypHashmap.get("id");
		final BigDecimal homeOfficeShipTypShipId = new BigDecimal(homeOfficeShipTypShipIdInt);

		/*  0105:発注発生区分 / 2:店舗代行 の区分コード */ 
		final String homeOfficeShipTypShipCd = (String) homeOfficeShipTypHashmap.get("code");
		
		
		Map parameters = new HashMap();
		
		// ストアドファンクションのINパラメータをセット
		parameters.put("IN_BUS_DATE_TEMP",workDateStr);
		parameters.put("IN_FLAG_OFF",flagOff);
		parameters.put("IN_FLAG_ON",flagOn);
		parameters.put("IN_JOB_ID", jobId);
		parameters.put("IN_ORD_IN_TYPE_CUST_ORD_ID", ordInTypeCustOrdId);
		parameters.put("IN_ORD_IN_TYPE_CUST_ORD_CD", ordInTypeCustOrdCd);
		parameters.put("IN_HOME_OFFICE_SHIP_TYP_SHIP_ID", homeOfficeShipTypShipId);
		parameters.put("IN_HOME_OFFICE_SHIP_TYP_SHIP_CD", homeOfficeShipTypShipCd);
		// ストアドファンクションを実行
		wAOD389002Mapper.aodf_waod389002_mainprocess(parameters);

		BigDecimal inputCnt = (BigDecimal)parameters.get("OUT_INPUT_CNT");
		BigDecimal outputCnt1 = (BigDecimal)parameters.get("OUT_OUTPUT_CNT1");
		BigDecimal outputCnt2 = (BigDecimal)parameters.get("OUT_OUTPUT_CNT2");
		BigDecimal ret = (BigDecimal)parameters.get("OUT_RET");
		String sqlState = (String)parameters.get("OUT_SQL_STATE");
		
//		System.out.print(outParameter);
		
		// ★sqlstateで正常終了か、異常終了かを判断
		
		return RepeatStatus.FINISHED;
	}


}