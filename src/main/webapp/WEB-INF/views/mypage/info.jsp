<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>활동 내역 조회</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        /* 컨테이너 */
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
            text-align: center;
            color: #4CAF50;
        }

        /* 탭 메뉴 */
        .tabs {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }

        .tabs div {
            padding: 10px;
            font-weight: bold;
            cursor: pointer;
            color: #4CAF50;
            border-bottom: 3px solid transparent;
            transition: color 0.3s, border-bottom 0.3s;
        }

        .tabs div.active {
            color: #333;
            border-bottom: 3px solid #4CAF50;
        }

        /* 탭 내용 */
        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* 아이템 스타일 */
        .activity-item {
            display: flex;
            align-items: center;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .activity-item img {
            width: 80px;
            height: 80px;
            margin-right: 15px;
            object-fit: cover;
            border-radius: 10px;
        }

        .activity-item div {
            flex: 1;
        }

        .activity-item h3 {
            margin: 0;
            font-size: 16px;
        }

        .activity-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #666;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .tabs {
                flex-direction: column;
                align-items: center;
            }

            .activity-item {
                flex-direction: column;
                text-align: center;
            }

            .activity-item img {
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <!-- 제목 -->
    <h1>활동 내역 조회</h1>

    <!-- 탭 메뉴 -->
    <div class="tabs">
        <div id="likesTab" class="active">좋아요</div>
        <div id="postsTab">게시글 수</div>
        <div id="commentsTab">댓글 수</div>
    </div>

    <!-- 좋아요 탭 내용 -->
    <div id="likesContent" class="tab-content active">
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="좋아요한 게시글">
            <div>
                <h3>좋아요한 게시글 1</h3>
                <p>1시간 전 · 50개의 좋아요</p>
            </div>
        </div>
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="좋아요한 게시글">
            <div>
                <h3>좋아요한 게시글 2</h3>
                <p>3시간 전 · 30개의 좋아요</p>
            </div>
        </div>
    </div>

    <!-- 게시글 수 탭 내용 -->
    <div id="postsContent" class="tab-content">
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="내가 작성한 게시글">
            <div>
                <h3>내 게시글 1</h3>
                <p>2일 전 · 조회수 120</p>
            </div>
        </div>
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="내가 작성한 게시글">
            <div>
                <h3>내 게시글 2</h3>
                <p>1주일 전 · 조회수 300</p>
            </div>
        </div>
    </div>

    <!-- 댓글 수 탭 내용 -->
    <div id="commentsContent" class="tab-content">
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="댓글 단 게시글">
            <div>
                <h3>댓글 단 게시글 1</h3>
                <p>댓글: "정말 유용한 정보네요!"</p>
            </div>
        </div>
        <div class="activity-item">
            <img src="https://via.placeholder.com/80" alt="댓글 단 게시글">
            <div>
                <h3>댓글 단 게시글 2</h3>
                <p>댓글: "좋은 글 감사합니다!"</p>
            </div>
        </div>
    </div>
</div>

<script>
    // 탭 전환 기능
    const likesTab = document.getElementById("likesTab");
    const postsTab = document.getElementById("postsTab");
    const commentsTab = document.getElementById("commentsTab");

    const likesContent = document.getElementById("likesContent");
    const postsContent = document.getElementById("postsContent");
    const commentsContent = document.getElementById("commentsContent");

    function showTab(tabName) {
        // 모든 탭과 콘텐츠 비활성화
        likesTab.classList.remove("active");
        postsTab.classList.remove("active");
        commentsTab.classList.remove("active");

        likesContent.classList.remove("active");
        postsContent.classList.remove("active");
        commentsContent.classList.remove("active");

        // 선택된 탭과 콘텐츠 활성화
        if (tabName === "likes") {
            likesTab.classList.add("active");
            likesContent.classList.add("active");
        } else if (tabName === "posts") {
            postsTab.classList.add("active");
            postsContent.classList.add("active");
        } else if (tabName === "comments") {
            commentsTab.classList.add("active");
            commentsContent.classList.add("active");
        }
    }

    likesTab.addEventListener("click", () => showTab("likes"));
    postsTab.addEventListener("click", () => showTab("posts"));
    commentsTab.addEventListener("click", () => showTab("comments"));
</script>

</body>
</html>
