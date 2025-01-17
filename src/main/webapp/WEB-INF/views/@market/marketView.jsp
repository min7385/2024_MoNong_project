<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Market View</title>
    <link rel="stylesheet" href="/css/marketView.css">
</head>
<body>
    <div class="market-container">
        <!-- 상단 선택된 데이터 -->
        <div class="selected-item">
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTSWfzybKGElxEnClAVEGCDCI1gUyGKp69yw&s" alt="당근" class="selected-image">
            <div class="selected-info">
                <h3>당근</h3>
                <p>가격: $10</p>
                <p>날짜: 2024.12.12</p>
            </div>
        </div>

        <!-- 하단 카드 섹션 -->
        <div class="card-section">
            <c:forEach var="i" begin="1" end="10">
                <jsp:include page="/WEB-INF/inc/priceCard.jsp"></jsp:include>
            </c:forEach>
        </div>
     </div>
</body>
</html>
