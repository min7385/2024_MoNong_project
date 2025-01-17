<!-- 게시글 작성(글쓰기) -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>글쓰기</title>
        <style>
        /* container 스타일 */
        .container-board-write {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* 제목 스타일 */
        .board-write-title {
            color: #4CAF50;
            text-align: center;
        }

        /* input-group 스타일 */
        .input-group-board {
            margin-bottom: 15px;
        }

        .input-group-board label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .input-group-board input,
        .input-group-board textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .input-group-board textarea {
            resize: vertical;
            height: 150px;
        }

        /* 이미지 미리보기 */
        .image-preview-board {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 15px;
        }

        .image-preview-board img {
            width: 100%;
            max-width: 300px;
            margin: 10px 0;
            border-radius: 10px;
            border: 1px solid #ddd;
        }

        /* 버튼 그룹 */
        .button-group-board {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .button-group-board button {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            color: white;
            background-color: #4CAF50;
            cursor: pointer;
            font-size: 14px;
        }

        .button-group-board button.cancel {
            background-color: #f44336;
        }

        .button-group-board button:hover {
            background-color: #45a049;
        }

        .button-group-board button.cancel:hover {
            background-color: #d32f2f;
        }

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .input-group-board input,
            .input-group-board textarea {
                font-size: 12px;
                padding: 8px;
            }

            .button-group-board button {
                font-size: 12px;
                padding: 6px 10px;
            }

            .image-preview-board img {
                max-width: 200px;
            }
        }
    	</style>
	</head>
<body>

<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

	<div class="container-board-write">
	    <c:set var="boardWriter" value="${userInfo.memId}" />
	    <!-- 제목 -->
	    <h1 class="board-write-title">게시글 작성</h1>
	
	    <!-- 게시글 작성 폼 -->
	    <form id="createPostForm" action="${pageContext.request.contextPath}/board/save" method="post" enctype="multipart/form-data">
	        <!-- Hidden input for boardWriter -->
	        <input type="hidden" name="boardWriter" value="${boardWriter}">
	
	        <!-- 제목 입력 -->
	        <div class="input-group-board">
	            <label for="title">제목</label>
	            <input type="text" id="title" name="boardTitle" placeholder="제목을 입력하세요" value="${board.title}" required>
	        </div>
	
	        <!-- 사진 업로드 -->
	        <div class="input-group-board">
	            <label for="fileUpload">사진</label>
	            <input type="file" id="fileUpload" name="file" accept="image/*">
	            <div class="image-preview-board">
	                <p>사진 미리보기</p>
	                <img id="imagePreview" src="https://via.placeholder.com/300" alt="사진 미리보기">
	            </div>
	        </div>
	
	        <!-- 내용 입력 -->
	        <div class="input-group-board">
	            <label for="content">내용</label>
	            <textarea id="content" name="boardContents" placeholder="내용을 입력하세요" required>${board.content}</textarea>
	        </div>
	
	        <!-- 버튼 영역 -->
	        <div class="button-group-board">
	            <button type="submit" id="submitBtn">등록</button>
	            <button type="button" class="cancel" id="cancelBtn">취소</button>
	        </div>
	    </form>
	</div>

<script>
    // 작성 버튼 클릭 시 유효성 검증
    document.getElementById("submitBtn").addEventListener("click", function (event) {
        const title = document.getElementById("title").value.trim();
        const content = document.getElementById("content").value.trim();

        if (!title || !content) {
            event.preventDefault(); // 폼 전송 막음
            alert("제목과 내용을 모두 입력해주세요.");
        } else {
            const confirmSubmit = confirm("게시글을 등록하시겠습니까?");
            if (!confirmSubmit) {
                event.preventDefault(); // 사용자가 취소하면 폼 전송 막음
            }
        }
    });

    // 사진 업로드 미리보기
    document.getElementById("fileUpload").addEventListener("change", function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById("imagePreview").src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    // 취소 버튼 처리
    document.getElementById("cancelBtn").addEventListener("click", function () {
        if (confirm("작성을 취소하시겠습니까?")) {
            window.location.href = "${pageContext.request.contextPath}/board/free/list";
        }
    });
</script>

<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

</body>
</html>