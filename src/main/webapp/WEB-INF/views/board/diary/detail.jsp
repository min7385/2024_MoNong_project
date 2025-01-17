<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상세 게시글</title>
<script src="https://cdn.jsdelivr.net/npm/jsrsasign"></script>
<!-- JWT 디코딩을 위한 jsrsasign 라이브러리 -->

<style>
/* 기본 스타일 */
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f4f4f9;
	color: #333;
}

.unique-container {
	width: 90%;
	max-width: 1000px;
	margin: 20px auto;
	background-color: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	border: 1px solid #ddd;
}

h1 {
	text-align: center;
	font-size: 28px;
	color: #4CAF50;
	margin-bottom: 20px;
}

/* 게시글 정보 스타일 */
.unique-post-info {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 0;
	border-bottom: 1px solid #ddd;
	margin-bottom: 20px;
	font-size: 14px;
	color: #666;
}

.unique-post-info div {
	margin: 0 10px;
}

.unique-block {
	display: flex;
	align-items: center;
	margin-bottom: 20px;
}

.unique-block img {
	width: 50%;
	height: auto;
	border-radius: 8px;
	object-fit: cover;
}

.unique-text-block, .unique-content {
	width: 100%;
	padding: 15px;
	font-size: 16px;
	line-height: 1.6;
	border: none;
	background-color: #f9f9f9;
	border-radius: 8px;
	resize: none;
}

/* 수정 버튼 스타일 */
.unique-edit-button {
	padding: 10px 15px;
	font-size: 1rem;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	text-decoration: none;
	margin-top: 20px;
	display: inline-block;
}

.unique-edit-button:hover {
	background-color: #388E3C;
}

/* 좋아요 스타일 */
.unique-like-count {
	padding: 10px 15px;
	background-color: #f1f8e9;
	border: 1px solid #4CAF50;
	border-radius: 5px;
	color: #4CAF50;
	font-size: 16px;
	display: inline-block;
	margin-top: 20px;
}

.heart {
	width: 24px;
	height: 24px;
	fill: none;
	stroke: #4CAF50;
	stroke-width: 2;
	cursor: pointer;
	transition: fill 0.3s, stroke 0.3s;
}

.heart.liked {
	fill: #f44336; /* 활성화된 빨간색 하트 */
	stroke: #f44336;
}

/* 댓글 섹션 스타일 */
#commentInputContainer {
	display: flex;
	align-items: center;
	margin-bottom: 20px;
}

#commentInput {
	flex: 1;
	padding: 10px 15px;
	border: 1px solid #ccc;
	border-radius: 20px;
	font-size: 16px;
	margin-right: 10px;
}

#sendCommentButton {
	padding: 10px 20px;
	background-color: #007BFF;
	color: white;
	border: none;
	border-radius: 20px;
	cursor: pointer;
	font-size: 16px;
	transition: background-color 0.3s;
}

#sendCommentButton:hover {
	background-color: #0056b3;
}

#commentsList {
	list-style-type: none;
	padding: 0;
}

#commentsList li {
	padding: 10px;
	border-bottom: 1px solid #eee;
}

