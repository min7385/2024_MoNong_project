<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>농작물 상태 체크</title>
    <style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* 메인 콘텐츠 스타일 */
body {
    background-color: #f9f9f9;
    color: #333;
    padding: 0; /* 헤더와 충돌 방지 */
    margin: 0;
    display: flex;
    flex-direction: column; /* 헤더, 메인, 푸터 분리 */
}

.header {
    padding: 20px 0;
    text-align: center;
    background-color: #005100;
    color: white;
    margin-bottom: 20px;
}

/* 메인 컨테이너 스타일 */
.container-c {
    width: 90%;
    max-width: 1200px;
    margin: 20px auto;
    min-height: 70vh;
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.result-text {
    font-size: 1.2rem; /* 원하는 폰트 크기로 설정 */
}

#uploadForm {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px; /* 버튼과 파일 업로드 영역 간격 */
}

/* 파일 업로드 영역 스타일 */
.custom-file-upload {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 15px 30px; /* 여백 축소 */
    border: 2px dashed #007bff; /* 파란색 테두리 */
    border-radius: 10px;
    background-color: #f0f8ff; /* 밝은 파란색 배경 */
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.custom-file-upload:hover {
    background-color: #e0f3ff; /* 호버 시 더 밝은 배경 */
    border-color: #0056b3; /* 진한 파란색 테두리 */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15);
}

.custom-file-upload p {
    font-size: 1rem; /* 글자 크기 축소 */
    color: #333;
    font-weight: normal; /* 굵기 조정 */
}

/* 버튼 스타일 */
.btn-primary {
    background: linear-gradient(135deg, #007bff, #0056b3); /* 파란색 그라디언트 */
    color: white;
    padding: 20px 60px; /* 버튼 크기 확대 */
    border: none;
    border-radius: 12px; /* 둥근 모서리 */
    font-size: 1.4rem; /* 텍스트 크기 확대 */
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
}

.btn-primary:hover {
    background: linear-gradient(135deg, #0056b3, #003f7f); /* 호버 시 진한 파란색 */
    box-shadow: 0 12px 20px rgba(0, 0, 0, 0.3);
    transform: translateY(-3px); /* 살짝 위로 이동 */
}

.btn-primary:active {
    transform: translateY(0); /* 클릭 시 원래 위치로 복귀 */
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
}

#file {
    display: none; /* 기본 파일 인풋 숨김 */
}

#previewContainer {
    position: relative;
    display: none; /* 초기 상태에서 숨김 */
    justify-content: center; /* 가로 중앙 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    margin: 20px auto; /* 상하 마진 자동 */
    width: 100%; /* 컨테이너 너비 */
    max-width: 350px; /* 이미지 크기에 맞게 제한 */
}

#previewImage {
    max-width: 100%; /* 부모 요소에 맞게 */
    border-radius: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

#resultImage {
    max-width: 350px;
    width: auto;
    height: auto;
    border-radius: 15px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
    opacity: 0; /* 초기값 숨김 */
    transform: scale(0.9); /* 살짝 축소된 상태로 시작 */
    transition: opacity 1s ease-in-out, transform 1s ease-in-out; /* 트랜지션 추가 */
}

#resultText {
    font-weight: bold; /* 글씨 두껍게 */
    text-align: center; /* 중앙 정렬 */
    font-size: 1.5rem; /* 기본 글씨 크기 */
    color: #333; /* 기본 글씨 색상 */
    margin-top: 10px;
    transition: font-size 0.3s ease; /* 크기 변경 시 부드러운 전환 */
}

.scan-line {
    position: absolute;
    width: 100%; /* 이미지 너비에 맞춤 */
    height: 8px;
    background: linear-gradient(90deg, rgba(0, 174, 255, 0) 0%, rgba(0, 174, 255, 1) 50%, rgba(0, 174, 255, 0) 100%);
    box-shadow: 0 0 20px 5px rgba(0, 174, 255, 0.8);
    z-index: 10;
}

.scan-line-1 {
    top: 0; /* 이미지 상단에서 시작 */
    animation: scan1 3s ease-in-out infinite;
}

.scan-line-2 {
    top: calc(100% - 8px); /* 이미지 하단에서 시작 */
    animation: scan2 3s ease-in-out infinite;
    background: linear-gradient(90deg, rgba(0, 123, 255, 0) 0%, rgba(0, 123, 255, 1) 50%, rgba(0, 123, 255, 0) 100%);
    box-shadow: 0 0 20px 5px rgba(0, 123, 255, 0.8);
}

@keyframes scan1 {
    0% { top: 0; }
    50% { top: 50%; }
    100% { top: 100%; }
}

