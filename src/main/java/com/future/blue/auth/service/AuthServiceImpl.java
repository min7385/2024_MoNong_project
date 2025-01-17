package com.future.blue.auth.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.future.blue.auth.dao.IAuthDAO;
import com.future.blue.auth.dto.AuthDTO;
import com.future.blue.auth.enums.Role;
import com.future.blue.auth.util.JwtUtil;
import com.future.blue.auth.vo.AuthVO;
import com.future.blue.auth.vo.KakaoVO;

@Service("IAuthService")
public class AuthServiceImpl implements IAuthService {
	@Autowired
	IAuthDAO dao;
	
	private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();	

	@Override
	public AuthVO loadUserByMemId(String memId) {
		return dao.loadUserByMemId(memId);
	}

	@Override
	public void registerUser(AuthDTO authDTO) {
		dao.registerUser(authDTO);
	}

	@Override
	public AuthVO findByNameAndMail(Map <String, String> nameAndPhone) {
		return dao.findByNameAndMail(nameAndPhone);
	}

	@Override
	public AuthVO findPassword(Map<String, String> IdAndPhone) {
		return dao.findPassword(IdAndPhone);
	}

	@Override
	public void updatePassword(Map<String, String> IdAndPw) {
		dao.updatePassword(IdAndPw);
	}

	@Override
	public KakaoVO kakaoLogin(String accessToken) {
		String url = "https://kapi.kakao.com/v2/user/me";
		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + accessToken);
		HttpEntity<String> entity = new HttpEntity<>(headers);
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
		String responseBody = response.getBody();
		KakaoVO kakaoUser = parseKakaoResponse(responseBody);
		return kakaoUser;
	}

	@Override
	public KakaoVO parseKakaoResponse(String responseBody) {
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			JsonNode rootNode = objectMapper.readTree(responseBody);
			KakaoVO kakaoUser = new KakaoVO();
			
			// "id" 값 추출
			String memId = rootNode.path("id").asText();
			if(dao.loadUserByKakaoId(memId) == null) {
				kakaoUser.setMemId(memId);
				
				// "properties" 내에서 "nickname"과 "profile_image" 추출
				JsonNode propertiesNode = rootNode.path("properties");
				kakaoUser.setMemName(propertiesNode.path("nickname").asText());
				kakaoUser.setMemNic(propertiesNode.path("nickname").asText());
				kakaoUser.setMemProfile(propertiesNode.path("profile_image").asText());
				
				kakaoUser.setMemRole(Role.valueOf("USER"));
				
				// 임시값 (아이디를 암호화해서 저장)
				kakaoUser.setMemPass(passwordEncoder.encode(rootNode.path("id").asText()));
				kakaoUser.setMemAddr("임시");
				
				insertUser(kakaoUser);
			}else {
				kakaoUser = dao.loadUserByKakaoId(memId);
			}
			return kakaoUser;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public void insertUser(KakaoVO kakaoUser) {
		dao.insertKakaoUser(kakaoUser);
	}
}