#commentsList li strong {
	color: #007BFF;
}
/* 반응형 디자인 */
@media ( max-width : 768px) {
	.unique-block {
		flex-direction: column;
		text-align: center;
	}
	.unique-block img {
		width: 100%;
		margin: 0 0 10px 0;
	}
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

	<div class="unique-container">
		<!-- 게시글 제목 -->
		<h1>${diary.diaryTitle}</h1>

		<!-- 게시글 정보 -->
		<div class="unique-post-info">
			<div>
				<strong>제목:</strong> ${diary.diaryTitle}
			</div>
			<div>
				<strong>작성자:</strong> ${diary.diaryWriter}
			</div>
			<div>
				<strong>작성일:</strong> ${diary.createDt}
			</div>
		</div>

		<!-- 게시글 내용 -->
		<div class="unique-block left-block">
			<div class="unique-text-block">${diary.diaryContents}</div>
		</div>

		<!-- 좋아요 카운트 및 조회수 -->
		<div class="unique-like-count">
			<!-- 좋아요 하트 버튼 -->
			<svg class="heart" id="likeHeart" onclick="toggleLike()">
            <path
					d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
        </svg>
			<strong>좋아요:</strong> <span id="likeCount">${diary.likeCount}</span>
			&nbsp; | &nbsp; <strong>조회수:</strong> ${diary.diaryHit}
		</div>

		<!-- 수정하기 버튼 (로그인한 사용자가 글의 작성자인 경우에만 보여짐) -->
		<div id="editButton" style="display: none;">
			<a href="/diary/edit/${diary.diaryId}" class="unique-edit-button">수정하기</a>
		</div>
	</div>
	<!-- 댓글 섹션 추가 -->
	<div class="unique-container">
		<h2>댓글</h2>

		<!-- 댓글 입력창 및 전송 버튼 (로그인한 경우에만 표시) -->
		<div id="commentInputContainer" style="display: none;">
			<input type="text" id="commentInput" placeholder="댓글을 입력하세요..." />
			<button id="sendCommentButton">전송</button>
		</div>

		<!-- 댓글 리스트 또는 '댓글이 아직 없습니다.' 표시 -->
		<div id="commentsListContainer">
			<c:if test="${empty commentsList}">
				<p>댓글이 아직 없습니다.</p>
			</c:if>
			<c:if test="${not empty commentsList}">
				<ul id="commentsList">

<c:forEach var="comment" items="${commentsList}">
    <!-- 부모 댓글만 출력 -->
    <c:if test="${comment.parentCommentId == null}">
        <li style="overflow: auto; padding: 10px; border-bottom: 1px solid #eee;">
            <!-- 작성자(memId)는 연두색 -->
            <strong style="color: #4CAF50;">${comment.memId}</strong>:
            <!-- 댓글 내용 처리: useYnStr이 'Y'이면 내용, 아니면 '삭제된 댓글입니다.' (연한 회색) -->
            <c:choose>
                <c:when test="${comment.useYnStr eq 'Y'}">
                    ${comment.commentContent}
                </c:when>
                <c:otherwise>
                    <span style="color: #ccc;">삭제된 댓글입니다.</span>
                </c:otherwise>
            </c:choose>
            <!-- 오른쪽 끝에 작성일(createDt) 표시 -->
            <span style="float: right; font-size: 0.85em; color: #666;">${comment.createDt}</span>
        </li>
    </c:if>
</c:forEach>



				</ul>
			</c:if>
		</div>
	</div>

	<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

	<script>
    // 쿠키에서 JWT 값 가져오는 함수
    function getCookie(name) {
        var cookieArray = document.cookie.split(';');
        for (var i = 0; i < cookieArray.length; i++) {
            var cookie = cookieArray[i].trim();
            if (cookie.indexOf(name + "=") == 0) {
                return cookie.substring(name.length + 1, cookie.length);
            }
        }
        return "";
    }

    // JWT 디코딩 및 sub 값 추출
    function getSubFromJWT(token) {
        var decoded = KJUR.jws.JWS.parse(token);  // JWT 디코딩
        return decoded.payloadObj.sub;  // payload에서 sub 값을 추출
    }

    window.onload = function() {
        setTimeout(function() {  // 1초 지연 후 실행
            // JWT Token을 쿠키에서 가져옴
            var jwtToken = getCookie("accessToken");  
            if (jwtToken) {
                var userSub = getSubFromJWT(jwtToken);  // JWT에서 sub 값 (memId) 추출
                // 댓글 입력창 및 전송 버튼 표시
                document.getElementById("commentInputContainer").style.display = "flex";
            } else {
            	document.getElementById("commentInputContainer").style.display = "none";
            }

            // 다이어리 작성자 memId
            var diaryWriterId = "${diary.memId}";  // 서버에서 전달된 다이어리 작성자 memId

            // 로그인한 사용자 ID가 다이어리 작성자 ID와 같으면 수정하기 버튼을 보이게 처리
            if (userSub && userSub === diaryWriterId) {
                document.getElementById("editButton").style.display = "inline-block";
            }

            // JSP에서 likesList를 JavaScript 배열로 변환
            var likesList = [
                <c:forEach var="like" items="${likesList}" varStatus="status">
                    "${fn:escapeXml(like)}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];

            // 좋아요 수 업데이트
            var likeCountElement = document.getElementById("likeCount");
            likeCountElement.innerText = likesList.length; // 좋아요 목록의 길이만큼 카운트 업데이트

            // 하트 상태 업데이트
            var heart = document.getElementById("likeHeart");
            if (userSub && likesList.includes(userSub)) {
                heart.classList.add("liked");  // 하트를 활성화
            } else {
                heart.classList.remove("liked");  // 하트를 일반 상태로
            }

        }, 100);  // 1초 지연
    };
    
    // 좋아요 버튼 상태 토글
    function toggleLike() {
        var jwtToken = getCookie("accessToken");  // 쿠키에서 accessToken 값을 가져옴
        var userSub = getSubFromJWT(jwtToken);  // 로그인한 사용자 ID (memId)

        // 좋아요 상태 토글
        var url = "/diary/toggleLike";
        var params = "diaryId=" + ${diary.diaryId} + "&memId=" + userSub;

        // 서버로 좋아요 추가/취소 요청
        var xhr = new XMLHttpRequest();
        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onload = function() {
            if (xhr.status === 200) {
                // 서버에서 받은 좋아요 목록
                var likesList = JSON.parse(xhr.responseText);

                // 좋아요 수 업데이트
                var likeCountElement = document.getElementById("likeCount");
                likeCountElement.innerText = likesList.length; // 좋아요 목록의 길이만큼 카운트 업데이트

                // 하트 상태 업데이트
                var heart = document.getElementById("likeHeart");
                if (likesList.includes(userSub)) {
                    heart.classList.add("liked");  // 하트를 활성화
                } else {
                    heart.classList.remove("liked");  // 하트를 일반 상태로
                }
            }
        };
        xhr.send(params);
    }

    // 댓글 전송 함수
    document.getElementById("sendCommentButton").addEventListener("click", function() {
    var commentContent = document.getElementById("commentInput").value.trim();
    if (commentContent === "") {
        alert("댓글을 입력해주세요.");
        return;
    }

    var jwtToken = getCookie("accessToken");
    var userSub = getSubFromJWT(jwtToken);  // 사용자 ID(memId) 추출

    var diaryId = ${diary.diaryId};  
    // var parentCommentId = null;  // 필요하면 나중에 실제 값이 있을 때만 보내도록 처리

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/diary/comments/create", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            alert("댓글이 등록되었습니다.");
            location.reload();  // 새로고침하여 댓글 목록을 갱신
        }
    };

    // 파라미터 문자열 생성
    // parentCommentId가 null이면 포함하지 않는다.
    var params = "diaryId=" + diaryId 
               + "&memId=" + userSub
               + "&commentContent=" + encodeURIComponent(commentContent);

    // 예) 만약 parentCommentId가 실제로 필요해 값이 있을 때만 추가
    // if (parentCommentId !== null && parentCommentId !== undefined) {
    //     params += "&parentCommentId=" + parentCommentId;
    // }

    xhr.send(params);
});
</script>


</body>
</html>
