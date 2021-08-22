/*
 * ==================================================================
 * File Name ：WAOD389001ResultTasklet.java
 * Outline   ：WAOD389001の処理結果によって分岐する
 * ==================================================================
 */

package com.logic;

import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class WAOD389001ResultTasklet implements Tasklet {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
		
		// WAOD389001 の処理件数取得
		String countSql = "select count(*) from aodw_net_order_data;";
		
		jdbcTemplate.execute(countSql);
		
		int countResult = jdbcTemplate.queryForObject(countSql,Integer.class);
		
		contribution.setExitStatus(ExitStatus.COMPLETED);
		
//		if (countResult > 0) {
//			// WAOD389001 の処理件数が、0件以外の場合　戻り値にCOMPLETEDを設定
//			contribution.setExitStatus(ExitStatus.COMPLETED);
//		} else {
//			// WAOD389001 の処理件数が、0件の場合　戻り値にFAILEDを設定
//			contribution.setExitStatus(ExitStatus.FAILED);
//		}
		
		return RepeatStatus.FINISHED;
	}


}