<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 물건 팔기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sell_main.css">
</head>

<body>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/inc/modal/cropInfoModal.jsp"></jsp:include>
<div class="container-s">
    <form id="itemForm" enctype="multipart/form-data" action="register" method="post">
        <h4>내 물건 팔기</h4>

        <!-- 이미지 업로드 -->
        <div class="mb-3">
            <label for="imageUpload">사진 (최대 10개)</label>
            <div class="image-upload">
                <label for="imageUpload">
                    <span>+</span>
                    <small>이미지 추가</small>
                    <input type="file" id="imageUpload" name="imageUpload" style="display: none;" multiple accept="image/*">
                </label>
                <div id="imagePreview"></div>
            </div>
            <small id="imageCount">0/10</small>
        </div>
        
        <div id="loading-message">농산물 품질 분석 중...</div>
        
        <!-- 자동완성 여부 -->
        <div class="mb-3">
            <label for="autoCompleteSwitch" class="form-label">자동완성</label>
            <div class="switch-wrapper">
                <input type="checkbox" id="autoCompleteSwitch" class="toggle-switch-sell">
                <label for="autoCompleteSwitch" class="switch-label"></label>
            </div>
        </div>
        
        <!-- prodCategory 입력 필드 -->
        <div class="mb-3">
            <label for="prodCategoryInput">카테고리</label>
            <input type="text" id="prodCategoryInput" name="prodCategory" placeholder="카테고리를 입력하세요">
            <input type="hidden" id="cropNameGpt">
        </div>

        <!-- 제목 -->
        <div class="mb-3">
            <label for="prodName">제목</label>
            <input type="text" id="prodName" name="prodName" placeholder="제목을 입력해주세요">
        </div>

        <!-- 거래 방식 -->
        <div class="mb-3">
            <label>거래 방식</label>
            <div class="radio-button-group">
                <div class="form-check">
                    <input type="radio" id="prodOption" name="tradeOption" value="판매하기" checked>
                    <label for="prodOption">판매하기</label>
                </div>
                <div class="form-check">
                    <input type="radio" id="giveOption" name="tradeOption" value="나눠주기">
                    <label for="giveOption">나눠주기</label>
                </div>
            </div>
        </div>

        <!-- 가격 -->
        <div class="mb-3">
            <label for="price">가격</label>
            <input type="number" id="price" name="prodPrice" placeholder="가격을 입력해주세요" required>
        </div>

        <!-- 상세 설명 -->
        <div class="mb-3">
            <label for="description">자세한 설명</label>
            <textarea id="description" name="prodContent" rows="5" placeholder="내용을 입력해주세요"></textarea>
        </div>

        <!-- 거래 희망 장소 -->
        <div class="mb-3">
            <label for="fullAddr">거래 희망 장소</label>
            <input type="text" id="fullAddr" name="prodPlace" placeholder="주소를 입력해주세요" readonly>
            <button type="button" onclick="fn_search()" class="btn-sell">주소 검색</button>
        </div>
        <!-- 숨겨진 좌표 필드 추가 -->
        <input type="hidden" id="latitude" name="latitude">
        <input type="hidden" id="longitude" name="longitude">
        
        <!-- 지도 컨테이너 추가 -->
        <div id="map" style="width:100%;height:350px;margin-top:15px;"></div>

        <!-- 작성하기 버튼 -->
        <div>
            <button type="submit" class="btn-sell">작성하기</button>
        </div>
    </form>
</div>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services"></script>
<script> 
//체크박스 요소 가져오기
var autoCompleteSwitch = document.getElementById("autoCompleteSwitch");

// 이벤트 리스너 추가
$('#autoCompleteSwitch').change(function () {
    if (this.checked) {
        console.log("자동완성: 활성화됨");

        var cropType = $('#cropNameGpt').val().trim();
        console.log(cropType);
        if (!cropType) {
            alert("카테고리를 입력해주세요.");
            this.checked = false;
            return;
        }

        $.ajax({
            url: '/api_auto/generate',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify({ category: cropType }),
            success: function (data) {
                if (data.error) {
                    console.error("Error from server:", data.error);
                    alert("자동완성 데이터를 가져오는 중 오류가 발생했습니다.");
                } else {
                    console.log("자동완성 결과:", data);
                    $('#prodName').val(data.title || '');
                    $('#description').val(data.content || '');
                }
            },
            error: function (xhr, status, error) {
                console.error("AJAX Error:", status, error);
                alert("Flask 서버와의 통신 중 오류가 발생했습니다.");
            }
        });
    } else {
        console.log("자동완성: 비활성화됨");
        $('#prodName').val('');
        $('#description').val('');
    }
});

// 첫 번째 사진 전송 및 미리보기
$('#imageUpload').change(function () {
    var files = this.files;
    if (files.length > 0) {
        var firstFile = files[0];
        sendFirstImageToServer(firstFile);
    }
});

