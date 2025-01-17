package com.future.blue.purchase.vo;

import lombok.Data;

@Data
public class RoomVO {

	    private String chatId;           // 채팅방의 고유 ID
	    private String chatSeller;       // 판매자 회원 ID
	    private String chatBuyer;        // 구매자 회원 ID
	    private String chatStatus;    	 // 판매자의 상태 (예: 활성, 비활성)
	    private String chatProdId;       // 연결된 상품 ID
	    private String tmDate;    		 // 메세지 작성일시
	    private String tmMeetDate;       // 거래 약속 시간
	    private String tmMeetPlace; 	 // 거래 약속 장소
	    private String tmStatus;         // 거래 상태
	    private String tmPrice;          // 거래 가격
	    private String createDt;         // 채팅방 생성일
	    private String updateDt;         // 채팅방 수정일 
	    private int createChatRoom;      // 채팅방 생성 여부를 나타내는 플래그
	    //추가된것
	    private String prodName;         // 물품 이름
	    private String prodContent;      // 물품 설명
	    private int prodPrice;           // 물품 가격
	    private String prodPlace;        // 희망 지역
	    private String prodPhotoPath;  // 상품사진
	    private String memReliability;  // 신뢰도
	}

