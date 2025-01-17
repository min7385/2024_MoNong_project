package com.future.blue.auth.web;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.future.blue.auth.dto.AuthDTO;
import com.future.blue.auth.enums.Role;
import com.future.blue.auth.service.IAuthService;
import com.future.blue.auth.util.JwtUtil;
import com.future.blue.auth.vo.AuthVO;
import com.future.blue.auth.vo.KakaoVO;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@RestController
@RequestMapping("/auth")
public class AuthController {
	
	private String INSERT_API_KEY = "NCSONZXYARMWF0LL";
	private String INSERT_API_SECRET_KEY = "NRTULNTMYUFMHPVSSI8DRD51I88PL8UX";
	
	@Autowired
	IAuthService authService;

	private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();	
		
	@Autowired
	private RedisTemplate<String, String> redisTemplate;

	final DefaultMessageService messageService;

	public AuthController() {
        // 반드시 계정 내 등록된 유효한 API 키, API Secret Key를 입력해주셔야 합니다!
        this.messageService = NurigoApp.INSTANCE.initialize(INSERT_API_KEY, INSERT_API_SECRET_KEY, "https://api.coolsms.co.kr");
    }
	
	@PostMapping("/loginDo")
    public String loginDo(@RequestParam String memId, @RequestParam String memPass) {
        AuthVO loginUser = authService.loadUserByMemId(memId);
        if (loginUser.getMemId().equals(memId) && passwordEncoder.matches(memPass,loginUser.getMemPass())) {
            Role memRole = loginUser.getMemRole();
            String memName = loginUser.getMemName();
            String accessToken = JwtUtil.generateToken(memId, memRole, memName);
            String refreshToken = JwtUtil.generateRefreshToken(memId, memRole, memName);
            redisTemplate.opsForValue().set(memId, refreshToken, 86400, TimeUnit.SECONDS);

            return accessToken;
        }
        throw new RuntimeException("Invalid credentials");
    }
	
	@PostMapping("/signupDo")
	public String signupDo(@RequestBody AuthDTO user) {
		String encodedPassword = passwordEncoder.encode(user.getMemPass());
		user.setMemPass(encodedPassword);
		authService.registerUser(user);
		return "redirect:/login";
	}
	
	@PostMapping("/findIdDo")
	public String findIdDo(@RequestParam String memName, @RequestParam String memPhone) {
		System.out.println(memName);
		System.out.println(memPhone);
		Map <String, String> nameAndPhone = new HashMap<>();
		nameAndPhone.put("memName",memName);
		nameAndPhone.put("memPhone",memPhone);
		AuthVO authVO = authService.findByNameAndMail(nameAndPhone);
		String memId = authVO.getMemId();
		return memId;
	}
//	@PostMapping("/findIdDo")
//	public String findIdDo(@RequestBody String memPhone) {
//		memPhone = memPhone.replace("\"", "");
//		AuthVO authVO = authService.findByUserMail(memPhone);
//		String memId = authVO.getMemId();
//		return memId;
//	}
	
	@PostMapping("/findPasswordDo")
    public Boolean findPasswordDo(@RequestParam String memId, @RequestParam String memPhone) {
		Map <String, String> IdAndPhone = new HashMap<>();
		IdAndPhone.put("memId",memId);
		IdAndPhone.put("memPhone",memPhone);
		AuthVO authVO = authService.findPassword(IdAndPhone);
		return authVO != null;
    }

	@PostMapping("/updatePassword")
	public void updatePassword(@RequestParam String memId, @RequestParam String memPw) {
		String encodedPassword = passwordEncoder.encode(memPw);
		Map <String, String> IdAndPw = new HashMap<>();
		IdAndPw.put("memId",memId);
		IdAndPw.put("memPass",encodedPassword);
		authService.updatePassword(IdAndPw);
	}
	
	@PostMapping("/idCheck")
	public String idCheck(@RequestBody String memId) {
		memId = memId.replace("\"", "");
		AuthVO authVO = authService.loadUserByMemId(memId);
		if(authVO == null) {
			return null;
		}
		return memId;
	}
	
	@PostMapping("/kakaoLogin")
    public String kakaoLogin(@RequestBody String kakaoAccessToken, HttpServletResponse response) {
		  try {
		         KakaoVO kakaoUser = authService.kakaoLogin(kakaoAccessToken);
		         
		         String memId = kakaoUser.getMemId();
		         Role memRole = kakaoUser.getMemRole();
		         String memName = kakaoUser.getMemName();
		         
		         String accessToken = JwtUtil.generateToken(memId, memRole, memName);
		         String refreshToken = JwtUtil.generateRefreshToken(memId, memRole, memName);
		         redisTemplate.opsForValue().set(memId, refreshToken, 86400, TimeUnit.SECONDS);
		         return accessToken;
		      } catch (Exception e) {
		         System.out.println("Error: " + e.getMessage());
		         return "Login Failed";
		      }
    }
	
	@PostMapping("/send-one")
	    public String sendOne(@RequestBody String memPhone) {
	        Message message = new Message();
	        // 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
	        memPhone = memPhone.replace("-", "");
	        if(memPhone.matches("^010\\d{8}$")) {
	        	Random random = new Random();
	        	int randomNumber = random.nextInt(1000000);
	        	String formattedNumber = String.format("%06d", randomNumber);
	        	
	        	message.setFrom("01058773297");
		        message.setTo(memPhone);
		        message.setText("[모두가농부] 인증번호 [" + formattedNumber + "] 타인에게 알려주지 마세요.");
	        	
		        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
		        if(response.getStatusCode().equals("2000")) {
		        	return formattedNumber;
		        }
	        }
	        return null;
	    }

	
}