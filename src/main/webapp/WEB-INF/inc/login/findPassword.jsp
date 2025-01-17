<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        /* 모달 배경 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        /* 모달 컨텐츠 */
        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            width: 300px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
        }

        /* 입력창 및 버튼 스타일 */
        input {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        button {
            padding: 8px 12px;
            margin: 5px;
            border: none;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        button.cancel {
            background-color: #f44336;
        }

        button:hover {
            background-color: #45a049;
        }

        button.cancel:hover {
            background-color: #d32f2f;
        }

        /* 결과 메시지 스타일 */
        #result {
            margin-top: 15px;
            font-size: 20px;
            color: #333;
        }
    </style>

<!-- 비밀번호 찾기 모달 -->
<div id="pwModal" class="modal">
    <div class="modal-content">
        <h2>비밀번호 찾기</h2>
        <input type="text" id="idInput" placeholder="아이디를 입력하세요">
        <input type="text" id="nicknameInput" placeholder="닉네임을 입력하세요">
        <div>
            <button id="confirmBtn">확인하기</button>
            <button class="cancel" id="cancelBtn">취소하기</button>
        </div>
        <div id="result"></div>
    </div>
</div>

<script>
    // 모달 열기
    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("pwModal");
        const confirmBtn = document.getElementById("confirmBtn");
        const cancelBtn = document.getElementById("cancelBtn");
        const resultDiv = document.getElementById("result");
        const idInput = document.getElementById("idInput");
        const nicknameInput = document.getElementById("nicknameInput");

        modal.style.display = "block"; // 페이지 로드 시 모달 열림

        // 확인 버튼 클릭 이벤트
        confirmBtn.addEventListener("click", function () {
            const id = idInput.value.trim();
            const nickname = nicknameInput.value.trim();

            if (id && nickname) {
                resultDiv.innerHTML = `<h1>비밀번호는 <span style="color: #4CAF50;">1111</span>입니다</h1>`;
            } else {
                resultDiv.innerHTML = `<h1 style="color: red;">모든 항목을 입력해주세요.</h1>`;
            }
        });

        // 취소 버튼 클릭 이벤트
        cancelBtn.addEventListener("click", function () {
            modal.style.display = "none";
        });
    });
</script>