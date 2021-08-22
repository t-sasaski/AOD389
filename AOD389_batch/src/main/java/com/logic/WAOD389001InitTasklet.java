/*
 * ==================================================================
 * File Name ：WAOD389001InitTasklet.java
 * Outline   ：ワークテーブル初期化処理
 * ==================================================================
 */

package com.logic;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import com.logic.common.CommonClass;

@Component
public class WAOD389001InitTasklet implements Tasklet {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private CommonClass commonClass;

	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
		
		// ワークテーブルを初期化
		commonClass.truncateTable("aodw_net_order_data");
		commonClass.truncateTable("aodw_order_check_job_input");
		commonClass.truncateTable("aodw_order_check_job_output");
		
		return null;
	}


}