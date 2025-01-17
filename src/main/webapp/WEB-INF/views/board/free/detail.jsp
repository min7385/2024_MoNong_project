<!-- 게시글 상세보기 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="utf-8">
	<meta content="width=device-width, initial-scale=1.0" name="viewport">
		<title>게시판 디테일 뷰</title>
		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
			<style>
				/* 댓글 입력 영역 */
				.reply-container {
					display: flex;
					gap: 10px;
					justify-content: space-between;
					width: 100%;
					/* 부모 요소의 너비를 꽉 채우도록 설정 */
					padding: 15px 0;
					/* 상하 패딩 추가 */
				}
				
				/* 댓글 입력창에 패딩을 추가 */
				.reply-input {
					width: 50%;
					/* 댓글 입력창 크기 조정 */
					padding: 10px;
					/* 패딩 추가 */
					border: 1px solid #ccc;
					/* 시각적으로 구분될 수 있게 테두리 추가 */
					border-radius: 5px;
					/* 라운딩 처리 */
					font-size: 1rem;
					/* 폰트 크기 조정 */
				}
				
				/* 버튼 스타일 */
				button {
					width: auto;
					/* 자동 크기 조정 */
					padding: 12px 20px;
					/* 버튼 안쪽 여백 */
					font-size: 16px;
					/* 글자 크기 */
					font-weight: bold;
					/* 글자 굵기 */
					border: none;
					/* 테두리 없애기 */
					border-radius: 8px;
					/* 둥근 모서리 */
					cursor: pointer;
					/* 마우스 커서 스타일 */
					transition: all 0.3s ease;
					/* 애니메이션 효과 */
				}
				
				/* 수정 버튼 스타일 */
				button.btn-warning {
					color: white;
					box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
					/* 버튼 그림자 효과 */
				}
				
				/* 삭제 버튼 스타일 */
				button.btn-danger {
					/* 그라디언트 색상 */
					color: white;
					box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
					/* 버튼 그림자 효과 */
				}
				
				/* 버튼 호버 효과 */
				button:hover {
					transform: translateY(-2px);
					/* 마우스를 올리면 버튼이 살짝 올라오도록 */
					box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
					/* 그림자 강도 증가 */
				}
				
				/* 버튼 클릭 시 효과 */
				button:active {
					transform: translateY(2px);
					/* 클릭 시 버튼이 눌린 것처럼 보이도록 */
					box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
					/* 그림자 약간 감소 */
				}
				
				.feature-items {
					border: 3px solid #59c544;
					box-shadow: 0 8px 10px rgba(0, 0, 0, 0.1);
					border-radius: 10px;
					background: white;
					transition: 0.5s;
				}
				
				.feature-items:hover {
					transform: translateY(-5px);
					box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
				}
				
				.btn.btn-primary1 {
					background: #59c544;
					border: 2px whitesmoke;
					color: white;
				}
				
				.btn.btn-primary1:hover {
					background-color: white;
					border: 0px;
					color: #59c544;
				}
				
			</style>
