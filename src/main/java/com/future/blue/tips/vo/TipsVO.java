package com.future.blue.tips.vo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import lombok.Data;

@Data
public class TipsVO {
    private int id;
    private String kind;
    private String startDate;
    private String endDate;
    private String cropStage;
    private String surveyRegion;
    private String surveyReason;
    private String growthCondition;
    private String pestDisease;
    private String memo;
    
    private String images;  // DB에서 가져온 이미지 문자열
    private List<String> imageList;  // 이미지 목록 (최종적으로 사용할 배열 형태)

    // DB에서 가져온 이미지 문자열을 List<String>으로 변환하는 메서드
    public void setImages(String images) {
        this.images = images;
        // DB에서 가져온 문자열을 ,로 분리하여 List<String>으로 변환
        if (images != null && !images.isEmpty()) {
            this.imageList = Arrays.asList(images.split(","));
        } else {
            this.imageList = new ArrayList<>();
        }
    }

    public List<String> getImageList() {
        // imageList가 비어 있으면 기본 이미지 처리
        if (imageList == null || imageList.isEmpty()) {
            imageList = List.of("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDfud37N0ENwzhgCv855dFsS_OGJPfX4CKYQ&s");
        }
        return imageList;
    }

    public void setImageList(List<String> imageList) {
        this.imageList = imageList;
        // imageList를 ,로 구분된 문자열로 변환해서 DB에 저장할 때 사용
        if (imageList != null && !imageList.isEmpty()) {
            this.images = String.join(",", imageList);
        }
    }
}
