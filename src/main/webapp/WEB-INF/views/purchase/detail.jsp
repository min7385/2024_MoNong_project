<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상세 페이지</title>
    <style>

   body {
        margin: 0;
        padding: 0;
        background-color: var(--background-color);
        color: var(--text-color);
    }

    .container-d {
        max-width: 800px;
        width: 90%; /* 모바일에서 자연스럽게 줄어들도록 설정 */
        margin: 20px auto;
        background-color: var(--light-color);
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* 지도 이미지 */
    .map {
        width: 100%;
        margin-top: 20px;
        text-align: center;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
    }

    .map img {
        width: 100%;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .title {
        text-align: center;
        font-size: 1.8rem;
        color: var(--primary-color);
        margin-bottom: 20px;
    }

    .carousel {
        margin-bottom: 15px;
        overflow: hidden; /* 슬라이드 영역 바깥 내용 숨김 */
    }

    .carousel-inner img {
        width: 100%;
        height: 300px; /* 고정 높이 설정 */
        object-fit: contain; /* 이미지 비율 유지하며 자르지 않음 */
        border-radius: 8px;
    }

    .details {
        display: flex;
        flex-direction: column;
        gap: 20px;
        background-color: #f9f9f9;
        padding: 15px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
    }

    .details div {
        font-size: 1rem;
        line-height: 1.5;
    }

    .profile {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .profile img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
    }

    .info {
        display: grid;
        gap: 10px;
    }

    .info div {
        align-items: center;
        justify-content: space-between;
    }

    .info div strong {
        margin-right: 5px;
        white-space: nowrap;
    }

    .price {
        font-size: 1.2rem;
        font-weight: bold;
        color: var(--primary-color);
    }
    
    .btn-cus {
        display: block;
        width: 100%;
        padding: 10px;
        font-size: 16px;
        color: var(--light-color);
        background-color: var(--accent-color);
        border: none;
        border-radius: 5px;
        text-align: center;
        cursor: pointer;
        margin-top: 20px;
        transition: background-color 0.3s;
    }

    .btn-cus:hover {
        background-color: #e66f00;
    }
    
    .carousel-control-prev-icon,
    .carousel-control-next-icon {
        background-color: rgba(0, 0, 0, 0.5); /* 반투명 검정색 배경 */
        border-radius: 50%; /* 원형으로 보이도록 설정 */
        width: 40px;
        height: 40px;
    }

    .carousel-control-prev-icon::after,
    .carousel-control-next-icon::after {
        color: white; /* 화살표 아이콘 색상 */
        font-size: 1.2rem; /* 아이콘 크기 조정 */
    }

    @media (max-width: 768px) {
        .title {
            font-size: 1.5rem;
        }

        .details div {
            font-size: 0.9rem;
        }

        .carousel-inner img {
            height: 200px; /* 모바일 화면에서 적절한 높이 설정 */
        }
    }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<div class="container-d">
    <!-- 상품 제목 -->
    <h1 class="title">${product.prodName}</h1>

    <!-- 이미지 슬라이드 (Carousel) -->
    <div id="photoCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
            <c:forEach var="photo" items="${photoList}" varStatus="status">
                <div class="carousel-item ${status.first ? 'active' : ''}">
                    <img src="${photo.prodPhotoPath}" class="d-block w-100" alt="이미지 ${status.index + 1}">
                </div>
            </c:forEach>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#photoCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">이전</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#photoCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">다음</span>
        </button>
    </div>

 <div class="details">
    <!-- 프로필, 닉네임, 신뢰도 -->
    <div class="profile">
        <img src="<c:choose>
                      <c:when test='${empty product.memProfile}'>/static/uploads/non.png</c:when>
                      <c:otherwise>${product.memProfile}</c:otherwise>
                  </c:choose>" alt="프로필 이미지">
        <div><strong>판매자:</strong> <span>${product.memNic}</span></div>
        <div><strong>신뢰도:</strong> <span>${product.memReliability}%</span></div>
    </div>

    <!-- 판매 정보 -->
    <div class="info">
        <div><strong>판매 지역:</strong> <span>${product.prodPlace}</span></div>
        <div><strong>품목:</strong> <span>${product.prodCategory}</span></div>
        <div>
		    <strong>가격:</strong>
		    <span>
		        <c:choose>
		            <c:when test="${product.prodPrice == 0}">
		                <span style="color: #006400; font-weight: bold;">나눔하기</span>
		            </c:when>
		            <c:otherwise>
		                <span style="color: #006400; font-weight: bold;">${product.formattedPrice}원</span>
		            </c:otherwise>
		        </c:choose>
		    </span>
		</div>
        <div><strong>등록일:</strong> <span>${product.createDt}</span></div>
    </div>

    <!-- 상품 설명 -->
    <div>
        <strong>상품 설명:</strong>
        <div>${product.prodContent}</div>
    </div>
</div>

    
    <!-- 지도 -->
    <div class="map">
        <h4 style="margin-top: 10px;">거래 희망 지역</h4>
        <!-- 지도 컨테이너 추가 -->
    	<div id="map" style="width:100%;height:350px;margin-top:15px;"></div>
    </div>

	<!-- 구매하기 또는 채팅 리스트 보기 버튼 -->
	<c:choose>
	    <c:when test="${userInfo.memId == product.prodSeller}">
	        <form method="get" action="<c:url value='/tradeChatList' />">
	            <input type="hidden" value="${product.prodId}" name="prodId">
	            <button class="btn-cus" type="submit">채팅 리스트 보기</button>
	        </form>
	    </c:when>
	    <c:otherwise>
	        <form id="chatsend" method="post" action="<c:url value='/chat' />">
	            <input type="hidden" value="${product.prodId}" name="chatProdId">
	            <input type="hidden" value="${product.prodSeller}" name="chatSeller">
	            <input type="hidden" value="${userInfo.memId}" id="chatBuyer" name="chatBuyer">
	            <button class="btn-cus" id="btn" type="button" onclick="sendChat();">구매하기</button>
	        </form>
	    </c:otherwise>
	</c:choose>
   
</div>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services"></script>
<script>
	document.addEventListener('DOMContentLoaded', function () {
		
		
	});
	function sendChat(){
		var userId = document.getElementById('chatBuyer').value;
		if(userId ==""){
			alert("로그인 하세요");
			return;
		}
		document.getElementById('chatsend').submit();
	}

	
    
 // JSP에서 전달된 sellRegion 값을 JavaScript 변수에 할당
    var sellRegion = '${product.prodPlace}';

    // Kakao 지도 초기화
    var mapContainer = document.getElementById('map'),
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 초기 지도 중심 좌표 (기본값)
            level: 3 // 초기 확대 레벨
        };

    // 지도 생성
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 주소-좌표 변환 객체 생성
    var geocoder = new kakao.maps.services.Geocoder();

    // 지도 마커 변수
    var marker = null;

    // sellRegion 주소로 좌표를 검색하여 지도에 표시
    if (sellRegion) {
        geocoder.addressSearch(sellRegion, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                // 마커 생성
                marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                // 인포윈도우 추가
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="width:150px;text-align:center;padding:6px 0;">' + sellRegion + '</div>'
                });
                infowindow.open(map, marker);

                // 지도 중심 좌표 이동
                map.setCenter(coords);
            } else {
                alert("주소를 검색할 수 없습니다.");
            }
        });
    } else {
        alert("표시할 주소가 없습니다.");
    }
    

</script>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>
</html>