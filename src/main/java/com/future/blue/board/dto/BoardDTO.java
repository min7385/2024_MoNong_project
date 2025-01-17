// 게시글 전송 

/**
 * DAO, DTO 차이
 * DAO : 데이터베이스 데이터 처리. (상호작용)
 * DTO : 데이터를 클라이언트나 다른 계층으로 전달함. (데이터 전송)
 * **/

package com.future.blue.board.dto;	// 

public class BoardDTO {
    private int boardId;
    private String boardWriter;
    private String boardTitle;
	private String boardContents;
    
    
    /** Getters / Setters 메소드
     *  메소드를 통해 데이터 접근 유도.
     *  오브젝트 내의 함수들을 괄호없이 쓸 수 있게 만들어 줌.
     *  결론: 데이터의 무결성 보존을 위해 사용.
     *  get: 데이터 가져옴 / set: 데이터 입력, 수정
     *  ** 규칙 **
     *  get: 파라미터 x, 함수 내에 return
     *  set: 파라미터 존재
     * **/
    public int getBoardId() {
        return boardId;
    }
    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getBoardTitle() {
        return boardTitle;
    }

    public void setBoardTitle(String boardTitle) {
        this.boardTitle = boardTitle;
    }

    public String getBoardWriter() {
        return boardWriter;
    }

    public void setBoardWriter(String boardWriter) {
        this.boardWriter = boardWriter;
    }

    public String getBoardContents() {
        return boardContents;
    }

    public void setBoardContents(String boardContents) {
        this.boardContents = boardContents;
    }
}