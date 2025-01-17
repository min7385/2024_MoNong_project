// 게시판 컨트롤러
// 클라이언트 요청을 처리

package com.future.blue.board.web;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.future.blue.board.service.BoardService;
import com.future.blue.board.vo.BoardVO;
import com.future.blue.board.vo.SearchVO;



/** @Controller vs @RestController(요즘)
 *  Controller의 두 종류.
 *  @Controller : view 값을 바로 끌고 옴. ex) HTML
 *  @RestController : Json 타입으로 값을 반환. -> 프론트에서 재가공.
 */
@Controller
@RequestMapping("/board")
public class BoardController {

	@Value("#{util['file.upload.path']}")
    private String CURR_IMAGE_PATH;
	
	@Value("${file.upload-dir}")
    private String uploadDir;
	
	// 서비스 클래스 주입 (DB에서 게시글 정보를 가져오기 위해)
    @Autowired
    private BoardService boardService;

    // 게시글 목록 조회
    @RequestMapping("/list")
    public String getBoardList(@ModelAttribute("searchVO") SearchVO searchVO, Model model) {
        List<BoardVO> boardList = boardService.getBoardList(searchVO);
        model.addAttribute("boardList", boardList);
        return "board/free/list";
    }
    
    // 게시글 상세 조회
    @GetMapping("/detail")
    public String detail(int boardId, Model model) {
    	
        // 서비스 호출. 게시글 상세 정보 가져오기
    	BoardVO boardVO = boardService.getBoardDetail(boardId);
    	
    	if (boardVO  == null) {
            return "error/404"; // 존재하지 않는 게시글 처리
        }
    	
    	// 댓글 목록 조회
    	List<BoardVO> comments = boardService.getComments(boardId);  
    	
    	// 게시글, 댓글 모델에 추가
        model.addAttribute("board", boardVO );
        model.addAttribute("memId", boardVO.getBoardWriter()); // 작성자 추가
        model.addAttribute("comments", comments);
        
        return "board/free/detail";	
    }

    // 게시글 작성 페이지
    @GetMapping("/create")
    public String createBoardForm() {
        return "board/free/create";
    }

    // 게시글 작성 처리
    @PostMapping("/create")
    public String createBoard(@ModelAttribute BoardVO board) {
    	// 작성자 정보를 클라이언트에서 전달받아 사용
    	// 게시글 작성 처리
        boardService.createBoard(board);
        return "redirect:/board/list";
    }
    
    // 게시글 저장 (파일 있을 시)
    @PostMapping("/save")
    public String saveBoard(@ModelAttribute BoardVO boardVO,
    						@RequestParam(required = false) MultipartFile file,
    						RedirectAttributes redirectAttributes) throws IOException {
        // 게시글 저장
        boardService.saveBoard(boardVO, file);	
        
        // 저장 후 게시글 목록으로 이동
        redirectAttributes.addFlashAttribute("board", boardVO);
        return "redirect:/board/list";  // 게시글 목록 페이지로 리다이렉트
    }
     
    // 게시글 수정 페이지
    @GetMapping("/edit/{boardId}")
    public String editBoardForm(@PathVariable int boardId, Model model) {
    	// 서비스 호출
        BoardVO board = boardService.getBoardById(boardId);
        if (board == null) {
            return "error/404"; // 게시글 없는 경우
        }
        model.addAttribute("board", board); // 모델에 게시글 정보 추가
        return "board/free/edit"; // 수정 페이지로 리턴
    }

    // 게시글 수정 처리
    @PostMapping("/edit")
    public String editBoard(@ModelAttribute BoardVO board) {
    	// 서비스 호출
    	int result = boardService.updateBoard(board);
        if (result == 0) {
    		return "error/404"; // 수정 실패 시
        }
        // 수정 시 게시글 상세 페이지로 리다이렉트
    	return "redirect:/board/detail/" + board.getBoardId();
    }

	// 게시글 삭제
	@GetMapping("/delete") 
	public String deleteBoard(@PathVariable int boardId) {
		int result = boardService.deleteBoard(boardId);
        if (result == 0) {
            return "error/404"; 
        }
        return "redirect:/board/free/list"; 
	}
	// 댓글 작성
	@ResponseBody
	@PostMapping("/comment")
    public BoardVO addComment(BoardVO comments) {
		
        boardService.addComment(comments);
        return comments;
        
    }

        
	// 좋아요 클릭(추가)
	@PostMapping("/addLike")
    public ResponseEntity<String> addLikes(@RequestBody BoardVO like) {
        boardService.addLike(like);
        return ResponseEntity.ok("${board.memId}님이 게시물을 좋아합니다.");
    }

    // 좋아요 제거
    @PostMapping("/likeCencel")
    public ResponseEntity<String> likeCencel(@RequestBody BoardVO like) {
        boardService.likeCencel(like);
        return ResponseEntity.ok("${board.memId}님이 게시물 좋아요를  취소합니다.");
    }
    
    
}
