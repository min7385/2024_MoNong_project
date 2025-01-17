<!-- 농사 재배 Tip 게시판 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>농사 재배 팁 게시판</title>
    
    <!-- Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        .wrapper {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            background-color: #fff; /* 배경을 흰색으로 변경 */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header {
            padding: 20px 0;
            text-align: center;
            background-color: #4CAF50;
            color: white;
            border-radius: 10px;
        }

        .header h1 {
            margin: 0;
            font-size: 36px;
            font-weight: bold;
        }

        .sub-header {
            font-size: 16px;
            color: #eee;
            margin-top: 10px;
        }

        /* 게시글 작성 버튼 */
        .cancel-button {
            padding: 10px 20px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        .cancel-button:hover {
            background-color: #ac0202;
        }

                /* 게시글 작성 버튼 */
                .write-button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        .write-button:hover {
            background-color: #45a049;
        }

        /* Summernote 스타일 */
        .note-editor {
            border-radius: 10px;
            border: 1px solid #ddd;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .image-container {
            margin-top: 20px;
            text-align: center;
        }

        .image-container img {
            max-width: 100%;
            height: auto;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* 반응형 디자인 */
        @media screen and (max-width: 768px) {
            .input-container {
                flex-direction: column;
            }

            .input-container input,
            .input-container button {
                width: 100%;
            }

            .post-info {
                flex-direction: column;
                align-items: center;
            }

            .post-content img {
                width: 100%;
            }
        }
    </style>
    
    <!-- Summernote JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>
</head>
<body>

<div class="wrapper">
    <!-- 상단 제목과 설명 -->
    <div class="header">
        <h1>농업기술 정보방</h1>
        <div class="sub-header">농사 재배와 관련된 유용한 팁을 공유하세요!</div>
    </div>

    <!-- 게시글 작성 영역 -->
    <div class="content">
        <h2>게시글 작성</h2>
        <!-- Summernote 에디터 -->
        <textarea id="summernote"></textarea>
        <!-- 글 작성 버튼 -->
        <button class="cancel-button" onclick="savePost()">취소</button>
        <!-- 글 작성 버튼 -->
        <button class="write-button" onclick="savePost()">글 작성하기</button>
    </div>
</div>

<script>
    $(document).ready(function() {
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
                    formData.append("image", files[0]);
                    var imageUrl = "https://via.placeholder.com/300";
                    $('#summernote').summernote('insertImage', imageUrl);
                    // // 서버에 이미지 파일을 전송 (여기선 임시로 콘솔로그 출력)
                    // $.ajax({
                    //     url: '/your-server-endpoint', // 서버의 이미지 업로드 API 엔드포인트
                    //     type: 'POST',
                    //     data: formData,
                    //     contentType: false,
                    //     processData: false,
                    //     success: function(response) {
                    //         // 서버로부터 응답받은 이미지 URL
                    //         var imageUrl = response.url; // 서버에서 반환된 이미지 URL

                    //         // Summernote 에디터에 이미지 삽입
                    //         $('#summernote').summernote('insertImage', imageUrl);
                    //     },
                    //     error: function() {
                    //         console.error('이미지 업로드 실패');
                    //     }
                    // });
                }
            }
        });
    });

    // 글 작성 후 저장하는 함수
    function savePost() {
        // Summernote 에디터에서 작성한 내용 가져오기
        var content = $('#summernote').val();
        console.log('작성된 글:', content);

        // 여기에 서버로 데이터 전송하는 로직 추가 가능
        // 예: POST 요청을 통해 내용과 이미지 URL을 저장하기
    }
</script>

</body>
</html>

        