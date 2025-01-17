<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>농사 팁 게시판</title>

    <!-- Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">

    <!-- 다이어리 작성 CSS 파일 링크 추가 -->
    <link rel="stylesheet" href="/css/diary_create.css">

    <!-- Summernote JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

<div class="unique-wrapper">


    <div class="unique-content">
        <h2>게시글 작성</h2>

        <!-- 제목 입력란 추가 -->
        <div class="unique-input-container">
            <label for="postTitle">제목</label>
            <input type="text" id="postTitle" placeholder="게시글 제목을 입력하세요" />
        </div>

        <!-- Summernote 에디터 -->
        <textarea id="summernote"></textarea>

        <!-- 글 작성 버튼 -->
        <button class="unique-cancel-button" onclick="cancelPost()">취소</button>
        <button class="unique-write-button" onclick="savePost()">글 작성하기</button>
    </div>
</div>

<script>
    var lastUploadedImageUrl = ''; // 마지막으로 업로드된 이미지 URL을 저장할 변수
    var userId = 'defaultId';      // 사용자 ID
    var writer = 'defaultWriter';  // 작성자 이름

    $(document).ready(function() {
        // JWT 파싱 함수
        function parseJwt(token) {
            try {
                var base64Url = token.split('.')[1];
                var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
                var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));

                return JSON.parse(jsonPayload);
            } catch (e) {
                console.error('JWT 파싱 실패:', e);
                return {};
            }
        }

        // 쿠키에서 특정 이름의 쿠키 값을 추출하는 함수
        function getCookie(name) {
            let matches = document.cookie.match(new RegExp(
                '(?:^|; )' + name.replace(/([$?*|{}()[]\/+^])/g, '\\$1') + '=([^;]*)'
            ));
            return matches ? decodeURIComponent(matches[1]) : undefined;
        }

        // JWT 토큰 추출
        var token = getCookie('accessToken'); // 쿠키 이름을 'accessToken'으로 변경
        if (token) {
            var decoded = parseJwt(token);
            userId = decoded.sub || userId;
            writer = decoded.name || writer;
        } else {
            console.warn('JWT 토큰이 존재하지 않습니다.');
        }

        console.log('Extracted userId:', userId);
        console.log('Extracted writer:', writer);

        // 사용자 인증 여부 확인
        if (userId === 'defaultId' || writer === 'defaultWriter') {
            alert('사용자 인증에 실패했습니다. 다시 로그인해주세요.');
            // 필요 시 로그인 페이지로 리다이렉트
            window.location.href = '/auth/loginView';
            return;
        }

        // Summernote 초기화
        $('#summernote').summernote({
            height: 500, // 에디터 높이
            placeholder: '여기에 글을 작성해주세요...',
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['link', 'picture']] // 이미지 삽입 기능
            ],
            callbacks: {
                // 이미지 업로드 후 서버로 전송
                onImageUpload: function(files) {
                    var formData = new FormData();
                    var file = files[0];
                    formData.append("file", file);

                    var fileName = file.name;
                    var headers = {
                        "file-name": fileName // 서버가 사용할 file-name 헤더
                    };

                    // 서버에 이미지 업로드 요청
                    $.ajax({
                        url: '/files/upload', // 서버 이미지 업로드 처리 URL
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        headers: headers, // 헤더 추가
                        success: function(response) {
                            var imgUrl = response.imagePath;

                            if (imgUrl) {
                                var imgTag = '<img src="' + imgUrl + '" alt="Uploaded Image" />';
                                $('#summernote').summernote('insertNode', $(imgTag)[0]);

                                // 마지막으로 업로드된 이미지 URL을 저장
                                lastUploadedImageUrl = imgUrl;
                            }
                        },
                        error: function(xhr, status, error) {
                            console.log('이미지 업로드 실패:', error);
                        }
                    });
                }
            }
        });
    });

    // 글 작성 후 저장하는 함수
    function savePost() {
        var title = $('#postTitle').val().trim();
        var content = $('#summernote').val().trim();

        if (title === "") {
            alert('제목을 입력해주세요.');
            return;
        }

        if (content === "") {
            alert('내용을 입력해주세요.');
            return;
        }

        console.log('제목:', title);
        console.log('작성된 글:', content);

        // memId와 diaryWriter를 쿠키에서 읽어서 전송
        var memId = userId; // 이미 추출된 userId
        var diaryWriter = writer; // 이미 추출된 writer

        console.log('memId:', memId);
        console.log('diaryWriter:', diaryWriter);

        // 마지막 업로드된 이미지 URL을 DIARY_IMAGE 필드에 추가하여 전송
        var postData = {
            title: title,                     // 서버가 기대하는 'title'
            content: content,                 // 서버가 기대하는 'content'
            diaryImage: lastUploadedImageUrl, // 'diaryImage'
            memId: memId,                     // 'memId'
            diaryWriter: diaryWriter          // 'diaryWriter'
        };

        console.log('Sending data:', postData);

        // 서버로 데이터 전송 (폼 데이터 형식)
        $.ajax({
            url: '/diary/write',  // 게시글 작성 처리 URL
            type: 'POST',
            data: postData, // 폼 데이터로 전송
            success: function(response) {
                console.log('게시글 저장 성공:', response);
                // 서버가 redirect 응답을 보내므로, 브라우저가 이를 따라가게 함
                window.location.href = '/diary/list';
            },
            error: function(xhr, status, error) {
                console.log('게시글 저장 실패:', error);
                alert('게시글 저장에 실패했습니다. 다시 시도해주세요.');
            }
        });
    }

    // 취소 버튼 클릭 시
    function cancelPost() {
        window.location.href = '/diary/list'; // 취소 시 목록 페이지로 리다이렉트
    }
</script>

<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

</body>
</html>
