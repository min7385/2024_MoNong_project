package com.future.blue.auth.util;

import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.security.SignatureException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.future.blue.auth.enums.Role;

public class JwtUtil {
	   private static final Key  SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS512); // 안전한 키 생성

	   private static final long EXPIRATION_TIME = 1000 * 60 * 10; // 10분
	   private static final long REFRESH_EXPIRATION_TIME = 1000 * 60 * 60 * 24; // 1일
	   
	   // 최초 토큰 생성
	   public static String generateToken(String memId, Role role, String memName) {
	        return Jwts.builder()
	                .setSubject(memId)
	                .claim("role", role.name())
	                .claim("name", memName)
	                .setIssuedAt(new Date())
	                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
	                .signWith(SECRET_KEY)
	                .compact();
	    }
	   
	   // 리프레쉬 토큰 생성
	   public static String generateRefreshToken(String memId, Role role, String memName) {
		    return Jwts.builder()
		            .setSubject(memId)
		            .claim("role", role.name())
		            .claim("name", memName)
		            .setIssuedAt(new Date())
		            .setExpiration(new Date(System.currentTimeMillis() + REFRESH_EXPIRATION_TIME))
		            .signWith(SECRET_KEY)
		            .compact();
		}
	   
	   // 액세스 토큰 갱신
	   public static String refreshAccessToken(String refreshToken) {
		    Claims claims = validateToken(refreshToken);
		    String role = claims.get("role", String.class);
		    String memName = claims.get("name", String.class);
		    String memId = claims.getSubject();
		    
		    return Jwts.builder()
		            .setSubject(memId)
		            .claim("role", role)
		            .claim("name", memName)
		            .setIssuedAt(new Date())
		            .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // 엑세스 토큰의 짧은 유효기간
		            .signWith(SECRET_KEY)
		            .compact();
		}
	   
	   // 토큰 검증
	   public static Claims validateToken(String token) {
	        try {
	            return Jwts.parserBuilder()
	                    .setSigningKey(SECRET_KEY)
	                    .build()
	                    .parseClaimsJws(token)
	                    .getBody();
	        } catch (ExpiredJwtException e) {
	        	System.out.println("Token has expired: " + e.getMessage());
	            return null;
	        } catch (MalformedJwtException e) {
	            System.out.println("Invalid token: " + e.getMessage());
	            return null;
	        } catch (SignatureException e) {
	            System.out.println("JWT signature does not match locally computed signature: " + e.getMessage());
	            return null;
	        } catch (Exception e) {
	        	System.out.println("Token validation failed: " + e.getMessage());
	        	return null;
	        }
	    }
	   
	   // 토큰 만료 확인
	    public static boolean isTokenExpired(String token) {
	        try {
	        	   Date expiration = Jwts.parserBuilder()
	                       .setSigningKey(SECRET_KEY)
	                       .build()
	                       .parseClaimsJws(token)
	                       .getBody()
	                       .getExpiration();
	               return expiration.before(new Date());
	        } catch (JwtException e) {
	            return true;
	        }
	    }
	    
	    // 토큰에서 아이디 추출
	    public static String getMemIdFromToken(String token) {
	        if (token != null) {
	        	try {
	        		Claims claims = Jwts.parserBuilder()
	        				.setSigningKey(SECRET_KEY)
	        				.build()
	        				.parseClaimsJws(token)
	        				.getBody();
	        		
	        		String memId = claims.getSubject();
	        		
	        		return memId;
	        	}catch (ExpiredJwtException e) {
		        	System.out.println("Token has expired: " + e.getMessage());
		        	String memId = e.getClaims().getSubject(); 
		        	
		            return memId;
	        	} catch (SignatureException e) {
		            System.out.println("JWT signature does not match locally computed signature: " + e.getMessage());
		            return null;
	        	}
	        }
	        return null;
	    }
	    
	    // 토큰에서 이름 추출
	    public static String getMemNameFromToken(String token) {
	        if (token != null) {
	            try {
	                Claims claims = Jwts.parserBuilder()
	                        .setSigningKey(SECRET_KEY)
	                        .build()
	                        .parseClaimsJws(token)
	                        .getBody();
	                
	                String memName = claims.get("name", String.class);
	                
	                return memName;
	            } catch (ExpiredJwtException e) {
	                System.out.println("Token has expired: " + e.getMessage());
	                String memName = e.getClaims().get("name", String.class); 
	                
	                return memName;
	            } catch (SignatureException e) {
	                System.out.println("JWT signature does not match locally computed signature: " + e.getMessage());
	                return null;
	            }
	        }
	        return null;
	    }
	    
	    // 토큰 가져오기
	    public static String extractToken(HttpServletRequest request) {
	    	Cookie[] cookies = request.getCookies();
	    	
	    	if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("accessToken".equals(cookie.getName())) {
	                    return cookie.getValue(); 
	                }
	            }
	        }
	        return null;
	    }
	    
	    public static void deleteCookie(HttpServletResponse response, String cookieName) {
	        Cookie cookie = new Cookie(cookieName, null);
	        cookie.setMaxAge(0);  
	        cookie.setPath("/");  
	        response.addCookie(cookie);
	    }
	    
	    // 쿠키 추가
	    public static void addCookie(HttpServletResponse response, String token) {
	    	Cookie cookie = new Cookie("accessToken", token);
	    	cookie.setPath("/"); 
	    	cookie.setMaxAge(60 * 10);
	        response.addCookie(cookie);
	    }
}
