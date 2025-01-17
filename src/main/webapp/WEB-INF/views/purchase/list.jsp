<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>채팅 목록</title>
<style>
/* 전체 화면 설정 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
	background-color: #f9f9f9;
	color: #333;
	height: 100vh;
	display: flex;
	flex-direction: column;
}

/* 해더 (타이틀 블록 색상 반전) */
.header {
	background-color: white; /* 배경색 반전 */
	color: #4CAF50; /* 글자색 반전 */
	padding: 15px 20px;
	text-align: center;
	font-size: 1.5rem;
	font-weight: bold;
	border-bottom: 2px solid #4CAF50;
}

/* 컨테이너 (채팅 목록) */
.container {
	flex: 1;
	display: flex;
	flex-direction: column;
	overflow-y: auto;
	background-color: white;
}

/* 채팅 필터 */
.chat-filter {
	display: flex;
	justify-content: space-around;
	background-color: #4CAF50;
	color: white;
	font-weight: bold;
	border-bottom: 1px solid #ddd;
}

.chat-filter div {
	flex: 1;
	text-align: center;
	padding: 10px 0;
	cursor: pointer;
	transition: background-color 0.3s;
}

.chat-filter div.active {
	background-color: #388E3C;
}

/* 채팅 블록 */
.chat-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px;
	border-bottom: 1px solid #ddd;
	transition: background-color 0.3s;
}

.chat-item.completed {
	background-color: #e0f7e9; /* 거래 완료된 항목 색상 */
}

.chat-left {
	display: flex;
	align-items: center;
	gap: 10px;
}

.profile-img {
	width: 50px;
	height: 50px;
	border-radius: 50%;
	background-color: #ddd;
	object-fit: cover;
}

.chat-content {
	display: flex;
	flex-direction: column;
}

.chat-message {
	font-weight: bold;
	color: #333;
}

.chat-time {
	font-size: 0.9rem;
	color: #888;
}

/* 읽지 않은 메시지 */
.unread {
	background-color: #FF7F00;
	color: white;
	font-size: 0.8rem;
	padding: 5px 8px;
	border-radius: 50%;
	text-align: center;
	min-width: 20px;
	font-weight: bold;
}

/* 반응형 디자인 */
@media ( max-width : 768px) {
	.chat-item {
		flex-direction: row;
		justify-content: space-between;
	}
	.chat-filter {
		flex-direction: row; /* 필터 유지 */
	}
	.chat-left {
		flex-direction: row;
	}
}
</style>
</head>
<body>
	<!-- 헤더 -->
	<div class="header">채팅목록</div>

	<!-- 필터 -->
	<div class="chat-filter">
		<div class="active" onclick="filterChats('all')">전체</div>
		<div onclick="filterChats('purchase')">구매</div>
		<div onclick="filterChats('sale')">판매</div>
	</div>
	<div class="container">
		<c:if test="${empty roomList}">
			<p>현재 채팅방이 없습니다.</p>
		</c:if>

		<c:forEach var="room" items="${roomList}">
			<div class="chat-item">
				<div class="chat-left">
					<img src="https://via.placeholder.com/50" alt="프로필"
						class="profile-img">
					<div class="chat-content">
						<!-- 클릭 시 해당 채팅방으로 이동하는 링크 추가 -->
						<a href="<c:url value='/chat?chatId=${room.chatId}' />"
							class="chat-message">${room.chatProdId}</a>
						<!-- 채팅방 링크 -->
						<span class="chat-time">${room.createDt}</span>
					</div>
				</div>
				<div class="chat-right">
					<c:if test="${room.chatSeller != null}">
						<span class="unread">판매 상태: ${room.chatStatus}</span>
					</c:if>
				</div>
			</div>
		</c:forEach>


	</div>
</body>
</html>
