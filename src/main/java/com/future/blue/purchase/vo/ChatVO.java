package com.future.blue.purchase.vo;

import lombok.Data;

@Data
public class ChatVO {

	private String tmId;
	private String tmChatId;
	private String chatSeller;
	private String tmSender;
	private String tmContent;
	private String tmStatus;
	private String tmDate;
	private String tmMeetDate;         //수정함
	private String tmMeetPlace;
	private String tmPrice;
	private String tmContentType;
	private String tmImgPath;
	private String createDt;
	private String updateDt;

}
