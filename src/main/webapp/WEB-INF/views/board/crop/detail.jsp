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
	border-radius: 10px;
}

.header h1 {
	margin: 0;
	font-size: 36px;
	font-weight: bold;
}

.sub-header {
	font-size: 16px;
	color: #eee;
	margin-top: 10px;
}

/* 게시글 정보 */
.post-info {
	display: flex;
	justify-content: space-between;
	background: #fff;
	padding: 10px 20px;
	margin-top: 20px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.post-info div {
	font-size: 16px;
	margin-bottom: 10px;
}

.post-info strong {
	color: #4CAF50;
}

.post-info .meta {
	font-size: 14px;
	color: #888;
}

/* 게시글 내용 */
.post-content {
	background: #fff;
	padding: 20px;
	margin-top: 20px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.post-content p {
	font-size: 16px;
	line-height: 1.6;
	margin-bottom: 20px;
}

.post-content img {
	width: 100%;
	height: auto;
	margin-top: 20px;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

img {
	max-width: 100%;
	margin: 25px 0;
	border-radius: 50px;
}

li {
	list-style: none;
}

.post-container h2 {
	margin-top: 40px;
}
.post-container h3 {
	margin-top: 40px;
}

em{
	display:block;
	text-align: center;
	margin-bottom: 20px;
}
.tapeImg{
				display: grid; /* Grid 활성화 */
                place-items: center; 
}
/* 반응형 디자인 */
@media screen and (max-width: 768px) {
	.post-info {
		flex-direction: column; /* 세로로 배치 */
		align-items: center;
		text-align: center; /* 텍스트 가운데 정렬 */
	}
	.header h1 {
		font-size: 24px;
	}
	.header {
		padding: 15px 0;
	}
	.post-content {
		padding: 10px;
		margin-top: 10px;
	}
	.post-content p {
		font-size: 14px;
	}
	em{
		display:block;
		text-align: center;
	}
	ol, ul {
	    padding-right: 2rem;
	}
	.tapeImg{
				display: grid; /* Grid 활성화 */
                place-items: center; 
	}
}

@media screen and (max-width: 480px) {
	.header h1 {
		font-size: 18px;
	}
	.header {
		padding: 10px 0;
	}
	.post-content {
		padding: 8px;
	}
	em{
		display:block;
		text-align: center;
	}
	ol, ul {
    	padding-right: 2rem;
	}
	.tapeImg{
				display: grid; /* Grid 활성화 */
                place-items: center; 
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="wrapper">
		<!-- 상단 제목과 설명 -->
		<div class="header">
			<h1>농업기술 정보방</h1>
			<div class="sub-header">${board.truncatedTitle}</div>
		</div>

	<div class="post-container">
		<c:if test="${not empty board}">
			<div class="post-info">
				<div>${board.content}</div>
			</div>
		</c:if>
		<c:if test="${empty board}">
			<p>게시글을 찾을 수 없습니다.</p>
		</c:if>
	</div>
	</div>
</body>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</html>

