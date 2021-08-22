/*
 * ==================================================================
 * File Name ：BatchConfig.java
 * Outline   ：バッチ処理フロー
 * ==================================================================
 */

package com.logic;

import javax.sql.DataSource;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecutionListener;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.item.database.BeanPropertyItemSqlParameterSourceProvider;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;

import com.logic.dto.AOD389AodwNetOrderDataDto;
import com.logic.dto.FAODI3891;

@Configuration
@EnableBatchProcessing
public class BatchConfig {
	
	@Autowired
	private JobBuilderFactory jobBuilderFactory;

	@Autowired
	private StepBuilderFactory stepBuilderFactory;
	
	@Autowired
	private DataSource dataSource;	
	
	@Autowired
	private WAOD389001InitTasklet wAOD389001InitTasklet;
	
	@Autowired
	private WAOD389001ResultTasklet wAOD389001ResultTasklet;
	
	@Autowired
	private WAOD389002Tasklet wAOD389002Tasklet;
	
	@Autowired
	private AOD999CheckOrderNetTasklet aOD999CheckOrderNetTasklet;

	@Autowired
	private AOD999UpdateOrderNetTasklet aOD999UpdateOrderNetTasklet;
	

	/**
	 * ステップ１－１ WAOD389001：Reader
	 * 
	 * CSVファイルを読み込み、配列に格納
	 */
	@Bean
	public FlatFileItemReader<FAODI3891> wAOD389001reader() {
		
		FlatFileItemReader<FAODI3891> reader = new FlatFileItemReader<FAODI3891>();
		
		reader.setResource(new ClassPathResource("FAODI3891_01"));
		
		reader.setLineMapper(new DefaultLineMapper<FAODI3891>() {{
			setLineTokenizer(new DelimitedLineTokenizer() {{
				setNames(new String[] { "storeCdAc","tranDate",
						"tranTime", "tranSerialNum", "bizDay", "storeCdOrder",
						"operateType", "itemCd", "itemNm", "itemFlag", "itemNum",
						"memberNo", "posFreeItem"});
			}});
			setFieldSetMapper(new BeanWrapperFieldSetMapper<FAODI3891>() {{
				setTargetType(FAODI3891.class);
			}});
		}});

		return reader;

	}
	
	/**
	 * ステップ１－２ WAOD389001：Processor
	 * 
	 * 取得したアイテム（CSV）加工・データチェッククラス
	 */
	@Bean
	public WAOD389001ItemProcessor wAOD389001Processor() {
		return new WAOD389001ItemProcessor();
	}
	
	/**
	 * ステップ１－３ WAOD389001：Writer
	 * 
	 * ネット注文データワークに登録
	 */
	@Bean
	public JdbcBatchItemWriter<AOD389AodwNetOrderDataDto> wAOD389001Writer() {
		
		JdbcBatchItemWriter<AOD389AodwNetOrderDataDto> writer = new JdbcBatchItemWriter<AOD389AodwNetOrderDataDto>();
		
		writer.setItemSqlParameterSourceProvider(new BeanPropertyItemSqlParameterSourceProvider<AOD389AodwNetOrderDataDto>());
		writer.setSql("INSERT INTO aodw_net_order_data("
				+ " tran_date"
				+ ", tran_time"
				+ ", tran_serial_num"
				+ ", bu_gp_store_id"
				+ ", bu_gp_cd"
				+ ", item_id"
				+ ", item_cd"
				+ ", order_quantity"
				+ ", error_msg"
				+ " ) VALUES ( "
				+ ":tranDate"
				+ ", :tranTime"
				+ ", :tranSerialNum"
				+ ", :buGpStoreId"
				+ ", :buGpCd"
				+ ", :itemId"
				+ ", :itemCd"
				+ ", :orderQuantity"
				+ ", :errorMsg)");
		writer.setDataSource(dataSource);
		return writer;
	}
	
	
	@Bean
	public JobExecutionListener listener() {
		return new JobStartEndLIstener(new JdbcTemplate(dataSource));
	}
	
	/**
	 * ステップ０ 初期処理
	 */
	@Bean
	public Step step0() {
		return stepBuilderFactory.get("step0")
				.tasklet(wAOD389001InitTasklet)
				.build();
	}
	
	/**
	 * ステップ１ WAOD389001
	 */
	@Bean
	public Step step1() {
		return stepBuilderFactory.get("step1")
				.<FAODI3891,AOD389AodwNetOrderDataDto> chunk(10)
				.reader(wAOD389001reader())
				.processor(wAOD389001Processor())
				.writer(wAOD389001Writer())
				.build();
	}
	
	/**
	 * ステップ１ 処理結果（件数）取得
	 */
	@Bean
	public Step step1Result() {
		return stepBuilderFactory.get("step1Result")
			.tasklet(wAOD389001ResultTasklet)
			.build();
	}

	/**
	 * ステップ２ WAOD389002
	 */
	@Bean
	public Step step2() {
		return stepBuilderFactory.get("step2")
				.tasklet(wAOD389002Tasklet)
				.build();
	}
	
	/**
	 * ステップ３ AOD999CheckOrder_net
	 */
	@Bean
	public Step step3() {
		return stepBuilderFactory.get("step3")
				.tasklet(aOD999CheckOrderNetTasklet)
				.build();
	}
	
	/**
	 * ステップ４ AOD999UpdateOrder_net
	 */
	@Bean
	public Step step4() {
		return stepBuilderFactory.get("step4")
				.tasklet(aOD999UpdateOrderNetTasklet)
				.build();
	}
	
	/**
	 * ジョブフロー
	 */
	@Bean
	public Job testJob() {
		return jobBuilderFactory.get("testJob")
				.incrementer(new RunIdIncrementer())
				.listener(listener())
				.start(step0())
				.next(step1())
				.next(step1Result())
//				.next(step1Result()).on(ExitStatus.COMPLETED.getExitCode()).to(step2)
//				.next(step1Result()).on(ExitStatus.FAILED.getExitCode()).to(step5)
				.next(step2())
				.next(step3())
				.next(step4())
//				.end()
				.build();
	}
	

}
