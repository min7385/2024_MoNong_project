package com.future.blue.diary.web;

import com.future.blue.diary.service.CommentService;
import com.future.blue.diary.service.DiaryService;
import com.future.blue.diary.vo.CommentVO;
import com.future.blue.diary.vo.DiaryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/diary")
public class DiaryController {

	@Autowired
	private DiaryService diaryService;
    @Autowired
    private CommentService commentService;
	// 다이어리 생성 화면
	@GetMapping("/create")
	public String createDiary() {
		return "board/diary/create"; // /WEB-INF/views/board/diary/create.jsp
	}

	@PostMapping("/write")
	public String writeDiary(@RequestParam String title, @RequestParam String content,
			@RequestParam(required = false) String diaryImage, @RequestParam String memId,
			@RequestParam String diaryWriter) {
		// 로그 추가
		System.out.println("Received title: " + title);
		System.out.println("Received content: " + content);
		System.out.println("Received diaryImage: " + diaryImage);
		System.out.println("Received memId: " + memId);
		System.out.println("Received diaryWriter: " + diaryWriter);

		DiaryVO diary = new DiaryVO();
		diary.setDiaryTitle(title);
		diary.setDiaryContents(content);
		diary.setDiaryImage(diaryImage); // 이미지 URL
		diary.setMemId(memId); // 작성자 ID
		diary.setDiaryWriter(diaryWriter); // 작성자 이름

		System.out.println("Diary Object: " + diary);

		try {
			// 다이어리 저장 서비스 호출 (DB 저장)
			diaryService.createDiary(diary);

			// 무조건 목록 페이지로 리다이렉트
			return "redirect:/diary/list";
		} catch (Exception e) {
			// 오류가 발생하면 다이어리 목록 페이지로 리다이렉트
			return "redirect:/diary/list";
		}
	}

	// 다이어리 수정 화면
	@GetMapping("/edit/{diaryId}")
	public String editDiary(@PathVariable int diaryId, Model model) {
		// 다이어리 조회 후 수정 화면으로 전달
		DiaryVO diary = diaryService.getDiaryById(diaryId);
		model.addAttribute("diary", diary); // 다이어리 수정 화면으로 전달
		return "board/diary/edit"; // /WEB-INF/views/board/diary/edit.jsp
	}

	@PostMapping("/update")
	public String updateDiary(@ModelAttribute DiaryVO diaryVO) {
		try {
			// 수정된 다이어리 정보 저장 (DB 업데이트)
			diaryService.updateDiary(diaryVO);

			// 수정된 게시글의 상세 페이지로 리다이렉트
			return "redirect:/diary/detail/" + diaryVO.getDiaryId(); // 수정된 다이어리 상세 페이지로 리다이렉트
		} catch (Exception e) {
			// 오류가 발생하면 다이어리 목록 페이지로 리다이렉트
			return "redirect:/diary/list";
		}
	}

	@GetMapping("/detail/{diaryId}")
	public String viewDiary(@PathVariable int diaryId, Model model) {
		try {
			// 다이어리 조회수 증가
			diaryService.incrementHit(diaryId);

			// 다이어리 조회
			DiaryVO diary = diaryService.getDiaryById(diaryId);

			if (diary == null) {
				// 다이어리가 없을 경우 빈 값을 전달
				diary = new DiaryVO(); // 빈 다이어리 객체로 처리
				model.addAttribute("diary", diary);
				model.addAttribute("likesList", new ArrayList<>()); // 빈 리스트 전달
				model.addAttribute("commentsList", new ArrayList<>()); // 빈 리스트 전달
				return "board/diary/detail"; // 다이어리 상세 페이지로 리턴
			}

			// 다이어리 좋아요 목록 조회
			List<String> likesList = diaryService.getLikesList(diaryId);
			if (likesList == null) {
				likesList = new ArrayList<>(); // 좋아요 목록이 없으면 빈 리스트로 처리
			}

			// 다이어리 댓글 목록 조회
			List<CommentVO> commentsList = commentService.getCommentsByDiaryId(diaryId);
			if (commentsList == null) {
				commentsList = new ArrayList<>(); // 댓글 목록이 없으면 빈 리스트로 처리
			}

			// 다이어리 상세 정보, 좋아요 목록, 댓글 목록을 화면으로 전달
			model.addAttribute("diary", diary);
			model.addAttribute("likesList", likesList);
			model.addAttribute("commentsList", commentsList);

			return "board/diary/detail"; // 다이어리 상세 페이지로 리턴
		} catch (Exception e) {
			// 예외 발생 시 로깅
			e.printStackTrace();
			model.addAttribute("error", "500");
			return "error/500"; // 500 오류 페이지로 리다이렉트
		}
	}

	// 다이어리 목록 화면 (페이지네이션, 정렬, 검색 처리)
	@GetMapping("/list")
	public String listDiaries(Model model, @RequestParam Map<String, Object> params) {
		// 기본값 처리
		if (params.get("sortBy") == null) {
			params.put("sortBy", "new"); // 기본값 'new' 설정
		}

		// 페이지네이션 관련 기본값 처리
		int currentPage = Integer.parseInt((String) params.getOrDefault("currentPage", "1"));
		// currentPage가 1보다 작으면 1로 설정
		if (currentPage < 1) {
			currentPage = 1;
		}

		int pageSize = 8; // 한 페이지에 8개 항목

		// 페이지네이션 계산
		int offset = (currentPage - 1) * pageSize;

		// 페이지네이션, 검색, 정렬을 포함한 다이어리 목록 조회
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		Map<String, Object> diaryListData = diaryService.getDiaryList(params);

		// 총 페이지 계산
		int totalCount = (int) diaryListData.get("totalCount");
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		// 모델에 다이어리 목록과 총 개수 등을 전달
		model.addAttribute("diaryList", diaryListData.get("list"));
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages); // 전체 페이지 수를 모델에 전달

		return "board/diary/list"; // /WEB-INF/views/board/diary/list.jsp
	}

	@PostMapping("/toggleLike")
	public @ResponseBody List<String> toggleLike(@RequestParam int diaryId, @RequestParam String memId) {
		// 좋아요 상태 변경
		diaryService.toggleLike(diaryId, memId);

		// 해당 다이어리의 최신 좋아요 목록을 반환
		List<String> updatedLikes = diaryService.getLikesList(diaryId);
		return updatedLikes;
	}
}
