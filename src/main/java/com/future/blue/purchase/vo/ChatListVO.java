package com.future.blue.purchase.vo;

import lombok.Data;

@Data
public class ChatListVO {
	
	private String chatId;           // 채팅 ID
    private String sellerNic;        // 판매자 닉네임
    private String chatSeller;       // 판매자 id
    private String buyerNic;         // 구매자 닉네임
    private String chatBuyer;        // 구매자 Id
    private String buyerProfile;     // 구매자 프로필
    private String prodId;           // 상품 ID
    private String prodName;         // 상품 이름
    private String chatStatus;       // 채팅 상태
    private String createDt;         // 채팅 생성 날짜/시간
    private String lastContent;      // 마지막 메시지 내용

}
