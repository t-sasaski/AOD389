/*
 * ==================================================================
 * File Name ：AOD999UpdateOrderNetMapper.java
 * Outline   ：
 * ==================================================================
 */

package com.logic.repository;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AOD999UpdateOrderNetMapper {
	
	void aodf_waod999_UpdateOrder_net(Map parameters);
	
}