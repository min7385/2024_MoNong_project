package com.future.blue.auth.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.future.blue.auth.service.IAuthService;
import com.future.blue.auth.util.JwtUtil;


@Controller
@RequestMapping("/auth")
public class AuthViewController {

	@Autowired
	IAuthService service;

	@Autowired
	private RedisTemplate<String, String> redisTemplate;
	
	
	
	@GetMapping("/loginView")
	public String loginView(HttpServletRequest request) {
		String token = JwtUtil.extractToken(request);
		if(JwtUtil.validateToken(token) != null) {
			return "redirect:/";
		}
		return "auth/login";
	}
	
	@GetMapping("/logout")
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		String token = JwtUtil.extractToken(request);
		if (token != null) {
			String MemId = JwtUtil.getMemIdFromToken(token);
			JwtUtil.deleteCookie(response, "accessToken");
			redisTemplate.delete(MemId);
		}
		return "redirect:/";
	}
	
	@GetMapping("/signupView")
	public String signup() {
		return "auth/signup";
	}
	
	@GetMapping("/findIdView")
	public String findId() {
		return "auth/findId";
	}
	
	@GetMapping("/findPasswordView")
	public String findPassword() {
		return "auth/findPassword";
	}
	
}