package com.future.blue.market.vo;

import lombok.Data;

@Data
public class MarketVO {
	
	private String prceRegYmd;
	private String pdltCode;
	private String pdltNm;
	private String spcsCode;
	private String spcsNm;
	private String pdltCtgCode;
	private String pdltCtgNm;
	private String avrgPrce;
	private String wsrtExmnSeCode;
	private String exmnSeNm;
	private String gradCode;
	private String gradNm;
	private String dsbnStepActoUnitNm;
	private String dsbnStepActoWt;
	private String tdyLwetPrce;
	private String tdyMaxPrce;
	private String etlLdgDt;
	private String pdltPath;
	private String predictedPrice;
	
}