package com.future.blue.diary.dao;

import com.future.blue.diary.vo.CommentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IDiaryCommentDAO {

    // 1. 특정 diary에 대한 모든 댓글 목록을 가져오기
    List<CommentVO> getCommentsByDiaryId(@Param("diaryId") int diaryId);

    // 2. 댓글 생성 (parentCommentId가 null 가능)
    int insertComment(@Param("diaryId") int diaryId,
                      @Param("memId") String memId,
                      @Param("commentContent") String commentContent,
                      @Param("parentCommentId") Integer parentCommentId);

    // 3. 댓글 삭제 (USE_YN = 'N')
    int deleteComment(@Param("commentId") int commentId);

    // 4. 댓글 수정
    int updateComment(@Param("commentId") int commentId,
                      @Param("commentContent") String commentContent);
}
