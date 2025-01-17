package com.future.blue.common.web;

import java.util.HashMap;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api_auto")
public class FlaskController {
	
	// Flask 서버 URL
    private final String FLASK_URL = "http://192.168.0.44:5000/generate";

    @PostMapping("/generate")
    public ResponseEntity<Map<String, Object>> generate(@RequestBody Map<String, String> request) {
        String category = request.get("category");

        // 카테고리가 비어 있는 경우 처리
        if (category == null || category.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "카테고리가 누락되었습니다."));
        }

        // Flask로 요청 전송
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Flask에 전달할 데이터
        Map<String, String> body = new HashMap<>();
        body.put("category", category);

        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(body, headers);

        try {
            // Flask 서버로 POST 요청
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
            		 FLASK_URL, 
                     org.springframework.http.HttpMethod.POST, 
                     requestEntity, 
                     new ParameterizedTypeReference<Map<String, Object>>() {}
             );
            
            // Flask 서버에서 받은 응답 반환
            return ResponseEntity.ok(response.getBody());
        } catch (Exception e) {
        	
            // 에러 발생 시 처리
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Flask 서버와의 통신 중 문제가 발생했습니다."));
        }
    }

}