</head>

	<body>
	<c:set var="memId" value="${userInfo.memId}" />
	<c:set var="boardId" value="${board.boardId}" />
	<!-- 상단 포함 -->
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

	<!-- 게시글 섹션 시작 -->
	<section class="page-section" style="margin-top: 150px" id="contact">
	<div class="container feature-items p-5 mb-5">
		<!-- 게시글 제목 -->
		<h2
			class="page-section-heading text-center text-uppercase text-primary mb-0">게시글</h2>

		<div class="divider-custom">
			<div class="divider-custom-line"></div>
		</div>



		<!-- 게시글 내용 -->
		<div class="row justify-content-center">
			<div class="col-lg-8 col-xl-7">
				<div class="mb-3">
					<label class="fs-5">제목</label> <input
						class="form-control input-sm fs-5" type="text" name="boardTitle"
						value="${board.boardTitle}" readonly>
				</div>
				<div class="mb-3">
					<label class="fs-5">작성자</label> <input
						class="form-control input-sm fs-5" type="text" name="memId"
						value=" ${board.memId}" readonly>
				</div>
				<div class="mb-3">
					<label class="fs-5">수정일</label> <input
						class="form-control input-sm fs-5" type="text" name="createDt"
						value="${board.updateDt}" readonly>
				</div>
				<div class="mb-3">
					<label class="fs-5">조회수</label> <input
						class="form-control input-sm fs-5" type="text" name="createDt"
						value="${board.boardHit}" readonly>
				</div>
	
				<!-- 이미지가 존재하면 출력 -->
				<c:if test="${not empty board.filePath}">
					<div class="mb-3">
						<img src="${board.fileName}" alt="게시글 이미지"
							style="max-width: 100%; height: auto;">
					</div>
				</c:if>
	
				<div class="mb-3">
					<label class="fs-5">내용</label>
					<textarea class="form-control fs-5"
						style="height: 20rem; resize: none;" readonly>${board.boardContents}</textarea>
				</div>
	
				<!-- 게시글 수정 및 삭제 버튼 -->
				<div class="d-flex justify-content-start mb-3">
					<!-- 수정 버튼 -->
					<c:if test="${sessionScope.loginUser.memId == board.memId}">
						<form action="<c:url value='/board/edit' />" method="get"
							style="display: inline-block; margin-right: 10px;">
							<input type="hidden" name="boardId" value="${board.boardId}">
							<button class="btn btn-warning btn-lg" type="submit">수정</button>
						</form>
					</c:if>
	
					<!-- 삭제 버튼: 로그인한 사용자가 게시글 작성자일 때만 활성화 -->
					<c:if test="${sessionScope.loginUser.memId == board.memId}">
						<form action="<c:url value='/board/delete' />" method="post"
							onsubmit="return confirm('정말 삭제하시겠습니까?');"
							style="display: inline-block;">
							<input type="hidden" name="boardId" value="${board.boardId}">
							<button class="btn btn-danger btn-lg" type="submit">삭제</button>
						</form>
					</c:if>
				</div>
	
				<!-- 댓글 입력란 -->
				<div class="comment-section">
					<h5>댓글</h5>
					<input type="text" id="commentInput"
						class="input-container" placeholder="댓글을 입력하세요.">
					<button type="button" onclick="fn_write()"
						class="commentButton">등록</button>
				</div>
				
				<!-- 댓글 및 대댓글 표시 영역 -->
				<div id="commentsListContainer">
					<!-- 댓글 목록을 서버에서 동적으로 추가 -->
					<c:if test="${empty commentsList}">
						<p>댓글이 없습니다</p>
					</c:if>
					<c:if test="${not empty commentsList}">
						<ul id="commentsList">
							<c:forEach var="comment" items="${commentsList}">
								<li><strong>${comment.name}:</strong> ${comment.content}</li>
							</c:forEach>
						</ul>
					</c:if>
				</div>
			</div>
		</div>
		</div>
	</section>

	<!-- 하단 포함 -->
	<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

	<script type="text/javascript">
        // 댓글 작성 및 삭제 관련 스크립트
        function fn_write() {
            let memId = '${memId}';
            let boardId = '${boardId}';
            let msg = $("#commentInput").val();
            if (memId == '') {
                alert("댓글은 로그인 해야함!!!");
                return;
            }
            if (msg == '') {
                alert("내용을 작성해주세요!!!");
                return;
            }
            $.ajax({
                url: '<c:url value="/board/comment" />',
                type: 'POST',
                dataType: 'json',
                data: {    "memId": memId,
             			   "boardId": boardId,
                           "commentContent": msg},
                success: function (res) {
                    let msg = $("#commentInput").val("");
                    let str = "<tr id='" + res.commentId + "'>";
                    str += "<td>" + res.memId + "</td>";
                    str += "<td>" + res.commentContent + "</td>";
                    str += "<td><a onclick='fn_del(\"" + res.commentId + "\")'>X</a></td>";
                    str += "</tr>";
                    $("#commentsListContainer").prepend(str);
                },
                error: function (e) {
                    console.log(e);
                }
            });
        }

        function fn_del(p_replyNo) {
            if (confirm("정말로 삭제 하시겠습니까?!")) {
                $.ajax({
                    url: '<c:url value="/delReplyDo" />',
                    type: 'POST',
                    data: JSON.stringify({
                        "replyNo": p_replyNo
                    }),
                    contentType: 'application/json',
                    dataType: "text",
                    success: function (res) {
                        if (res == 'success') {
                            $("#" + p_replyNo).remove();
                        }
                    },
                    error: function (e) {
                        console.log(e);
                    }
                });
            }
        }
    </script>
	</body>

</html>