function sendFirstImageToServer(file) {
    var loadingMessage = document.getElementById('loading-message');
    loadingMessage.style.display = 'block';

    var formData = new FormData();
    formData.append('file', file);

    setTimeout(function () { // 서버 요청 전에 딜레이 추가
        $.ajax({
            url: '/image/predict',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                console.log('Flask 서버 응답:', response);

                if (response && response.cropNameGpt && response.cropNameKr && response.qualityDesc) {
                    $('#prodCategoryInput').val(response.cropNameKr + ' (' + response.qualityDesc + ')');
                    $('#cropNameGpt').val(response.cropNameGpt);
                    // 모달 내용 업데이트
                    $('#cropType').text(response.cropNameGpt || '알 수 없음');
                    $('#cropQuality').text((response.cropNameKr || '알 수 없음') + ' (' + (response.qualityDesc || '설명 없음') + ')');
                    $('#cropPrice').text('2,480원_최근 일주일 평균');

                    // 모달 표시
                    var modal = new bootstrap.Modal(document.getElementById('cropInfoModal'));
                    modal.show();
                } else {
                    alert('분석 결과를 가져올 수 없습니다. 데이터를 확인하세요.');
                }
            },
            error: function (xhr, status, error) {
                console.error('Flask 서버 통신 에러:', error);
                alert('Flask 서버와의 통신에 실패했습니다.');
            },
            complete: function () {
                loadingMessage.style.display = 'none';
            }
        });
    }, 1000); // 1초 대기
}

// 이미지 미리보기 렌더링
var imageUpload = document.getElementById('imageUpload');
var imagePreview = document.getElementById('imagePreview');
var imageCount = document.getElementById('imageCount');
var selectedFiles = [];

imageUpload.addEventListener('change', function () {
    var files = Array.prototype.slice.call(imageUpload.files);
    if (selectedFiles.length + files.length > 10) {
        alert('최대 10개의 이미지만 업로드 가능합니다.');
        return;
    }
    selectedFiles = selectedFiles.concat(files);
    renderImagePreview();
});

function renderImagePreview() {
    imagePreview.innerHTML = '';
    for (var i = 0; i < selectedFiles.length; i++) {
        (function (index) {
            var file = selectedFiles[index];
            var reader = new FileReader();
            reader.onload = function (e) {
                var container = document.createElement('div');
                container.classList.add('image-container');

                var img = document.createElement('img');
                img.src = e.target.result;

                var overlay = document.createElement('div');
                overlay.classList.add('image-overlay');
                overlay.textContent = index === 0 ? '메인 이미지' : '';

                var removeBtn = document.createElement('span');
                removeBtn.classList.add('remove-image');
                removeBtn.textContent = 'X';
                removeBtn.addEventListener('click', function () {
                    removeImage(index);
                });

                container.appendChild(img);
                container.appendChild(overlay);
                container.appendChild(removeBtn);
                imagePreview.appendChild(container);
            };
            reader.readAsDataURL(file);
        })(i);
    }
    imageCount.textContent = selectedFiles.length + '/10';
}

function removeImage(index) {
    selectedFiles.splice(index, 1);
    renderImagePreview();
}

// 지도 생성 및 주소 검색
var mapContainer = document.getElementById('map');
var mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667),
    level: 3
};
var map = new kakao.maps.Map(mapContainer, mapOption);
var geocoder = new kakao.maps.services.Geocoder();
var marker = null;

function fn_search() {
    new daum.Postcode({
        oncomplete: function (data) {
            var addr = data.address;
            document.getElementById('fullAddr').value = addr;
            geocoder.addressSearch(addr, function (result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    document.getElementById('latitude').value = result[0].y;
                    document.getElementById('longitude').value = result[0].x;

                    if (marker) marker.setMap(null);

                    marker = new kakao.maps.Marker({
                        map: map,
                        position: coords
                    });

                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="width:150px;text-align:center;padding:6px 0;">' + addr + '</div>'
                    });
                    infowindow.open(map, marker);
                    map.setCenter(coords);
                } else {
                    alert("주소를 검색할 수 없습니다.");
                }
            });
        }
    }).open();
}

// 폼 제출 시 유효성 검사
document.getElementById('itemForm').addEventListener('submit', function (event) {
    var isValid = true;
    var errorMessage = "";

    var prodCategory = document.getElementById('prodCategoryInput').value.trim();
    var prodName = document.getElementById('prodName').value.trim();
    var prodPrice = document.getElementById('price').value.trim();
    var prodContent = document.getElementById('description').value.trim();
    var prodPlace = document.getElementById('fullAddr').value.trim();

    if (!prodCategory) {
        isValid = false;
        errorMessage += "카테고리를 입력하세요.\n";
    }
    if (!prodName) {
        isValid = false;
        errorMessage += "제목을 입력하세요.\n";
    }
    if (!prodPrice || prodPrice < 0) {	
        isValid = false;
        errorMessage += "유효한 가격을 입력하세요.\n";
    }
    if (!prodContent) {
        isValid = false;
        errorMessage += "내용을 입력하세요.\n";
    }
    if (!prodPlace) {
        isValid = false;
        errorMessage += "거래 희망 장소를 입력하세요.\n";
    }

    if (!isValid) {
        alert(errorMessage);
        event.preventDefault();
    }
});

$('input[name="tradeOption"]').change(function () {
    // 선택된 옵션 값
    var selectedOption = $(this).val();

    if (selectedOption === "나눠주기") {
        // "나눠주기" 선택 시 가격 0 설정, 입력 필드 비활성화 및 연한 회색 배경
        $('#price').val(0);
        $('#price').prop('disabled', true);
        $('#price').css('background-color', '#f0f0f0');
    } else { // "판매하기" 선택 시
        // 입력 필드 활성화 및 원래 배경색 복원
        $('#price').prop('disabled', false);
        $('#price').css('background-color', '');
    }
});
</script>
</html>
