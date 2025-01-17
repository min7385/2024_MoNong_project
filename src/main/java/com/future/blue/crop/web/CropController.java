package com.future.blue.crop.web;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.future.blue.crop.service.CropService;
import com.future.blue.crop.vo.CropVO;


@Controller
@RequestMapping("/crop")
public class CropController {
	
	@Autowired
	CropService cropService;

	@RequestMapping("/list")
	public String boardView(Model model) {

		ArrayList<CropVO> boardList = cropService.getBoardList();
		// Model은 spring에서 컨트롤러와 뷰 사이의 데이터를 전달하기 위한 인터페이스
		// Model객체에 추가하면 뷰에서 데이터를 사용할 수 있음.		
		model.addAttribute("boardList", boardList);
		
		return "board/crop/list";
	}
	
	@RequestMapping("detail")
    public String getBoardDetail(@RequestParam("id") int boardId, Model model) {
        try {
            CropVO crop = cropService.getBoard(boardId); // 서비스에서 게시글 조회
            model.addAttribute("board", crop); // 모델에 게시글 정보 추가
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage()); // 오류 메시지 전달
            return "errorPage"; // 오류 페이지로 이동
        }
        return "board/crop/detail"; // 게시글 상세 페이지로 포워딩
    }
	
	@RequestMapping("/create")
	public String boardWriteView(HttpSession session) {
	    if (session.getAttribute("login") == null) {
	        return "redirect:/loginView";
	    }
	    return "board/crop/create";
	}

	
	@PostMapping("/createDo")
	public String boardWriteDo(CropVO board) throws Exception {
	    cropService.writeBoard(board);
	    return "redirect:/crop/list";
	}

	
	@PostMapping("/edit")
	public String boardEditView(@RequestParam("boardId") int boardId, Model model) throws Exception {
	    CropVO board = cropService.getBoard(boardId);
	    model.addAttribute("board", board);
	    return "board/crop/edit";
	}

	
	@PostMapping("/boardEditDo")
	public String boardEditDo(CropVO board) throws Exception {
	    cropService.updateBoard(board);
	    return "redirect:/crop/list";
	}


}
