// 게시판 관련 데이터 저장

package com.future.blue.board.vo;

import java.util.Arrays;
import java.util.List;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import lombok.Data;

	@Data
    public class BoardVO {
    	@NotBlank(message = "제목을 입력하세요.")
        @Size(max = 100, message = "제목은 100자를 넘을 수 없습니다.")
        private String boardTitle;	   		// 제목

        @NotBlank(message = "내용을 입력하세요.")
        private String boardContents;  		// 내용

        private int boardId;           		// 게시판 ID (넘버)
        private String boardCategory;  		// 게시판 카테고리
        private String boardWriter;    		// 글쓴이
        private String boardPass;      		// 비밀번호
        private String createDt;       		// 생성일
        private String updateDt;       		// 수정일
        private String memId;          		// 회원 ID
        private int boardHit;          		// 조회수
        private int boardLike;         		// 좋아요수
        private String useYn;          		// 사용여부
        private String fileName;       		// 파일명
        private String filePath; 	   		// 파일 경로 저장
        private int fileId;            		// 파일 넘버
        private List<BoardVO> files;        // 파일 목록
        private int commentId;         		// 댓글 넘버
        private String commentContent; 		// 댓글 내용
        private int parentCommentId;   		// 부모 댓글(대댓글)
        private List<BoardVO> comments; 	// 댓글 목록 
        private int likeId;           		// 좋아요 넘버
        private String likeMemId;    		// 좋아요 클릭한 회원 ID
        
        
        // 공통 상수 선언(유틸리티 클래스에서 관리) / 값이 'Y' or 'N'으로 제한되어 있기 떄문에 상수로 관리.
        /** 유틸리티 클래스란? 
         *  비슷한 기능의 메서드와 상수를 모아서 캡슐화 한 것.
         *  사용 이유는 static method는  따로 객체 만들지 않고 바로 클래스로 메서드 호출 가능
         *  but 오직  static 변수만 접근 가능함
         *  그래서 유틸리티 사용
         * */
        public static final String USE_YES = "Y";
        public static final String USE_NO = "N";
        
        
        /** Getters / Setters 메소드
         *  메소드를 통해 데이터 접근 유도.
         *  오브젝트 내의 함수들을 괄호없이 쓸 수 있게 만들어 줌.
         *  결론: 데이터의 무결성 보존을 위해 사용.
         *  get: 데이터 가져옴 / set: 데이터 입력, 수정
         *  ** 규칙 **
         *  get: 파라미터 x, 함수 내에 return
         *  set: 파라미터 존재
         * **/
        public int getFileId() {
            return fileId;
        }

        public void setFileId(int fileId) {
            this.fileId = fileId;
        }
        
        public int getBoardId() {              // getter
            return boardId;
        }

        public void setBoardId(int boardId) {  // setter
            this.boardId = boardId;
        }

        public void setBoardCategory(String boardCategory) {
            this.boardCategory = boardCategory;
        }
        
        // boardCategory 값이 유효한지 확인. ex)허용된 카테고리만 저장
        // 카테고리 유효성 검사
        public boolean isValidCategory() {
            String[] validCategories = {"free", "crop", "diary"};
            return Arrays.asList(validCategories).contains(boardCategory);
        }
        
        // 게시글 목록에서 간단한 내용 요약을 보여줌
        public String getSummary(int length) {
            if (boardContents == null || boardContents.length() <= length) {
                return boardContents; // 내용이 짧으면 그대로 반환
            }
            return boardContents.substring(0, length) + "..."; // 지정 길이만큼 잘라 반환
        }

        // 글쓴이
        public String getBoardWriter() {
            return boardWriter;
        }

        public void setBoardWriter(String boardWriter) {
            this.boardWriter = boardWriter;
        }
        
        // 회원 ID
        public String getMemId() {
            return memId;
        }

        public void setMemId(String memId) {
            this.memId = memId;
        }
        
        // 제목
        public String getBoardTitle() {
            return boardTitle;
        }

        public void setBoardTitle(String boardTitle) {
            this.boardTitle = boardTitle;
        }
        
        // 내용        
        public String getBoardContents() {
            return boardContents;
        }

        public void setBoardContents(String boardContents) {
            this.boardContents = boardContents;
        }

        // 비밀번호
        public String getBoardPass() {
            return boardPass;
        }

        public void setBoardPass(String boardPass) {
            this.boardPass = boardPass;
        }
        
        public String getFileName() {
            return fileName;
        }

        public void setFileName(String fileName) {
            this.fileName = fileName;
        }
        
        // 파일 경로 저장
        public String getFilePath() {
            return filePath;
        }

        public void setFilePath(String filePath) {
            this.filePath = filePath;
        }
        
        //  파일 이름 추출
        public String getImageFileName() {
            if (this.filePath != null && !this.filePath.isEmpty()) {
                // 파일 경로에서 파일명만 추출
                String[] parts = this.filePath.split("/");
                return parts[parts.length - 1];
            }
            return null;  // 파일 경로가 없으면 null 반환
        }
        
        // 유효성 검사: 잘못된 파일 경로가 저장되지 않도록 해줌. 
        // 파일 경로 유효성 검사
        public boolean isValidFilePath() {
            return filePath != null && filePath.matches("^([a-zA-Z]:)?(\\\\[a-zA-Z0-9_-]+)+\\\\?$");
        }

        // 파일명 유효성 검사
        public boolean isValidFileName() {
            return fileName != null && fileName.matches("^[\\w,\\s-]+\\.[A-Za-z]{3,4}$");
        }
        
        // 조회수
        public int getBoardHit() {
            return boardHit;
        }

        public void setBoardHit(int boardHit) {
            this.boardHit = boardHit;
        }
        
        // 좋아요
        public int getBoardLike() {
            return boardLike;
        }

        public void setBoardLike(int boardLike) {
            this.boardLike = boardLike;
        }
        
        public int getLikeId() {
            return likeId;
        }

        public void setLikeId(int likeId) {
            this.likeId = likeId;
        }

        public String getLikeMemId() {
            return likeMemId;
        }

        public void setLikeMemId(String likeMemId) {
            this.likeMemId = likeMemId;
        }
        
        // commentId -> 댓글 좋아요인지 게시글 좋아요인지 구분
        // 댓글 좋아요 여부 확인
        public boolean isCommentLike() {
            return commentId > 0; // 0보다 크면 댓글 좋아요
        }

        // 게시글 좋아요 여부 확인
        public boolean isBoardLike() {
            return commentId == 0; // 0이면 게시글 좋아요
        }
        
        // 사용여부 
        public String getUseYn() {
            return useYn;
        }

        public void setUseYn(String useYn) {
            this.useYn = useYn;
        }
        
        // 댓글
        public List<BoardVO> getComments() {
            return comments;
        }

        public void setComments(List<BoardVO> comments) {
            this.comments = comments;
        }
        
        @Override
        public String toString() {
            return "댓글 번호: " + commentId + ", 내용: " + commentContent + ", 작성자: " + memId + ", 작성일: " + createDt;
        }

        public List<BoardVO> getFiles() {
            return files;
        }

        public void setFiles(List<BoardVO> files) {
            this.files = files;
        }
       
    }