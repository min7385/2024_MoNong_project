package com.future.blue.diary.vo;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class DiaryVO {
    private int diaryId;        // DIARY_ID
    private String diaryWriter; // DIARY_WRITER
    private String diaryTitle;  // DIARY_TITLE
    private String diaryContents; // DIARY_CONTENTS
    private Timestamp createDt; // CREATE_DT
    private Timestamp updateDt; // UPDATE_DT
    private String memId;       // MEM_ID
    private int diaryHit;       // DIARY_HIT
    private String useYn;       // USE_YN
    private String diaryImage;  // DIARY_IMAGE
    private int likeCount;      // 좋아요 개수 (추가된 필드)
}
