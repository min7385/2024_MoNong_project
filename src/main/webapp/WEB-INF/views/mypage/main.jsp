	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<%@ page session="false" %>
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>마이페이지</title>
	    <style>
	        /* 기본 스타일 */
	        body {
	            font-family: Arial, sans-serif;
	            margin: 0;
	            padding: 0;
	            background-color: #f9f9f9;
	            color: #333;
	        }
	
	        .mypage-container {
	            width: 90%;
	            margin: 20px auto;
	            background-color: white;
	            padding: 20px;
	            border-radius: 10px;
	            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	        }
	
	        h1 {
	            text-align: center;
	            color: #4CAF50;
	        }
	
	        /* 첫 번째 블록: 프로필 및 닉네임 */
	        .profile-block {
	            display: flex;
	            align-items: center;
	            justify-content: space-between;
	            background-color: #f4f4f4;
	            padding: 20px;
	            border-radius: 10px;
	            margin-bottom: 20px;
	        }
	
	        .profile-image {
	            width: 240px; /* 4배 크기 */
	            height: 240px;
	            border-radius: 50%;
	            object-fit: cover;
	            border: 3px solid #4CAF50;
	        }
	
	        .profile-info {
	            flex: 1;
	            margin-left: 20px;
	        }
	
	        .profile-info p {
	            margin: 5px 0;
	        }
	
	        .profile-actions button {
	            padding: 8px 12px;
	            font-size: 12px;
	            background-color: #4CAF50;
	            color: white;
	            border: none;
	            border-radius: 5px;
	            cursor: pointer;
	        }
	
	        .profile-actions button:hover {
	            background-color: #45a049;
	        }
	
	        /* 두 번째 블록: 거래 내역 */
	        .transaction-block, .chat-block {
	            background-color: #f4f4f4;
	            padding: 15px;
	            border-radius: 10px;
	            text-align: center;
	            margin-bottom: 20px;
	        }
	
	        .transaction-info, .chat-info {
	            display: flex;
	            justify-content: space-around;
	            margin: 10px 0;
	        }
	
	        .transaction-info div, .chat-info div {
	            background-color: #fff;
	            border-radius: 20px;
	            padding: 8px 12px;
	            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	        }
	
	        .transaction-block a, .chat-block a {
	            text-decoration: none;
	            color: #4CAF50;
	            font-weight: bold;
	        }
	
	        /* 추가 정보 블록 */
	        .activity-block {
	            background-color: #f4f4f4;
	            padding: 15px;
	            border-radius: 10px;
	            margin-bottom: 20px;
	        }
	
	        .activity-info {
	            display: flex;
	            justify-content: space-around;
	            text-align: center;
	        }
	
	        /* 로그아웃 버튼 */
	        .logout {
	            text-align: center;
	        }
	
	        .logout button {
	            background-color: #f44336;
	            color: white;
	            border: none;
	            border-radius: 5px;
	            padding: 10px 20px;
	            cursor: pointer;
	            font-size: 14px;
	        }
	
	        .logout button:hover {
	            background-color: #d32f2f;
	        }
	
	        /* 반응형 스타일 */
	        @media (max-width: 768px) {
	            .profile-block {
	                flex-direction: column;
	                align-items: center;
	            }
	
	            .profile-image {
	                width: 150px;
	                height: 150px;
	            }
	
	            .profile-info {
	                margin-left: 0;
	                text-align: center;
	            }
	
	            .transaction-info,
	            .activity-info {
	                flex-direction: column;
	            }
	
	            .transaction-info div,
	            .activity-info div {
	                margin-bottom: 10px;
	            }
	        }
	    </style>
	</head>
	<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="mypage-container">
	    <!-- 마이페이지 제목 -->
	    <h1>마이페이지</h1>
	
	    <!-- 첫 번째 블록: 프로필 및 닉네임 -->
	    <div class="profile-block">
	        <!-- 프로필 이미지 -->
	        <c:if test="${myPageInfo.memProfile == null}">
		        <img src="/download?imageFileName=non.png" id="myImage" class="profile-image" alt="프로필 이미지">
			</c:if>
			<c:if test="${myPageInfo.memProfile != null}">
				<img src="${myPageInfo.memProfile}" id="myImage" class="profile-image" alt="프로필 이미지">
			</c:if>
	
	        <!-- 닉네임 및 포인트 -->
	        <div class="profile-info">
	            <p><strong>이 &nbsp;&nbsp;름&nbsp;: </strong> ${myPageInfo.memName != null ? myPageInfo.memName : '로그인x'}</p>
	            <p><strong>닉네임 : </strong> ${myPageInfo.memNic != null ? myPageInfo.memNic : '로그인x'}</p>
	            <p><strong>주 &nbsp;&nbsp;소&nbsp;: </strong> ${myPageInfo.memAddr != null ? myPageInfo.memAddr : '로그인x'}</p>
	            <p><strong>신뢰도 : </strong> ${myPageInfo.memRel != null ? myPageInfo.memRel : null}</p>
	            <p><strong>포인트 : </strong> ${myPoint.totalPoints != null ? myPoint.totalPoints : 0}</p>
	            <p id='memPhone'><strong>전화번호: </strong> ${myPageInfo.memPhone != null ? myPageInfo.memPhone : '로그인x'}</p>
	            <div class="profile-actions">
	                <button onclick="location.href='/mypage/change'">개인정보 수정</button>
	            </div>
	        </div>
	    </div>
	
	    <!-- 두 번째 블록: 채팅 내역 -->
	    <div class="chat-block">
	        <h2>나의 채팅</h2>
	        <div class="chat-info">
	            <div>전체: ${chatInfoList[0]}</div>
	            <div>판매: ${chatInfoList[1]}</div>
	            <div>구매: ${chatInfoList[2]}</div>
	        </div>
	        <a href="/mypage/chat">채팅 내역 조회</a>
	    </div>
	    
	    <!-- 세 번째 블록: 거래 내역 -->
	    <div class="transaction-block">
	        <h2>나의 거래</h2>
	        <div class="transaction-info">
	            <div>판매: ${chatInfoList[3]}</div>
	            <div>예약: ${chatInfoList[4]}</div>
	            <div>완료: ${chatInfoList[5]}</div>
	        </div>
	        <a href="/mypage/trade">거래 내역 조회</a>
	    </div>
	
<!-- 	    세 번째 블록: 활동 내역 -->
<!-- 	    <div class="activity-block"> -->
<!-- 	        <h2>활동 내역</h2> -->
<!-- 	        <div class="activity-info"> -->
<!-- 	            <div>좋아요: 12</div> -->
<!-- 	            <div>게시글 수: 4</div> -->
<!-- 	            <div>댓글 수: 10</div> -->
<!-- 	        </div> -->
<!-- 	        <a href="#">활동 내역 조회</a> -->
<!-- 	    </div> -->
	    
<!-- 	    네 번째 블록: 포인트 -->
<!-- 	    <div class="activity-block"> -->
<!-- 	        <h2>짜투리 포인트</h2> -->
<!-- 	        <div class="activity-info"> -->
<!-- 	            <div>짜투리: 1215153</div> -->
<!-- 	        </div> -->
<!-- 	        <a href="#">짜투리 내역 조회</a> -->
<!-- 	    </div> -->
	</div>
		<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
	
	</body>
	<script>

	document.addEventListener("DOMContentLoaded", function() {
		
		const memPhone = document.getElementById('memPhone').innerText
		
		if(memPhone == null){
			alert('전화번호 정보가 없습니다. 전화번호를 추가해주세요.')
			window.location.href = '/mypage/change'
		}
			
	});
	</script>
	</html>
