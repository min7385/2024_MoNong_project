package com.future.blue.diary.web;

import com.future.blue.diary.service.CommentService;
import com.future.blue.diary.vo.CommentVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/diary/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;

    // 1. 특정 diary에 대한 모든 댓글 목록을 가져오기
    @GetMapping("/{diaryId}")
    @ResponseBody
    public List<CommentVO> getCommentsByDiaryId(@PathVariable int diaryId) {
        return commentService.getCommentsByDiaryId(diaryId);
    }

    // 2. 댓글 생성
    @PostMapping("/create")
    @ResponseBody
    public List<CommentVO> createComment(@RequestParam int diaryId,
                                         @RequestParam String memId,
                                         @RequestParam String commentContent,
                                         @RequestParam(required = false) String parentCommentId) {

        System.out.println("전달된 parentCommentId(String) = " + parentCommentId);

        // "null" 문자열이 오면 실제 null로 처리
        Integer parentId = null;
        if (parentCommentId != null && !"null".equals(parentCommentId.trim()) && !"".equals(parentCommentId.trim())) {
            // 숫자라면 parse, 아닐 시 예외 처리
            try {
                parentId = Integer.valueOf(parentCommentId);
            } catch (NumberFormatException e) {
                // 숫자가 아닌 값이 들어온 경우, 로그 남기거나 null 처리
                // e.printStackTrace();
                parentId = null;
            }
        }

        return commentService.createComment(diaryId, memId, commentContent, parentId);
    }


    // 3. 댓글 삭제
    @PostMapping("/delete")
    @ResponseBody
    public List<CommentVO> deleteComment(@RequestParam int commentId) {
        return commentService.deleteComment(commentId);
    }

    // 4. 댓글 수정
    @PostMapping("/update")
    @ResponseBody
    public List<CommentVO> updateComment(@RequestParam int commentId,
                                         @RequestParam String commentContent) {
        return commentService.updateComment(commentId, commentContent);
    }
}
