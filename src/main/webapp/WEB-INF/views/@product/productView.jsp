<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product View</title>
    <link rel="stylesheet" href="/css/productView.css">
    <script defer src="/js/productView.js"></script>
</head>
<body>
    
    <div class="container">
        <!-- 사진 및 유저 정보 섹션 -->
        <div class="photo-user-section">
            <div class="photo-carousel">
                <img src="data:image/jpeg;base64,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" alt="Product Image 1" class="product-photo">
                <img src="https://kormedi.com/wp-content/uploads/2023/10/ck-cm260029053-l-700x467.jpg" alt="Product Image 2" class="product-photo">
                <img src="https://dimg.donga.com/wps/NEWS/IMAGE/2024/03/07/123848601.7.jpg" alt="Product Image 3" class="product-photo">
            </div>
            <div class="user-info">
				<div class="user-info-container">
				    <div class="user-info-left">
				        <img src="https://image.ohou.se/i/bucketplace-v2-development/uploads/cards/snapshots/165797605390577282.jpeg?gif=1&w=480&h=480&c=c&q=80&webp=1" alt="User Profile" class="user-profile-photo">
				        <div class="user-details">
				            <h3 class="user-name">유엔빌리지다이소</h3>
				            <p class="user-location">한남동</p>
				        </div>
				    </div>
				    <div class="user-manner-temperature">
				        <span class="temperature">48.2°C</span>
				        <span class="manner-text">매너온도</span>
				    </div>
				</div>
            </div>
        </div>

        <!-- 게시글 정보 및 지도 섹션 -->
        <div class="post-map-section">
            <h1 class="product-title">면100% 골지소재 헌팅캡 (블랙)</h1>
            <p class="product-category">여성잡화 · 4시간 전</p>
            <p class="product-price">6,000원</p>
            <p class="product-description">
                골지소재의 부드러운 헌팅캡입니다. 1회 착용한 상태 최상급으로 뒷면의 버클로
                조절 가능합니다. 세로단면 약 15cm 둘레 약 55-59 얼굴이 작아보이는 효과도 있어 추천드리며
                택배 및 직거래 가능합니다.
            </p>
            <div class="map-container">
                <img src="/images/map-placeholder.png" alt="Map Location" class="map-image">
            </div>
            <button class="purchase-button">구매하기</button>
        </div>
    </div>
    
</body>
</html>
