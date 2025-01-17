package com.future.blue;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.future.blue.auth.service.IAuthService;
import com.future.blue.auth.util.JwtUtil;
import com.future.blue.auth.vo.AuthVO;
import com.future.blue.mypage.service.IMypageService;
import com.future.blue.mypage.vo.MypageVO;
import com.future.blue.mypage.vo.PointVO;

@ControllerAdvice
public class GlobalControllerAdvice {

	@Autowired
	IAuthService authService;
	
	@Autowired
	IMypageService mypageService;

    // 모든 페이지에서 공통으로 사용할 데이터
	
    @ModelAttribute("userInfo")
    public AuthVO userInfo(HttpServletRequest request) {
	    String accessToken = JwtUtil.extractToken(request);
	    String memId = JwtUtil.getMemIdFromToken(accessToken);
	    AuthVO userInfo = authService.loadUserByMemId(memId);

        return userInfo;
    }
    
    @ModelAttribute("myPageInfo")
    public MypageVO myPageInfo(HttpServletRequest request) {
    	String accessToken = JwtUtil.extractToken(request);
    	String memId = JwtUtil.getMemIdFromToken(accessToken);
    	MypageVO myPageInfo = mypageService.getMyData(memId);
    	
    	return myPageInfo;
    }
    
    @ModelAttribute("myPoint")
    public PointVO myPoint(HttpServletRequest request) {
    	String accessToken = JwtUtil.extractToken(request);
    	String memId = JwtUtil.getMemIdFromToken(accessToken);
    	PointVO myPoint = mypageService.getMyPoint(memId);

    	return myPoint;
    }
    
    
}
