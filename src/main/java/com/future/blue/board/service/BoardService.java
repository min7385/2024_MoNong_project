// 게시판 비즈니스 로직 

package com.future.blue.board.service;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.board.dao.BoardDAO;
import com.future.blue.board.vo.BoardVO;
import com.future.blue.board.vo.SearchVO;
import com.future.blue.common.web.FileController;

@Service
public class BoardService {

	// Repository 주입 (DB에서 데이터를 조회)
	@Autowired
	private BoardDAO boardDAO;
	
	@Autowired
	private FileController fileController; // FileController 사용

	// 게시글 목록 조회
    public List<BoardVO> getBoardList(SearchVO searchVO) {
    	// 전체 건수 조회
		int totalRowCount = boardDAO.getTotalCount(searchVO);
		searchVO.setTotalRowCount(totalRowCount);
		// 검색 조건으로 검색된 전체 건수를 기준으로 세팅!
		searchVO.pageSetting();  
        return boardDAO.getBoardList(searchVO);
    }
    
    // 게시글 상세 조회 + 조회수 증가
    @Transactional
    public BoardVO getBoardDetail(int boardId) {
        try {
        	int updateCount = boardDAO.increaseBoardHit(boardId); // 조회수 증가
        	if (updateCount == 0) {
                throw new RuntimeException("조회수 증가에 실패했습니다.");
            }

            // 게시글 상세 조회
            BoardVO boardVO = boardDAO.getBoardDetail(boardId);
            if (boardVO == null) {
                throw new RuntimeException("게시글을 찾을 수 없습니다.");
            }

            return boardVO;
        } catch (DataAccessException e) {
            throw new RuntimeException("게시글 상세 조회 중 데이터베이스 오류 발생", e);
        } catch (Exception e) {
            throw new RuntimeException("게시글 상세 조회 처리 중 오류 발생", e);
        }
    }
    
	// 게시글 작성
	public int createBoard(BoardVO board) {
		try {
            return boardDAO.createBoard(board);
        } catch (DataAccessException e) {
            throw new RuntimeException("게시글 작성 중 오류 발생", e);
        }
    }
	
	@Value("${file.upload-dir}")
    private String filePath;
	
	/**
     * 게시글 저장 (파일 포함)
     * @param boardVO 게시글 정보
     * @param file 업로드된 파일
     * @throws IOException 파일 업로드 중 오류가 발생한 경우
     */
    @Transactional
    public void saveBoard(BoardVO boardVO, MultipartFile file) throws IOException {
        // 1. 게시글 정보 저장
        boardDAO.createBoard(boardVO);

        // 2. 파일 처리 (파일 있을 경우)
        if (file != null && !file.isEmpty()) {
            // 파일 저장
            String uploadedFilePath = fileController.uploadSingleFile(file);

            // 파일 정보 설정
            boardVO.setBoardId(boardVO.getBoardId()); // 방금 저장된 게시글 ID 설정
            boardVO.setFilePath(uploadedFilePath);    // 파일 경로 설정
            boardVO.setFileName(file.getOriginalFilename()); // 파일 이름 설정

            // 파일 정보 DB 저장
            boardDAO.addBoardFile(boardVO);
        }
    }
	
	// 게시글 저장(파일 없이)
	public void saveBoard(BoardVO boardVO) throws IOException {
        saveBoard(boardVO, null); // 파일 없이 호출 시 null 전달
    }
		
	// 게시글 수정
	@Transactional
	public int updateBoard(BoardVO board) {
	    try {
	        return boardDAO.updateBoard(board);
	    } catch (DataAccessException e) {
	        throw new RuntimeException("게시글 수정 중 오류 발생", e);
	    }
	}

	// 게시글 삭제
	public int deleteBoard(int boardId) {
		try {
            return boardDAO.deleteBoard(boardId);
        } catch (DataAccessException e) {
            throw new RuntimeException("게시글 삭제 중 오류 발생", e);
        }
    }

	// 댓글 추가
	public void addComment(BoardVO comments) {
        try {
            boardDAO.addComment(comments);
        } catch (DataAccessException e) {
            throw new RuntimeException("댓글 작성 중 오류 발생", e);
        }
    }

	// 특정 게시글의 댓글 목록 조회
	public List<BoardVO> getComments(int boardId) {
		try {
            return boardDAO.getComments(boardId);
        } catch (DataAccessException e) {
            throw new RuntimeException("댓글 목록 조회 중 오류 발생", e);
        }
    }

	// 댓글 삭제
	public int deleteComment(int commentId) {
		try {
            return boardDAO.deleteComment(commentId);
        } catch (DataAccessException e) {
            throw new RuntimeException("댓글 삭제 중 오류 발생", e);
        }
    }

	// 좋아요 추가
	public int addLike(BoardVO likeId) {
		try {
            return boardDAO.addLike(likeId);
        } catch (DataAccessException e) {
            throw new RuntimeException("좋아요 추가 중 오류 발생", e);
        }
    }

	// 좋아요 제거
    @Transactional
    public void likeCencel(BoardVO likeId) {
        try {
            boardDAO.likeCencel(likeId);
        } catch (DataAccessException e) {
            throw new RuntimeException("좋아요 제거 중 오류 발생", e);
        }
    }

    // 좋아요 수 조회
    public int getboardLike(int boardId) {
        return boardDAO.getLikeCount(boardId);
    }
    
    public BoardVO getBoardById(int boardId) {
        return boardDAO.selectBoardById(boardId); // DAO에서 게시글 정보 가져오기
    }

	// 특정 사용자가 게시글에 좋아요를 눌렀는지 확인
	/*
	 * public int isLikedByUser(int boardId, String memId) { try { return
	 * boardDAO.getLikeCount(boardId, memId); } catch (DataAccessException e) {
	 * throw new RuntimeException("좋아요 여부 확인 중 오류 발생", e); }
	 * 
	 * }
	 */
}
