package com.future.blue.admin.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.future.blue.admin.vo.CntVO;
import com.future.blue.auth.vo.AuthVO;

@Mapper
public interface IAdminDAO {

	public List<AuthVO> loadUserByNum(Integer i);
	
	public List<CntVO> loadProdCnt(Integer i);

	public void deleteMember(String memId);
}
