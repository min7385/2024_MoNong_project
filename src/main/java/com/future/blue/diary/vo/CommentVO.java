package com.future.blue.diary.vo;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class CommentVO {

    private int commentId;          // 댓글 ID (PK)
    private int diaryId;            // 게시글(다이어리) ID
    private String commentContent;  // 댓글 내용
    private Timestamp createDt;     // 댓글 생성일
    private Timestamp updateDt;     // 댓글 수정일
    private Integer parentCommentId; // 부모 댓글 ID (없으면 null)
    private char useYn;             // 댓글 사용 여부 (Y: 사용, N: 삭제)
    private String memId;           // 댓글 작성자 ID (회원 아이디)
    
    public String getUseYnStr() {
        return String.valueOf(useYn);
    }
}
