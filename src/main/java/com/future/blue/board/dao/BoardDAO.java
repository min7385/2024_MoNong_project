/**
 * DAO, DTO 차이
 * DAO → 데이터베이스 데이터 처리. (상호작용)
 * DTO → 데이터를 클라이언트나 다른 계층으로 전달함. (데이터 전송) **/

package com.future.blue.board.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.dao.DataAccessException;

import com.future.blue.board.vo.BoardVO;
import com.future.blue.board.vo.SearchVO;


@Mapper
public interface BoardDAO {
	
	//게시글 관련 메서드
	
	public List<BoardVO> getBoardList(SearchVO searchVO);
    /**
     * 게시글 목록 조회 
     * @param searchVO 검색 조건
     * @return 게시글 목록
     */
    List<BoardVO> getBoardListPaged(SearchVO searchVO) throws DataAccessException;  // 게시글 목록 조회

    /**
     * 게시글 상세 조회
     * @param boardId 게시글 ID
     * @return 게시글 상세 정보
     */
    BoardVO getBoardDetail(int boardId);  // 게시글 상세 조회
    
    /**
     * 특정 사용자의 게시글 목록 조회
     * @param memId 사용자 ID
     * @return 사용자 게시글 목록
     */
    List<BoardVO> getUserBoards(@Param("memId") String memId) throws DataAccessException;
    
    /**
     * 특정 카테고리의 게시글 목록 조회
     * @param category 카테고리 이름
     * @return 카테고리별 게시글 목록
     */
    List<BoardVO> getBoardsByCategory(@Param("category") String category) throws DataAccessException;
    
    /**
     * 특정 기간 내 작성된 게시글 목록 조회
     * @param startDate 시작일
     * @param endDate 종료일
     * @return 기간별 게시글 목록
     */
    List<BoardVO> getBoardsByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate) throws DataAccessException;
    
    /**
     * 게시글 작성
     * @param board 게시글 정보
     * @return 생성된 게시글의 ID
     */
    int createBoard(BoardVO board) throws DataAccessException;  // 게시글 작성
    
    /**
     * 게시글 수정
     * @param board 수정된 게시글 정보
     * @return 수정된 행 수
     */
    int updateBoard(BoardVO board);  // 게시글 수정
    
    /**
     * 게시글 삭제
     * @param boardId 삭제할 게시글 ID
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int deleteBoard(int boardId);  // 게시글 삭제

    /**
     * 게시글 조회수 증가
     * @param boardId 게시글 ID
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int increaseBoardHit(int boardId);  // 조회수 증가

    /**
     * 게시글 총 개수 조회 (검색 조건 반영)
     * @param searchVO 검색 조건
     * @return 총 게시글 개수
     */
    int getTotalCount(SearchVO searchVO) throws DataAccessException;  // 게시글 총 개수

    
    // 파일 처리 관련 메서드

    /**
     * 파일 추가
     * @param file 추가할 파일 정보
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int addBoardFile(BoardVO file);  // 파일 추가

    /**
     * 특정 게시글의 파일 목록 조회
     * @param boardId 게시글 ID
     * @return 파일 목록
     */
    List<BoardVO> getBoardFiles(int boardId) throws DataAccessException;  // 파일 목록 조회

    
    // 댓글 처리 관련 메서드
    
    /**
     * 댓글 추가
     * @param comment 댓글 정보
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int addComment(BoardVO comments) throws DataAccessException;  // 댓글 작성

    /**
     * 특정 게시글의 댓글 목록 조회
     * @param boardId 게시글 ID
     * @return 댓글 목록
     */
    List<BoardVO> getComments(int boardId) throws DataAccessException;  // 댓글 목록 조회

    /**
     * 댓글 삭제
     * @param commentId 삭제할 댓글 ID
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int deleteComment(int commentId) throws DataAccessException;  // 댓글 삭제

    
    // 좋아요 처리 관련 메서드
    
    /**
     * 좋아요 추가
     * @param like 좋아요 정보
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int addLike(BoardVO likeId);  // 좋아요 추가

    /**
     * 좋아요 제거
     * @param like 좋아요 정보
     * @return 성공 여부 (1: 성공, 0: 실패)
     */
    int likeCencel(BoardVO likeId);  // 좋아요 제거

    /**
     * 특정 게시글의 좋아요 수 조회
     * @param boardId 게시글 ID
     * @return 좋아요 개수
     */
    int getLikeCount(int boardId);  // 좋아요 수 조회
    
    //
    BoardVO selectBoardById(int boardId);
    
}

