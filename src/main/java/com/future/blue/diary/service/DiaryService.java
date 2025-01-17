package com.future.blue.diary.service;

import com.future.blue.diary.dao.IDiaryDAO;
import com.future.blue.diary.vo.DiaryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DiaryService {

	@Autowired
	private IDiaryDAO diaryDao;

	// 다이어리 생성
	public DiaryVO createDiary(DiaryVO diaryVO) {
		diaryDao.createDiary(diaryVO); // 다이어리 저장
		return diaryVO; // 생성된 diaryId가 포함된 DiaryVO 객체 반환
	}

	// 다이어리 삭제 (USE_YN을 'N'으로 변경)
	public void deleteDiary(int diaryId) {
		diaryDao.deleteDiary(diaryId);
	}

	// 다이어리 수정
	public void updateDiary(DiaryVO diaryVO) {
		diaryDao.updateDiary(diaryVO);
	}

	// 다이어리 조회
	public DiaryVO getDiaryById(int diaryId) {
		return diaryDao.selectDiaryById(diaryId);
	}

	// 다이어리 조회수 증가
	public void incrementHit(int diaryId) {
		diaryDao.incrementDiaryHit(diaryId);
	}

	// 다이어리 목록 조회
	public Map<String, Object> getDiaryList(Map<String, Object> params) {
		// 페이지네이션, 정렬, 검색 등을 처리
		int totalCount = diaryDao.selectDiaryCount(params);
		params.put("totalCount", totalCount);
		params.put("list", diaryDao.selectDiaryList(params));
		return params;
	}

	// 다이어리 좋아요 추가/취소
	public void toggleLike(int diaryId, String memId) {
	    // 다이어리 좋아요 목록 조회
	    List<String> likedUsers = diaryDao.selectLikes(diaryId);

	    // 좋아요 목록에 해당 사용자가 있으면 좋아요 취소 (삭제)
	    if (likedUsers.contains(memId)) {
	        diaryDao.deleteLike(diaryId, memId); // 좋아요 취소
	    } else {
	        diaryDao.insertLike(diaryId, memId); // 좋아요 추가
	    }
	}

	// 다이어리 좋아요 목록 조회 (사용자 목록)
	public List<String> getLikesList(int diaryId) {
	    return diaryDao.selectLikes(diaryId);
	}

	// 다이어리 좋아요 여부 체크
	public boolean isLikedByUser(int diaryId, String memId) {
		List<String> likedUsers = diaryDao.selectLikes(diaryId);
		return likedUsers.contains(memId);
	}

}
