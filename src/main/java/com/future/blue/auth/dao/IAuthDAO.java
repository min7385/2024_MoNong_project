package com.future.blue.auth.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.future.blue.auth.vo.AuthVO;
import com.future.blue.auth.vo.KakaoVO;
import com.future.blue.auth.dto.AuthDTO;

@Mapper
public interface IAuthDAO {
	public AuthVO loadUserByMemId(String memId);
	
	public void registerUser(AuthDTO authDTO);
	
	public AuthVO findByNameAndMail(Map <String, String> nameAndPhone);

	public AuthVO findPassword(Map <String, String> IdAndPhone);
	
	public void updatePassword(Map <String, String> IdAndPw);
	
	public void insertKakaoUser(KakaoVO kakaoUser);
	
	public KakaoVO loadUserByKakaoId(String memId);
}	
