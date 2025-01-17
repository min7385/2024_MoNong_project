package com.future.blue.admin.service;

import java.util.List;

import com.future.blue.admin.vo.CntVO;
import com.future.blue.auth.vo.AuthVO;

public interface IAdminService {

	public List<AuthVO> loadUserByNum(Integer i);
	
	public List<CntVO> loadProdCnt(Integer i);
	
	public void deleteMember(String memId);
}
