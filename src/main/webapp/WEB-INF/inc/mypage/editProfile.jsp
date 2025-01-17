<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
 <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: rgba(0, 0, 0, 0.5);
            /* 모달 느낌을 위한 반투명 배경 */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .modal-container {
            background-color: white;
            width: 90%;
            max-width: 500px;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        h1 {
            margin-bottom: 20px;
            color: #4CAF50;
        }

        /* 섹션 스타일 */
        .section {
            margin: 15px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section label {
            font-weight: bold;
            margin-right: 10px;
        }

        .section input {
            flex: 1;
            padding: 8px;
            margin-right: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .section button {
            padding: 8px 10px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
        }

        .section button:hover {
            background-color: #45a049;
        }

        /* 프로필 이미지 */
        .profile-section {
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #4CAF50;
        }

        .profile-actions button {
            margin-top: 10px;
            background-color: #4CAF50;
        }

        /* 반영하기 버튼 */
        .submit-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #FF5722;
            /* 강조 색상 */
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background-color: #E64A19;
        }

        /* 반응형 스타일 */
        @media (max-width: 768px) {
            .section {
                flex-direction: column;
                align-items: flex-start;
            }

            .section input,
            .section button {
                width: 100%;
                margin-top: 5px;
            }

            .profile-img {
                width: 100px;
                height: 100px;
            }
        }
    </style>

    <div class="modal-container">
        <h1>개인정보 수정</h1>

        <!-- 프로필 사진 변경 -->
        <div class="profile-section">
            <img id="profileImg" class="profile-img" src="https://via.placeholder.com/150" alt="프로필 이미지">
            <div class="profile-actions">
                <button id="changeImgBtn">사진 변경하기</button>
                <input type="file" id="fileInput" style="display: none;" accept="image/*">
            </div>
        </div>

        <!-- 닉네임 변경 -->
        <div class="section">
            <label for="nickname">닉네임</label>
            <input type="text" id="nickname" placeholder="새 닉네임 입력">
            <button id="checkNicknameBtn">중복 확인</button>
        </div>

        <!-- 비밀번호 변경 -->
        <div class="section">
            <label for="password">비밀번호</label>
            <input type="password" id="password" placeholder="비밀번호 변경">
        </div>

        <!-- 지역 선택 -->
        <div class="section">
            <label>지역 선택</label>
            <input type="text" id="regionInput" placeholder="현재 지역: 송촌동" disabled>
            <button id="changeRegionBtn">변경</button>
        </div>

        <!-- 반영하기 -->
        <button id="submitBtn" class="submit-btn">반영하기</button>
    </div>

    <script>
        // 사진 변경 기능
        const fileInput = document.getElementById("fileInput");
        const profileImg = document.getElementById("profileImg");
        const changeImgBtn = document.getElementById("changeImgBtn");

        changeImgBtn.addEventListener("click", () => fileInput.click());

        fileInput.addEventListener("change", () => {
            const file = fileInput.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = (e) => profileImg.src = e.target.result;
                reader.readAsDataURL(file);
            }
        });

        // 닉네임 중복 확인
        document.getElementById("checkNicknameBtn").addEventListener("click", () => {
            const nickname = document.getElementById("nickname").value.trim();
            if (nickname) {
                alert(`닉네임 "${nickname}"는 사용 가능합니다.`);
            } else {
                alert("닉네임을 입력해주세요.");
            }
        });

        // 지역 변경
        document.getElementById("changeRegionBtn").addEventListener("click", () => {
            const newRegion = prompt("새로운 지역을 입력해주세요:");
            if (newRegion) {
                document.getElementById("regionInput").value = `현재 지역: ${newRegion}`;
            }
        });

        // 반영하기
        document.getElementById("submitBtn").addEventListener("click", () => {
            alert("개인정보가 성공적으로 반영되었습니다.");
        });
    </script>