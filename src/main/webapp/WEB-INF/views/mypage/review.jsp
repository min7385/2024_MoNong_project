<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>후기 내역 조회</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        /* 컨테이너 */
        .chatContainer {
            width: 90%;
            max-width: 800px;
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

        /* 탭 메뉴 */
        .tabs {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }

        .tabs div {
            padding: 10px;
            font-weight: bold;
            cursor: pointer;
            color: #4CAF50;
            border-bottom: 3px solid transparent;
            transition: color 0.3s, border-bottom 0.3s;
        }

        .tabs div.active {
            color: #333;
            border-bottom: 3px solid #4CAF50;
        }

        /* 탭 내용 */
        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* 아이템 스타일 */
        .activity-item {
            display: flex;
            align-items: center;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .activity-item img {
            width: 80px;
            height: 80px;
            margin-right: 15px;
            object-fit: cover;
            border-radius: 50%;
        }

        .activity-item div {
            flex: 1;
        }

        .activity-item h3 {
            margin: 0;
            font-size: 16px;
        }

        .activity-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #666;
        }
        
        .reviewInfo {
        	display: inline-block;
			margin: 5px !important;        	
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .tabs {
                flex-direction: column;
                align-items: center;
            }

            .activity-item {
                flex-direction: column;
                text-align: center;
            }

            .activity-item img {
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<body>

<div class="chatContainer">
    <!-- 제목 -->
    <h1>후기 조회</h1>

    <!-- 탭 메뉴 -->
    <div class="tabs">
        <div id="totalTab" class="active">전체</div>
        <div id="toMeTab">받은 후기</div>
        <div id="fromMeTab">보낸 후기</div>
    </div>

    <div id="totalContent" class="tab-content active">
    
    	<c:if test="${empty totalReviewList}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	    </c:if>
    	
        <c:forEach var="review" items="${totalReviewList}">
	        <div class="activity-item" onclick="window.location.href='/product/detail?prodId=${review.revProdId}'">
	            <img src="${review.memProfile}" alt="프로필이미지">
	            <div style="display: flex; flex-wrap: wrap;">
	                <strong class="reviewInfo">${review.memNic}</strong>
	                <p class="reviewInfo">${review.prodCategory}</p>
	                <p class="reviewInfo">${review.cityAndDistrict}</p>
	                <p class="reviewInfo">${review.relativeTime}</p>
	                <p class="reviewInfo" style="flex-basis: 100%;">${review.revContent}</p>
	            </div>
	        </div>
		</c:forEach>
    </div>

    <!-- 게시글 수 탭 내용 -->
    <div id="toMeContent" class="tab-content">
    
    	<c:if test="${empty toMeReviewList}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	    </c:if>
    	
        <c:forEach var="review" items="${toMeReviewList}">
	        <div class="activity-item" onclick="window.location.href='/product/detail?prodId=${review.revProdId}'">
	            <img src="${review.memProfile}" alt="프로필이미지">
	            <div style="display: flex; flex-wrap: wrap;">
	                <strong class="reviewInfo">${review.memNic}</strong>
	                <p class="reviewInfo">${review.prodCategory}</p>
	                <p class="reviewInfo">${review.cityAndDistrict}</p>
	                <p class="reviewInfo">${review.relativeTime}</p>
	                <p class="reviewInfo" style="flex-basis: 100%;">${review.revContent}</p>
	            </div>
	        </div>
		</c:forEach>
    </div>

    <!-- 댓글 수 탭 내용 -->
    <div id="fromMeContent" class="tab-content">
    
    	<c:if test="${empty fromMeReviewList}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	    </c:if>
    	
        <c:forEach var="review" items="${fromMeReviewList}">
	        <div class="activity-item" onclick="window.location.href='/product/detail?prodId=${review.revProdId}'">
	            <img src="${review.memProfile}" alt="프로필이미지">
	            <div style="display: flex; flex-wrap: wrap;">
	                <strong class="reviewInfo">${review.memNic}</strong>
	                <p class="reviewInfo">${review.prodCategory}</p>
	                <p class="reviewInfo">${review.cityAndDistrict}</p>
	                <p class="reviewInfo">${review.relativeTime}</p>
	                <p class="reviewInfo" style="flex-basis: 100%;">${review.revContent}</p>
	            </div>
	        </div>
		</c:forEach>
    </div>
</div>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
<script>
    // 탭 전환 기능
    const totalTab = document.getElementById("totalTab");
    const toMeTab = document.getElementById("toMeTab");
    const fromMeTab = document.getElementById("fromMeTab");

    const totalContent = document.getElementById("totalContent");
    const toMeContent = document.getElementById("toMeContent");
    const fromMeContent = document.getElementById("fromMeContent");

    function showTab(tabName) {
        // 모든 탭과 콘텐츠 비활성화
        totalTab.classList.remove("active");
        toMeTab.classList.remove("active");
        fromMeTab.classList.remove("active");

        totalContent.classList.remove("active");
        toMeContent.classList.remove("active");
        fromMeContent.classList.remove("active");

        // 선택된 탭과 콘텐츠 활성화
        if (tabName === "likes") {
            totalTab.classList.add("active");
            totalContent.classList.add("active");
        } else if (tabName === "posts") {
            toMeTab.classList.add("active");
            toMeContent.classList.add("active");
        } else if (tabName === "comments") {
            fromMeTab.classList.add("active");
            fromMeContent.classList.add("active");
        }
    }

    totalTab.addEventListener("click", () => showTab("likes"));
    toMeTab.addEventListener("click", () => showTab("posts"));
    fromMeTab.addEventListener("click", () => showTab("comments"));
</script>

</body>
</html>
