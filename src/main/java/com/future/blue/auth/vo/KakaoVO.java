package com.future.blue.auth.vo;

import com.future.blue.auth.enums.Role;

import lombok.Data;

@Data
public class KakaoVO {
    private String memId;
    private String memName;
    private String memNic;
    private String memProfile;
    private Role memRole;
	private String memPass;
	private String memPhone;
	private String memAddr;
	private String createDate;
 }