@keyframes scan2 {
    0% { top: 100%; }
    50% { top: 50%; }
    100% { top: 0; }
}

/* 분석 중 메시지 */
#loading-message {
    display: none;
    font-size: 1.5rem;
    color: rgba(0, 0, 0, 0.8);
    text-align: center;
    margin-top: 20px;
    animation: blink 1.2s infinite;
}

@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

#resultContent {
    margin-top: 20px;
    display: flex;
    justify-content: center; /* 가로 중앙 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    flex-direction: column; /* 이미지와 아코디언 세로 정렬 */
}

#accordionContainer {
    min-width: 80%;
    margin-top: 20px;
}

.accordion-button {
    background-color: #e8f5e9;
    color: #004d40;
    font-weight: bold;
    border: none;
}

.accordion-button:not(.collapsed) {
    background-color: #c8e6c9;
    color: #003d33;
}

.accordion-body {
    background-color: #f1f8e9;
    font-size: 16px;
}

#tooltip {
    display: none;
    position: absolute;
    background-color: #ffffff;
    color: #333;
    padding: 12px;
    border: 1px solid #007bff;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    font-size: 0.9em;
    line-height: 1.5;
    z-index: 1000;
    width: 250px;
}

#tooltip::before {
    content: '';
    position: absolute;
    top: -10px;
    left: 20px;
    border-width: 5px;
    border-style: solid;
    border-color: transparent transparent #007bff transparent;
}

@media (max-width: 768px) {
    #uploadForm {
        flex-direction: column;
        gap: 10px; /* 버튼 간 간격 추가 */
    }

    #uploadForm input {
        width: 100%;
    }

    .container-c {
        width: 95%;
        padding-top: 60px; /* 모바일 헤더 높이에 따라 조정 */
    }

    #resultContent {
        text-align: center;
    }

    #accordionContainer {
        width: 100%;
    }

    h1 {
        font-size: 1.5rem; /* 헤더 크기 축소 */
    }

    .result-text {
        font-size: 1rem; /* 결과 텍스트 크기 조정 */
    }
}
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
		<div class="header">
			<h1>농작물 상태확인</h1>
		<div class="sub-header">키우고 있는 농작물 사진을 업로드하면 현재 상태를 분석하여 정상인지, 병충해가 있는지 결과를 알려줍니다.</div>
	</div>
	<div class="container-c">
    	<!-- 파일 업로드 및 분석 버튼 -->
        <form id="uploadForm" enctype="multipart/form-data" class="d-flex align-items-center mb-5">
	         <!-- 파일 업로드 영역 -->
	        <label class="custom-file-upload" for="file">
	            <p>이미지를 클릭하여 업로드하세요</p>
	            <input type="file" name="file" id="file">
	        </label>
            <input type="button" id="analyzeButton" value="분석하기" class="btn btn-primary" style="background-color: #005100;">
        </form>

        <!-- 미리보기 -->
        <div id="previewContainer">
            <img id="previewImage" src="https://via.placeholder.com/200" alt="미리보기 이미지" class="img-thumbnail">
            <div class="scan-line scan-line-1" id="scan-line-1" style="display: none;"></div>
            <div class="scan-line scan-line-2" id="scan-line-2" style="display: none;"></div>
        </div>

		<!-- 분석 중 메시지 -->
        <div id="loading-message">분석 중입니다...</div>
		
        <!-- 분석 결과 -->
        <div id="result" class="mt-4" style="display: none;">
        <p class="text-center" id="resultText"></p>
            <div id="resultContent">
                <div>
                    <img id="resultImage" alt="결과 이미지" class="img-thumbnail">
                    <p class="mt-2 text-center">분석된 이미지</p>
                </div>
                <div id="accordionContainer"></div>
            </div>
        </div>
    </div>


    <jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>
