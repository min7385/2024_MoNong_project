package com.future.blue.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.future.blue.admin.dao.IAdminDAO;
import com.future.blue.admin.vo.CntVO;
import com.future.blue.auth.vo.AuthVO;

@Service("IAdminService")
public class AdminServiceImpl implements IAdminService{
	
	@Autowired
	IAdminDAO dao;
	
	@Override
	public List<AuthVO> loadUserByNum(Integer i) {
		return dao.loadUserByNum(i);
	};
	
	@Override
	public List<CntVO> loadProdCnt(Integer i) {
		return dao.loadProdCnt(i);
	};
	
	@Override
	public void deleteMember(String memId) {
		dao.deleteMember(memId);
	};
	
}
