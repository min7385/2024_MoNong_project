package com.future.blue.auth.service;

import java.util.Map;

import com.future.blue.auth.dto.AuthDTO;
import com.future.blue.auth.vo.AuthVO;
import com.future.blue.auth.vo.KakaoVO;

public interface IAuthService {
	public AuthVO loadUserByMemId(String memId);

	public void registerUser(AuthDTO authDTO);
	
	public AuthVO findByNameAndMail(Map <String, String> nameAndPhone);
	
	public AuthVO findPassword(Map <String, String> IdAndPhone);
	
	public void updatePassword(Map <String, String> IdAndPw);

	public KakaoVO kakaoLogin(String accessToken);
	
	public void insertUser(KakaoVO user);

	public KakaoVO parseKakaoResponse(String responseBody);
}
