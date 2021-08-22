/*
 * ==================================================================
 * File Name ：JobStartEndLIstener.java
 * Outline   ：処理の開始と終了の合図を出力（リスナー）
 * ==================================================================
 */

package com.logic;

import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.listener.JobExecutionListenerSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

public class JobStartEndLIstener extends JobExecutionListenerSupport {

	private final JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JobStartEndLIstener(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	// ステップの開始前に実行
	@Override
	public void beforeJob(JobExecution jobExecution) {
		super.beforeJob(jobExecution);
		System.out.println("開始");
	}	

	// ステップの終了後に実行
	@Override
	public void afterJob(JobExecution jobExecution) {
		super.afterJob(jobExecution);
		System.out.println("終了");
	}

}