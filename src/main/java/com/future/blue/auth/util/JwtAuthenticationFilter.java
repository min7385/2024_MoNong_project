package com.future.blue.auth.util;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import io.jsonwebtoken.Claims;

public class JwtAuthenticationFilter extends OncePerRequestFilter {

	@Autowired
	private RedisTemplate<String, String> redisTemplate;
	
	@Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String token = JwtUtil.extractToken(request);
        
        if(token == null || JwtUtil.isTokenExpired(token) || JwtUtil.validateToken(token) == null) {
        	
        	String memId = JwtUtil.getMemIdFromToken(token);

        	JwtUtil.deleteCookie(response, "accessToken");
        	
        	if (memId != null) {
        		String refreshToken = redisTemplate.opsForValue().get(memId);
        		if (refreshToken != null) {
        			Claims claims = JwtUtil.validateToken(refreshToken);
        			String role = claims.get("role",String.class);
        			
        			String newToken = JwtUtil.refreshAccessToken(refreshToken);
        			
        			JwtUtil.addCookie(response, newToken);
        			
        			List<GrantedAuthority> authorities = Arrays.asList(new SimpleGrantedAuthority("ROLE_" + role));

                    Authentication authentication = new UsernamePasswordAuthenticationToken(memId, null, authorities);
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    System.out.println("새로운 액세스토큰을 발급했습니다.");
        		} else {
        			// 리프레시토큰이 없을경우
        			System.out.println("리프레시토큰이 없습니다.");
                	SecurityContextHolder.clearContext();
                	JwtUtil.deleteCookie(response, "accessToken");
                }
        	}else {
        		// 유저이름이 없을경우
                SecurityContextHolder.clearContext();
                JwtUtil.deleteCookie(response, "accessToken");
        	}
        }else {
        	// 엑세스토큰이 존재하고 정상적으로 인증되는경우
        	Claims claims = JwtUtil.validateToken(token);
        	request.setAttribute("claims", claims);
            
            String memId = claims.getSubject();
            String role = claims.get("role", String.class);
            
            List<GrantedAuthority> authorities = Arrays.asList(new SimpleGrantedAuthority("ROLE_" + role));

            Authentication authentication = new UsernamePasswordAuthenticationToken(memId, null, authorities);
            SecurityContextHolder.getContext().setAuthentication(authentication);
            
            if (request.getRequestURI().startsWith("/admin") && !role.equals("ADMIN")) {
                response.sendRedirect("/"); 
                return; 
            }
            
        }
        chain.doFilter(request, response);  
    }
}

