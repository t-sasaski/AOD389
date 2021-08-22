/*
 * ==================================================================
 * File Name ：AOD999CheckOrderNetMapper.java
 * Outline   ：
 * ==================================================================
 */

package com.logic.repository;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AOD999CheckOrderNetMapper {
	
	void aodf_waod999_CheckOrder_net(Map parameters);
	
}