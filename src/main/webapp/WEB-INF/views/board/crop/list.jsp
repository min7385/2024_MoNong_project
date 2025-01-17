<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>농사 재배 팁 게시판</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f4f4f9;
	color: #333;
}

.wrapper {
	width: 90%;
	max-width: 1200px;
	margin: 20px auto;
}

.header {
	padding: 20px 0;
	text-align: center;
	background-color: #005100;
	color: white;
	margin-bottom: 20px;
}

.header h1 {
	font-size: 36px;
	font-weight: bold;
	margin: 0;
}

.sub-header {
	font-size: 16px;
	color: #eee;
	margin-top: 10px;
}

/* 카테고리 셀렉트 박스 스타일 */
.category-select {
	margin: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.category-select label {
	font-size: 18px;
	color: #4CAF50;
	font-weight: bolder;
}

.category-select select {
	padding: 10px;
	font-size: 16px;
	border-radius: 5px;
	border: 1px solid #ddd;
	width: 20%;
	background-color: #f1f1f1;
}

.post-container {
    display: grid; /* 그리드로 변경 */
    grid-template-columns: repeat(2, 1fr); /* 두 개씩 가로로 배치 */
    gap: 16px; /* 아이템 간의 간격 */
    justify-items: center; /* 아이템을 중앙 정렬 */
    margin-top: 20px;
}

.post {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 10px;
    text-align: center;
}

.post img {
    max-width: 100%;
    border-radius: 10px;
    margin-top: 17px;
}

.post-info {
	font-size: 16px;
	line-height: 1.6;
	margin-bottom: 20px;
}

/* 반응형 디자인 */
@media screen and (max-width: 768px) {
	.post-container {
		grid-template-columns: 1fr; /* 모바일 화면에서는 세로로 나열 */
	}
	.header h1 {
		font-size: 24px;
	}
	.header {
		padding: 15px 0;
	}
	.sub-header {
		font-size: 14px;
	}
}

@media screen and (max-width: 480px) {
	.header h1 {
		font-size: 18px;
	}
	.header {
		padding: 10px 0;
	}
	.sub-header {
		font-size: 12px;
	}
	.category-select select {
		width: 100%; /* 셀렉트 박스 넓이 조정 */
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<!-- 상단 제목과 설명 -->
	<div class="header">
		<h1>농업기술 정보방</h1>
		<div class="sub-header">농업인이 원하는 정보를 가공ㆍ정제ㆍ선별을 거쳐 알기 쉽게 전달해 주는 서비스입니다.</div>
	</div>

	<!-- 게시글 리스트 -->
	<div class="post-container">
		<c:forEach var="board" items="${boardList}">
			<div class="post">
				<a href="/crop/detail?id=${board.id}">
					${board.firstImgTag}
				</a>
				<div class="post-info">
					<p>${board.content}</p>
				</div>
			</div>
		</c:forEach>
	</div>

	<!-- 데이터가 없을 때 처리 -->
	<c:if test="${empty boardList}">
		<p>게시글이 없습니다.</p>
	</c:if>

	<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>
</html>
