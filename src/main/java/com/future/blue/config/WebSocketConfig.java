package com.future.blue.config;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.converter.MessageConverter;
import org.springframework.messaging.handler.invocation.HandlerMethodArgumentResolver;
import org.springframework.messaging.handler.invocation.HandlerMethodReturnValueHandler;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketTransportRegistration;
import org.springframework.web.socket.messaging.SessionConnectEvent;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    // WebSocket 엔드포인트 등록 (SockJS 사용)
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/endpoint").withSockJS();
    }

    // 메시지 브로커 설정 (클라이언트의 메시지를 라우팅)
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/subscribe"); // "/subscribe"로 메시지를 라우팅
        registry.setApplicationDestinationPrefixes("/app"); // "/app"으로 시작하는 메시지를 처리
    }


    @Override
    public void configureWebSocketTransport(WebSocketTransportRegistration registry) {
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
    }

    @Override
    public void configureClientOutboundChannel(ChannelRegistration registration) {
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
    }

    @Override
    public void addReturnValueHandlers(List<HandlerMethodReturnValueHandler> returnValueHandlers) {
    }

    @Override
    public boolean configureMessageConverters(List<MessageConverter> messageConverters) {
        return true;
    }

    // WebSocket 연결 시 처리할 이벤트 (세션 연결 시)
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectEvent event) {
        StompHeaderAccessor sha = StompHeaderAccessor.wrap(event.getMessage());

        // WebSocket 연결 시 헤더에서 memId와 prodId를 추출
        String memId = sha.getFirstNativeHeader("userId");
        String chatId = sha.getFirstNativeHeader("chatId");

        if (memId == null || memId.isEmpty()) {
            memId = "알 수 없는 사용자";
        }
        if (chatId == null || chatId.isEmpty()) {
            chatId = "공용 채팅방";
        }
    	System.out.println("헤더 값 누락: userId=" + memId + ", chatId=" + chatId);

        // 메시지 생성
        Map<String, Object> message = new HashMap<>();
        message.put("type", "notification");
        message.put("message", memId + "님이 입장하셨습니다.");
        System.out.println("생성된 메시지: " + message);

        // 해당 제품의 채팅방에 메시지 전송
        messagingTemplate.convertAndSend("/subscribe/chat/" + chatId, message);
    }
}
