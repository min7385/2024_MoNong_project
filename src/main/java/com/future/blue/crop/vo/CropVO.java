package com.future.blue.crop.vo;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class CropVO {
    private int boardId;           // 게시판 넘버
    private String boardTitle;     // 제목
    private String boardContents;  // 내용
    private Timestamp createDt;    // 생성일
    private Timestamp updateDt;    // 수정일
    private String memId;          // 회원 ID
    private int boardHit;          // 조회수
    private String useYn;          // 사용여부
    private String id;			   // 농업기술 아이디
    private String content;         // 농업기술 내용
    private String title;			// 농업기술 주제
    private String truncatedTitle; // 잘린 제목
    private String firstImgTag;    // 첫 번째 이미지 태그
}
