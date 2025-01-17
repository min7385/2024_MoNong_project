package com.future.blue.mypage.vo;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.future.blue.common.vo.DateTimeUtil;

import lombok.Data;

@Data
public class MypageReviewVO {
	private String revId;
	private String memId;
	private String memNic;
	private String memProfile;
	private String memAddr;
	private String revWriter;
	private String revTarget;
	private String revScore;
	private String revContent;
	private String revDate;
	private String revProdId;
	private String prodCategory;

	private String relativeTime;

	public void setRelativeTime() {
		this.relativeTime = DateTimeUtil.calculateRelativeTime(this.revDate);
	}

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
