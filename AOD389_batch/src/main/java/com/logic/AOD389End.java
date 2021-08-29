/*
 * ==================================================================
 * File Name ：WAOD389001ResultTasklet.java
 * Outline   ：WAOD389001の処理結果によって分岐する
 * ==================================================================
 */

package com.logic;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.stereotype.Component;

@Component
public class AOD389End implements Tasklet {

	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
		
		return RepeatStatus.FINISHED;
	}

}