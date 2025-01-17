package com.future.blue.product.vo;

import lombok.Data;

@Data
public class CropQualityVO {
	
	private String cropNameGpt;   // auto_complete와 맞추기 위함
	private String cropNameKr;    // 한글 품목명
	private String quality;       // 품질 등급 (L, M, S)
	private String qualityDesc;   // 품질 설명 (상, 중, 하)

}
