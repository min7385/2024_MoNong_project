package com.future.blue.diary.service;

import com.future.blue.diary.dao.IDiaryCommentDAO;
import com.future.blue.diary.vo.CommentVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentService {

    @Autowired
    private IDiaryCommentDAO diaryCommentDAO;

    // 1. 특정 diary에 대한 모든 댓글 목록을 가져오기
    public List<CommentVO> getCommentsByDiaryId(int diaryId) {
        List<CommentVO> comments = diaryCommentDAO.getCommentsByDiaryId(diaryId);
        return (comments != null) ? comments : new ArrayList<>();
    }

    // 2. 댓글 생성
    public List<CommentVO> createComment(int diaryId, String memId, String commentContent, Integer parentCommentId) {
        System.out.println("3차");

        // parentCommentId가 null이면 DB에 null로 들어감
        int result = diaryCommentDAO.insertComment(diaryId, memId, commentContent, parentCommentId);
        if (result > 0) {
            // 댓글 생성 성공 시, 해당 다이어리의 댓글 목록을 다시 조회
            return diaryCommentDAO.getCommentsByDiaryId(diaryId);
        }
        System.out.println("4차");
        return null;
    }

    // 3. 댓글 삭제 (USE_YN = 'N'으로 업데이트)
    public List<CommentVO> deleteComment(int commentId) {
        int result = diaryCommentDAO.deleteComment(commentId);
        if (result > 0) {
            // 삭제된 댓글이 어떤 diaryId에 속했는지 찾아서 목록을 가져와야 하지만,
            // 여기서는 간단히 commentId를 diaryId처럼 쓰고 있음(주의 요망).
            return diaryCommentDAO.getCommentsByDiaryId(commentId);
        }
        return null;
    }

    // 4. 댓글 수정
    public List<CommentVO> updateComment(int commentId, String commentContent) {
        int result = diaryCommentDAO.updateComment(commentId, commentContent);
        if (result > 0) {
            // 수정된 댓글이 어떤 diaryId에 속했는지 찾아서 목록을 가져와야 하지만,
            // 여기서는 간단히 commentId를 diaryId처럼 쓰고 있음(주의 요망).
            return diaryCommentDAO.getCommentsByDiaryId(commentId);
        }
        return null;
    }
}
