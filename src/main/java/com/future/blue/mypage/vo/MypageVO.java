package com.future.blue.mypage.vo;

import com.future.blue.auth.enums.Role;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MypageVO {
	
	private String memId;
	private String memPass;
	private Role memRole;
	private String memName;
	private String memPhone;
	private String memAddr;
	private String memRel;
	private String memProfile;
	private String memNic;
	private String createDate;
	
}
