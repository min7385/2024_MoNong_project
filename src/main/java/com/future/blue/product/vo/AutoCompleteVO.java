package com.future.blue.product.vo;

import lombok.Data;

@Data
public class AutoCompleteVO {
	
    private int acId;
    private String cropType;
    private String saleTitle;
    private String saleContent;
    private int popularity;
    private String createDt;
    private String updateDt;
    private String useYn;

}