<script>
    $(document).ready(function () {
		const scanLine1 = document.getElementById('scan-line-1');
		const scanLine2 = document.getElementById('scan-line-2');
		const loading = $('#loading-message');
        const resultImage = $('#resultImage');
		
		// 이미지 미리보기
		$('#file').change(function () {
		    const reader = new FileReader();
		    reader.onload = function (e) {
		        $('#previewImage').attr('src', e.target.result);
		        $('#previewContainer').show(); // 이미지 선택 시 미리보기 컨테이너 표시
                $('#result').hide();
		    };
		    reader.readAsDataURL(this.files[0]);
		});

        // 분석 버튼 클릭
        $('#analyzeButton').click(function () {
        	const fileInput = $('#file').val();

            // 사진이 선택되지 않았으면 알림 표시 후 종료
            if (!fileInput) {
                alert('분석할 이미지를 선택해주세요.');
                return;
            }
        	// 로딩 스피너 표시
            loading.show();
            loading.css('display', 'block');
            // 스캔 애니메이션 표시
            scanLine1.style.display = 'block';
            scanLine2.style.display = 'block';

            // 3초 후 스캔 애니메이션 종료 및 결과 표시
            setTimeout(function () {
                scanLine1.style.display = 'none';
                scanLine2.style.display = 'none';
                $('#previewContainer').hide(); // 업로드된 이미지 숨김

                // 서버 요청
                $.ajax({
                    url: 'http://192.168.0.44:5000/analyze',
                    type: 'POST',
                    data: new FormData($('#uploadForm')[0]),
                    processData: false,
                    contentType: false,
                    success: function (response) {
                    	
                    	loading.hide(); // 로딩 스피너 숨김
                    	
                        if (response.crop_conditions && response.crop_conditions.length > 0) {
                            const imageBase64 = response.image;
                            $('#resultImage').attr('src', 'data:image/jpeg;base64,' + imageBase64);
                 
                            $('#result').show();
                         	// 이미지 부드럽게 나타남
                            resultImage.css('opacity', '1');
                            
                         	
                        // 아코디언 초기화
                        const cropConditions = response.crop_conditions;
                        const conditionName = cropConditions[0].CONDITION_NAME
                        const resultText = $('#resultText');
                        resultText.text(conditionName);
                        
                        // 상태에 따른 텍스트 색상 변경
                        if (conditionName === '정상') {
                            resultText.css('color', 'green');
                        } else {
                            resultText.css('color', 'red');
                        }
                        
                        const accordionContainer = $('#accordionContainer');
                        accordionContainer.empty();

                        // 아코디언 항목 생성
                        cropConditions.forEach(function (condition, index) {
                            accordionContainer.append(
                                '<div class="accordion" id="accordion' + index + '">' +
                                    '<div class="accordion-item">' +
                                        '<h2 class="accordion-header" id="headingExplanation' + index + '">' +
                                            '<button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExplanation' + index + '" aria-expanded="true" aria-controls="collapseExplanation' + index + '">' +
                                                '<strong>설명</strong>' +
                                            '</button>' +
                                        '</h2>' +
                                        '<div id="collapseExplanation' + index + '" class="accordion-collapse collapse show" aria-labelledby="headingExplanation' + index + '">' +
                                            '<div class="accordion-body">' +
                                                condition.EXPLANATION +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                    '<div class="accordion-item">' +
                                        '<h2 class="accordion-header" id="headingOccurrence' + index + '">' +
                                            '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOccurrence' + index + '" aria-expanded="false" aria-controls="collapseOccurrence' + index + '">' +
                                                '<strong>발생 원인</strong>' +
                                            '</button>' +
                                        '</h2>' +
                                        '<div id="collapseOccurrence' + index + '" class="accordion-collapse collapse" aria-labelledby="headingOccurrence' + index + '">' +
                                            '<div class="accordion-body">' +
                                                condition.OCCURRENCE +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                    '<div class="accordion-item">' +
                                        '<h2 class="accordion-header" id="headingSymptoms' + index + '">' +
                                            '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSymptoms' + index + '" aria-expanded="false" aria-controls="collapseSymptoms' + index + '">' +
                                                '<strong>증상</strong>' +
                                            '</button>' +
                                        '</h2>' +
                                        '<div id="collapseSymptoms' + index + '" class="accordion-collapse collapse" aria-labelledby="headingSymptoms' + index + '">' +
                                            '<div class="accordion-body">' +
                                                condition.SYMPTOMS +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                    '<div class="accordion-item">' +
                                        '<h2 class="accordion-header" id="headingPrevention' + index + '">' +
                                            '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePrevention' + index + '" aria-expanded="false" aria-controls="collapsePrevention' + index + '">' +
                                                '<strong>예방 및 방제</strong>' +
                                            '</button>' +
                                        '</h2>' +
                                        '<div id="collapsePrevention' + index + '" class="accordion-collapse collapse" aria-labelledby="headingPrevention' + index + '">' +
                                            '<div class="accordion-body">' +
                                                condition.PREVENTION +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>'
                            );
                        });
                    } else {
                        $('#noResult').show();
                    }
                },
                error: function () {
                    alert('이미지 처리 중 오류가 발생했습니다.');
                }
            });
        }, 3000); // 애니메이션 종료 후 서버 호출
    });
        
        
        // 툴팁 함수
        $('#infoIcon').hover(function (e) {
            const tooltip = $('#tooltip');
            tooltip.css({
                display: 'block',
                top: e.pageY + 10 + 'px',
                left: e.pageX + 10 + 'px'
            });
        }, function () {
            $('#tooltip').css('display', 'none');
        });
});
</script>
</html>