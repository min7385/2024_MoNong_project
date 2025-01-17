<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>팁 상세 정보</title>
<style>
body {
	font-family: 'Arial', sans-serif;
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

.sub-header {
	font-size: 16px;
	color: #888;
	margin-top: 10px;
}

.tabs {
	margin-top: 20px;
	display: flex;
	gap: 15px;
	justify-content: center;
}

.tab {
	padding: 12px 25px;
	background-color: #f1f1f1;
	border-radius: 25px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.3s, color 0.3s;
	/* 가로와 세로 가운데 정렬 */
	display: flex;
	align-items: center; /* 세로 가운데 */
	justify-content: center; /* 가로 가운데 */
}

.tab.active {
	background-color: #1d66ff;
	color: white;
}

.info-container {
	padding: 20px;
	background: #fff;
	border-radius: 15px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	margin-top: 20px;
}

.info-container h2 {
	color: #4CAF50;
	margin-top: 0;
	font-size: 24px;
	font-weight: bold;
	text-align: center;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	border-radius: 10px;
	overflow: hidden;
}

table, th, td {
	border: 1px solid #ddd;
}

th, td {
	padding: 14px;
	text-align: left;
}

th {
	background-color: #f1f1f1;
	width: 20%;
}

.image-gallery {
	display: flex;
	gap: 10px;
	margin-top: 20px;
	overflow-x: auto;
	padding-bottom: 10px;
}

.image-gallery img {
	width: 90px;
	height: 90px;
	object-fit: cover;
	cursor: pointer;
	border-radius: 10px;
	transition: transform 0.3s;
}

.image-gallery img:hover {
	transform: scale(1.1);
}

.main-image {
	margin-top: 20px;
	width: 100%;
	max-height: 400px;
	object-fit: cover;
	border-radius: 10px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.footer {
	font-size: 14px;
	color: #777;
	margin-top: 20px;
	text-align: right;
}

.footer span {
	font-weight: bold;
}

/* 반응형 디자인 */
@media screen and (max-width: 768px) {
	.tabs {
		flex-direction: column;
	}
	.tab {
		padding: 10px;
		margin: 5px 0;
		font-size: 16px;
	}
	.info-container {
		padding: 15px;
	}
	.image-gallery {
		gap: 5px;
		flex-wrap: wrap;
	}
	.image-gallery img {
		width: 70px;
		height: 70px;
	}
	.main-image {
		max-height: 300px;
	}
}

/* 모바일 최적화 */
@media screen and (max-width: 480px) {
	.header h1 {
		font-size: 28px;
	}
	.info-container h2 {
		font-size: 20px;
	}
	.footer {
		font-size: 12px;
	}
}
</style>
</head>

<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="wrapper">
		<div class="header">
			<h1>지역별 재배정보</h1>
			<div class="sub-header">지역별 작황정보를 알기 쉽게 전달해 주는 서비스입니다.</div>
		</div>

		<div class="tabs">
			<div class="tab active">${tip.kind}</div>
			<!-- 다른 탭을 추가할 경우 아래와 같이 추가 -->
			<!-- <div class="tab">배추</div>
            <div class="tab">양파</div>
            ... -->
		</div>

		<div class="info-container">
			<h2>농산물 작황 정보</h2>

			<table>
				<tr>
					<th>조사일자</th>
					<td>${tip.startDate}~${tip.endDate}</td>
				</tr>
				<tr>
					<th>작형</th>
					<td>${tip.cropStage}</td>
				</tr>
				<tr>
					<th>조사지역</th>
					<td>${tip.surveyRegion}</td>
				</tr>
				<tr>
					<th>조사사유</th>
					<td>${tip.surveyReason}</td>
				</tr>
				<tr>
					<th>작황(전년대비)</th>
					<td>${tip.growthCondition}</td>
				</tr>
				<tr>
					<th>병충해</th>
					<td>${tip.pestDisease}</td>
				</tr>
				<tr>
					<th>조사내용</th>
					<td>${tip.memo}</td>
				</tr>
			</table>

			<img id="mainImage" src="" alt="메인 이미지" class="main-image">

			<div class="image-gallery">
				<c:forEach var="image" items="${tip.imageList}">
					<img src="${image}" alt="작황 이미지" onclick="changeImage('${image}')">
				</c:forEach>
			</div>
		</div>
	</div>

	<script>
		// 이미지 URL에서 쿼리 파라미터를 제거하고, 확장자까지 잘라내는 함수
		function cleanImageUrl(imageUrl) {
			// URL에 &가 포함되어 있는지 확인
			if (imageUrl.indexOf('&') !== -1) {
				// '&' 뒤의 쿼리 파라미터 제거
				return imageUrl.split('&')[0];
			}
			// '&'가 없으면 URL 그대로 반환
			return imageUrl;
		}

		// 이미지 클릭 시 메인 이미지를 변경하는 함수
		function changeImage(imageSrc) {
			const cleanedImageSrc = cleanImageUrl(imageSrc); // 이미지를 정리하여 가져오기
			document.getElementById('mainImage').src = cleanedImageSrc;
		}

		window.onload = function() {
			var imageUrl = "${tip.imageList[0]}"; // JSP에서 데이터로 가져온 이미지 URL
			var cleanedImageUrl = cleanImageUrl(imageUrl);
			document.getElementById("mainImage").src = cleanedImageUrl; // 이미지를 업데이트
		}
	</script>

	<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>

</html>
