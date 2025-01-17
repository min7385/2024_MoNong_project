package com.future.blue.push.service;

import java.security.Security;
import java.util.List;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.future.blue.purchase.vo.ChatVO;
import com.future.blue.push.dao.SubscriptionDAO;
import com.future.blue.push.vo.SubscriptionVO;

import nl.martijndwars.webpush.Notification;
import nl.martijndwars.webpush.PushService;
import nl.martijndwars.webpush.Subscription;

@Service
public class PushNotificationService {
	
    @Autowired
    private SubscriptionDAO subscriptionDao;
    
    @Value("#{util['vapid.publicKey']}")
	private String publicKey;
	
	@Value("#{util['vapid.privateKey']}")
	private String privateKey;
	
	@Value("#{util['vapid.subject']}")
	private String subject;

    // BouncyCastleProvider 초기화
    public PushNotificationService() {
        if (Security.getProvider("BC") == null) {
            Security.addProvider(new BouncyCastleProvider());
        }
    }
    public void insertSubscription(SubscriptionVO subscription) {
    	subscriptionDao.insertSubscription(subscription);
    }
    
    public void sendList(ChatVO chatVO) {
    	List<SubscriptionVO> pushList = null;
    	String from = chatVO.getTmSender();
    	String to = "";
    	String chatSeller = "";
    	String chatBuyer = "";
    	String prodId = "";
    	// 방장이 -> 고객에게    	
    	if(chatVO.getChatSeller().equals(chatVO.getTmSender())) {
    		 pushList = subscriptionDao.sendToBuyer(chatVO);
    		 chatBuyer = chatVO.getChatSeller();
    	// 고객이 -> 방장에게
    	}else {
    		chatBuyer = chatVO.getTmSender();
    		pushList = subscriptionDao.sendToSeller(chatVO);
    	}
    	for(int i = 0 ; i < pushList.size(); i ++) {
    		SubscriptionVO subVO = pushList.get(i);
    		to = subVO.getMemId();
    		chatSeller = subVO.getChatSeller();
    		prodId = subVO.getChatProdId();
    		// Subscription.Keys 객체 생성
    		Subscription.Keys keys = new Subscription.Keys(subVO.getP256dhKey(), subVO.getAuthKey());
    		// Subscription 객체 생성
    		Subscription sub = new Subscription(subVO.getEndpoint(), keys);
    		sendPushChat(sub, to + "님 " + from + " 에게 메세지 왔습니다.", chatVO.getTmContent() ,chatSeller ,chatBuyer ,prodId);
    	}
    }
    
    
    // 푸시 알림 전송 로직
    public void sendPush(Subscription subscription, String title, String body) {
        PushService pushService = new PushService();
        try {
            pushService.setPublicKey(publicKey);
            pushService.setPrivateKey(privateKey);
            pushService.setSubject(subject);

            // 푸시 알림에 포함할 데이터
            String payload = String.format(
                "{\"title\":\"%s\", \"body\":\"%s\"}", title, body );
            // 알림 생성 및 전송
            Notification notification = new Notification(subscription, payload);
            pushService.send(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 푸시 알림 전송 로직
    public void sendPushChat(Subscription subscription, String title, String body, String chatSeller, String chatBuyer, String chatProdId) {
        PushService pushService = new PushService();
        try {
            pushService.setPublicKey(publicKey);
            pushService.setPrivateKey(privateKey);
            pushService.setSubject(subject);
            // 푸시 알림에 포함할 데이터
            String payload = String.format(
                "{\"title\":\"%s\", \"body\":\"%s\", \"chatSeller\":\"%s\", \"chatBuyer\":\"%s\", \"chatProdId\":\"%s\"}",
                title, body, chatSeller, chatBuyer, chatProdId
            );
            // 알림 생성 및 전송
            Notification notification = new Notification(subscription, payload);
            pushService.send(notification);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}