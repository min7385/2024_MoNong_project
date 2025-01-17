package com.future.blue.push.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.future.blue.push.dao.SubscriptionDAO;
import com.future.blue.push.service.PushNotificationService;
import com.future.blue.push.vo.SubscriptionVO;

import nl.martijndwars.webpush.Subscription;

@RestController
@RequestMapping("/api")
public class PwaController {
	
	@Autowired
	PushNotificationService service;

    /**
     * 푸시 알림 구독 등록
     * @param subscriptionVO 구독 요청 정보
     * @return HTTP 상태 코드
     */
    @PostMapping("/subscribe")
    public ResponseEntity<Void> subscribe(@RequestBody Map<String, Object> payload) {
        try {
        	String userId = (String) payload.get("userId");
        	Map<String, Object> subscriptionData = (Map<String, Object>) payload.get("subscription");
        	if (subscriptionData == null) {
    			throw new IllegalArgumentException("subscription 데이터가 누락되었습니다.");
    		}
        	// endpoint 추출
    		String endpoint = (String) subscriptionData.get("endpoint");
    		if (endpoint == null || endpoint.isEmpty()) {
    			throw new IllegalArgumentException("endpoint 데이터가 누락되었습니다.");
    		}

    		// keys 추출
    		@SuppressWarnings("unchecked")
    		Map<String, String> keysData = (Map<String, String>) subscriptionData.get("keys");
    		if (keysData == null) {
    			throw new IllegalArgumentException("keys 데이터가 누락되었습니다.");
    		}

    		String p256dh = keysData.get("p256dh");
    		String auth = keysData.get("auth");

    		if (p256dh == null || auth == null) {
    			throw new IllegalArgumentException("p256dh 또는 auth 데이터가 누락되었습니다.");
    		}
    		// Subscription 객체 생성
    		SubscriptionVO subVO = new SubscriptionVO(userId, endpoint, p256dh, auth); 
    		service.insertSubscription(subVO);
    		
    		// Subscription.Keys 객체 생성
    		Subscription.Keys keys = new Subscription.Keys(p256dh, auth);
    		// Subscription 객체 생성
    		Subscription sub = new Subscription(endpoint, keys);
    		
    		service.sendPush(sub, "구독되었습니다.", "반갑습니다. 이제 채팅 내용이 알람으로 출력됩니다.");
    		
    		return new ResponseEntity<>(HttpStatus.CREATED);
    		
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 에러 발생 시 500 반환
        }
    }

    /**
     * 특정 사용자 구독 정보 조회
     * @param userId 사용자 ID
     * @return 구독 정보
     */
//    @GetMapping("/subscription/{userId}")
//    public ResponseEntity<SubscriptionVO> getSubscription(@PathVariable String userId) {
//        SubscriptionVO subscription = service.getSubscriptionByUserId(userId);
//        if (subscription != null) {
//            return ResponseEntity.ok(subscription);
//        } else {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // 구독 정보가 없는 경우 404 반환
//        }
//    }

    /**
     * 모든 구독 정보 조회
     * @return 모든 구독 정보 리스트
     */
//    @GetMapping("/subscriptions")
//    public ResponseEntity<?> getAllSubscriptions() {
//        try {
//            return ResponseEntity.ok(service.getAllSubscriptions());
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
//        }
//    }

    /**
     * 구독 삭제
     * @param userId 사용자 ID
     * @return HTTP 상태 코드
     */
//    @DeleteMapping("/subscription/{userId}")
//    public ResponseEntity<Void> deleteSubscription(@PathVariable String userId) {
//        try {
//        	service.deleteSubscription(userId);
//            return ResponseEntity.noContent().build(); // 삭제 성공 시 204 반환
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 에러 발생 시 500 반환
//        }
//    }
}