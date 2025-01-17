package com.future.blue.mypage.vo;

import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.future.blue.common.vo.DateTimeUtil;

import lombok.Data;

@Data
public class MypageChatVO {
	
	private int tmChatId;
	private String memId;
	private String memNic;
	private String memAddr;
	private String tmDate;
	private String prodPhotoPath;
	private String tmContent;
	private String tmContentType;
    private String chatSeller;
    private String chatBuyer;
    private int chatProdId;
    private String prodCategory;
    private String prodStatus;
    
    private String relativeTime;
    
    public void setRelativeTime() {
        this.relativeTime = DateTimeUtil.calculateRelativeTime(this.tmDate);
    }
//    
//    public String relativeTime() {
//    	return DateTimeUtil.calculateRelativeTime(this.tmDate);
//    }
    
    public String getCityAndDistrict() {
        if (memAddr == null || memAddr.isEmpty()) {
            return "알 수 없음";
        }
        Pattern pattern = Pattern.compile("^(\\S+)\\s+(\\S+)\\s+(\\S+)");
        Matcher matcher = pattern.matcher(memAddr);
        if (matcher.find()) {
            return matcher.group(1) + " " + matcher.group(2) + " " + matcher.group(3); 
        }
        return memAddr; 
    }
}
