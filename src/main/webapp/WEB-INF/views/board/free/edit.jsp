<!-- 게시글 수정 및 삭제 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>
    <style>
    
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            color: #333;
        }

        .container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #4CAF50;
            text-align: center;
        }

        /* 입력 박스 스타일 */
        .input-group {
            margin-bottom: 15px;
        }

        .input-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .input-group input,
        .input-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }

        .input-group textarea {
            resize: vertical;
            height: 150px;
        }

        /* 이미지 업로드 */
        .image-preview {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 15px;
        }

        .image-preview img {
            width: 100%;
            max-width: 300px;
            margin: 10px 0;
            border-radius: 10px;
            border: 1px solid #ddd;
        }

        .input-group input[type="file"] {
            padding: 5px;
            font-size: 12px;
        }

        /* 버튼 영역 */
        .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .button-group button {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            color: white;
            background-color: #4CAF50;
            cursor: pointer;
            font-size: 14px;
        }

        .button-group button.cancel {
            background-color: #f44336;
        }

        .button-group button:hover {
            background-color: #45a049;
        }

        .button-group button.cancel:hover {
            background-color: #d32f2f;
        }

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .input-group input,
            .input-group textarea {
                font-size: 12px;
                padding: 8px;
            }

            .button-group button {
                font-size: 12px;
                padding: 6px 10px;
            }

            .image-preview img {
                max-width: 200px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <!-- 제목 -->
    <h1>게시글 수정</h1>

    <!-- 제목 수정 -->
    <div class="input-group">
        <label for="title">제목</label>
        <input type="text" id="title" value="집에서 토마토 키워 보신분 계신가요?ㅠㅠ">
    </div>

    <!-- 사진 업로드 -->
    <div class="input-group">
        <label for="fileUpload">사진</label>
        <input type="file" id="fileUpload" accept="image/*">
        <div class="image-preview">
            <p>현재 사진</p>
            <img id="imagePreview" src="https://via.placeholder.com/300" alt="현재 사진 미리보기">
        </div>
    </div>
    
    <!-- 내용 수정 -->
    <div class="input-group">
        <label for="content">내용</label>
        <textarea id="content">과거도 바람도 불어와서 집에서 키워보고 싶었던 코디입니다. 토마토를 키워보신 분들 지혜를 나눠주세요!</textarea>
    </div>

    <!-- 버튼 영역 -->
    <div class="button-group">
        <button id="saveBtn">저장</button>
        <button class="cancel" id="cancelBtn">취소</button>
    </div>
</div>

<script>
    // 사진 업로드 미리보기
    const fileUpload = document.getElementById("fileUpload");
    const imagePreview = document.getElementById("imagePreview");

    fileUpload.addEventListener("change", function () {
        const file = fileUpload.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                imagePreview.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    // 저장 버튼 처리
    document.getElementById("saveBtn").addEventListener("click", function () {
        const title = document.getElementById("title").value.trim();
        const content = document.getElementById("content").value.trim();

        if (title && content) {
            alert("게시글이 수정되었습니다!\n\n제목: " + title + "\n내용: " + content);
        } else {
            alert("제목과 내용을 모두 입력해주세요.");
        }
    });

    // 취소 버튼 처리
    document.getElementById("cancelBtn").addEventListener("click", function () {
        alert("수정을 취소했습니다.");
    });
</script>

</body>
</html>
