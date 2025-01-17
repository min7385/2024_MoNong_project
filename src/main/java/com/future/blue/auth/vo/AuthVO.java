package com.future.blue.auth.vo;

import com.future.blue.auth.enums.Role;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AuthVO {
	
	private String memId;
	private String memPass;
	private Role memRole;
	private String memName;
	private String memPhone;
	private String memNic;
	private String memProfile;
	private String createDate;
}
