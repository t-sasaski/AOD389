/*
 * ==================================================================
 * File Name ：WAOD389002Mapper.java
 * Outline   ：
 * ==================================================================
 */

package com.logic.repository;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WAOD389002Mapper {
	
	void aodf_waod389002_mainprocess(Map parameters);
	
}