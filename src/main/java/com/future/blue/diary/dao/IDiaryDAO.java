package com.future.blue.diary.dao;

import com.future.blue.diary.vo.DiaryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IDiaryDAO {

	// 다이어리 생성
	DiaryVO createDiary(DiaryVO diaryVO);

	// 다이어리 삭제 (USE_YN을 'N'으로 변경)
	void deleteDiary(int diaryId);

	// 다이어리 수정
	void updateDiary(DiaryVO diaryVO);

	// 다이어리 조회 (아이디로 조회)
	DiaryVO selectDiaryById(int diaryId);

	// 다이어리 조회수 증가
	void incrementDiaryHit(int diaryId);

	// 다이어리 목록 조회 (페이지네이션 + 검색 + 정렬)
	List<DiaryVO> selectDiaryList(Map<String, Object> params);

	// 다이어리 개수 조회 (검색 포함)
	int selectDiaryCount(Map<String, Object> params);

	// 다이어리에 좋아요 추가
	void insertLike(@Param("diaryId") int diaryId, @Param("memId") String memId);

	// 좋아요 취소 (좋아요 삭제)
	void deleteLike(@Param("diaryId") int diaryId, @Param("memId") String memId);

	// 다이어리 좋아요 목록 조회 (사용자 목록)
	List<String> selectLikes(int diaryId);
}
