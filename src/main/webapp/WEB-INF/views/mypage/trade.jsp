<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 거래내역</title>
    <style>
        /* 기본 스타일 */
         h1 {
            text-align: center;
            color: #4CAF50;
	        }

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        /* 컨테이너 */
        .tradeContainer {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            background-color: white;
            padding: 10px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* 상단 메뉴 */
        .menu {
            display: flex;
            justify-content: space-around;
            border-bottom: 1px solid #ddd;
            margin-bottom: 10px;
        }

        .menu div {
            padding: 10px;
            cursor: pointer;
            font-weight: bold;
            color: #4CAF50;
            border-bottom: 3px solid transparent;
            transition: border-bottom 0.3s, color 0.3s;
        }

        .menu div.active {
            color: #333;
            border-bottom: 3px solid #4CAF50;
        }

        /* 리스트 아이템 */
        .item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .item img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 15px;
        }

        .item-content {
            flex: 1;
        }

        .item-content h3 {
            margin: 0;
            font-size: 16px;
        }

        .item-content p {
            margin: 5px 0;
            font-size: 14px;
            color: #666;
        }

        .item-content .price {
            font-weight: bold;
            font-size: 18px;
            color: #333;
        }

        .item-buttons {
            display: flex;
            gap: 10px;
        }

        .item-buttons button {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .item-buttons button:hover {
            background-color: #45a049;
        }
        
        .tradeInfo {
        	display: inline-block;
			margin: 5px !important;        	
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .item {
                flex-direction: column;
                align-items: flex-start;
            }

            .item img {
                width: 100%;
                height: auto;
                margin-right: 0;
                margin-bottom: 10px;
            }

            .item-buttons {
                flex-direction: column;
                width: 100%;
            }

            .item-buttons button {
                width: 100%;
            }
        }
    </style>
</head>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<body>
<div class="tradeContainer">
    <!-- 상단 메뉴 -->
    <h1>거래 내역 조회</h1>
    
    <div class="menu">
        <div class="active" id="sellingTab">판매중</div>
        <div id="requestTab">진행중</div>
        <div id="completeTab">거래완료</div>
    </div>

    <!-- 판매중 리스트 -->
    <div id="sellingList">
    	
       <c:if test="${empty sellingVO}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	   </c:if>
    
       <c:forEach var="selling" items="${sellingVO}">
	        <div class="item" onclick="window.location.href='/product/detail?prodId=${selling.prodId}'">
	            <img src="${selling.prodPhotoPath}" alt="제품사진">
	            <div style="display:flex; flex-wrap: wrap;">
	                <strong class="tradeInfo" style="flex-basis: 100%;">${selling.prodName}</strong>
	                <p class="tradeInfo">${selling.cityAndDistrict}</p>
	                <p class="tradeInfo">${selling.relativeTime}</p>
	                <p class="tradeInfo">${selling.formattedPrice}원</p>
	            </div>
	        </div>
		</c:forEach>
    </div>

    <!-- 진행중 리스트 -->
    <div id="requestList" style="display: none;">
    	
    	<c:if test="${empty requestVO}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	    </c:if>
    
        <c:forEach var="request" items="${requestVO}">
	        <div class="item" onclick="window.location.href='/product/detail?prodId=${request.prodId}'">
	            <img src="${request.prodPhotoPath}" alt="제품사진">
	            <div style="display:flex; flex-wrap: wrap;">
	                <strong class="tradeInfo" style="flex-basis: 100%;">${request.prodName}</strong>
	                <p class="tradeInfo">${request.cityAndDistrict}</p>
	                <p class="tradeInfo">${request.relativeTime}</p>
	                <p class="tradeInfo">${request.formattedPrice}원</p>
	            </div>
	        </div>
		</c:forEach>
    </div>

    <!-- 거래완료 리스트 -->
    <div id="completeList" style="display: none;">
    
    	<c:if test="${empty completeVO}">
   		   <p style="text-align: center;">내역이 없습니다.</p>
	    </c:if>
    	
        <c:forEach var="complete" items="${completeVO}">
	        <div class="item" onclick="window.location.href='/product/detail?prodId=${complete.prodId}'">
	            <img src="${complete.prodPhotoPath}" alt="제품사진">
	            <div style="display:flex; flex-wrap: wrap;">
	                <strong class="tradeInfo" style="flex-basis: 100%;">${complete.prodName}</strong>
	                <p class="tradeInfo">${complete.cityAndDistrict}</p>
	                <p class="tradeInfo">${complete.relativeTime}</p>
	                <p class="tradeInfo">${complete.formattedPrice}원</p>
	            </div>
	        </div>
		</c:forEach>
    </div>
</div>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
<script>
    // 탭 전환 기능
    const sellingTab = document.getElementById("sellingTab");
    const requestTab = document.getElementById("requestTab");
    const completeTab = document.getElementById("completeTab");

    const sellingList = document.getElementById("sellingList");
    const requestList = document.getElementById("requestList");
    const completeList = document.getElementById("completeList");

    sellingTab.addEventListener("click", () => showTab("selling"));
    requestTab.addEventListener("click", () => showTab("request"));
    completeTab.addEventListener("click", () => showTab("complete"));

    function showTab(tab) {
        // 탭 초기화
        sellingTab.classList.remove("active");
        requestTab.classList.remove("active");
        completeTab.classList.remove("active");

        sellingList.style.display = "none";
        requestList.style.display = "none";
        completeList.style.display = "none";

        // 선택된 탭 활성화
        if (tab === "selling") {
            sellingTab.classList.add("active");
            sellingList.style.display = "block";
        } else if (tab === "request") {
            requestTab.classList.add("active");
            requestList.style.display = "block";
        } else if (tab === "complete") {
            completeTab.classList.add("active");
            completeList.style.display = "block";
        }
    }
</script>

</body>
</html>
