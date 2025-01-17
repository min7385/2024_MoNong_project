package com.future.blue.common.util;

import javax.servlet.http.HttpServletRequest;

import com.future.blue.auth.util.JwtUtil;

public class MemberUtil {
	
	public static String getMemIdFromCookie(HttpServletRequest request) {
		String token = JwtUtil.extractToken(request);
		String memId = JwtUtil.getMemIdFromToken(token);
		if(memId != null) {
			return memId;
		}
		return null;
	}
	
	public static boolean loginCheck(HttpServletRequest request) {
		String token = JwtUtil.extractToken(request);
		String memId = JwtUtil.getMemIdFromToken(token); 
		if(memId != null) {
			return true;
		}
		return false;
	}
	
	public static String getMemNameFromCookie(HttpServletRequest request) {
		String token = JwtUtil.extractToken(request);
		String memName = JwtUtil.getMemNameFromToken(token);
		if(memName != null) {
			return memName;
		}
		return null;
	}

}
