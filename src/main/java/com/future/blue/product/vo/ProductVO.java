package com.future.blue.product.vo;

import java.text.NumberFormat;
import java.util.Locale;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import com.future.blue.common.vo.DateTimeUtil;

import lombok.Data;

@Data
public class ProductVO {
	
	private int prodId;
	private String prodSeller;
	private String prodName;
	private String prodContent;
	private int prodPrice;
	private String prodStatus;
	private String prodCategory;
	private String prodPlace;
	private String createDt;
	private String updateDt;
	private String imagePath;
	private String memNic;
	private String memReliability;
	private String memProfile;
	private Double latitude;
	private Double longitude;
	// distance_km 추가(현재 위치와 상품판매위치와의 거리)
    private Double distanceKm;
	
	private String relativeTime; // 상대 시간 필드(화면에 방금전, 몇분전, 몇시간전 이렇게 뜨게 하기위해 )
	
	/**
     * 상대 시간을 설정하는 메서드
     */
    public void setRelativeTime() {
        this.relativeTime = DateTimeUtil.calculateRelativeTime(this.createDt);
    }
    
    // "시 구"만 반환하는 메서드
    public String getCityAndDistrict() {
        if (prodPlace == null || prodPlace.isEmpty()) {
            return "알 수 없음"; // 주소가 없을 경우 기본값 반환
        }

        // 정규식: 첫 번째 단어(띄어쓰기 전)와 두 번째 단어(띄어쓰기 후 첫 단어) 추출
        Pattern pattern = Pattern.compile("^(\\S+)\\s+(\\S+)");
        Matcher matcher = pattern.matcher(prodPlace);
        if (matcher.find()) {
            return matcher.group(1) + " " + matcher.group(2); // 앞의 단어와 뒤의 단어를 반환
        }

        return prodPlace; // 매칭되지 않을 경우 원래 값 반환
    }
    
    // 천 단위 콤마 추가된 가격 반환
    public String getFormattedPrice() {
        return NumberFormat.getNumberInstance(Locale.KOREA).format(prodPrice);
    }
    
	
	
}
