<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포인트 내역 조회</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
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

        /* 상단 포인트 내역 */
        .point-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .point-header h1 {
            font-size: 22px;
            color: #4CAF50;
        }

        .point-summary {
            display: flex;
            justify-content: space-around;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .point-summary div {
            font-weight: bold;
            text-align: center;
        }

        /* 탭 메뉴 */
        .tabs {
            display: flex;
            justify-content: space-around;
            border-bottom: 2px solid #ddd;
            margin-bottom: 20px;
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

        /* 리스트 아이템 */
        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .point-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .point-item .name {
            font-weight: bold;
        }

        .point-item .value {
            font-size: 14px;
            color: #4CAF50;
        }

        .point-item .value.minus {
            color: #f44336;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .tabs {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <!-- 상단 포인트 내역 -->
    <div class="point-header">
        <h1>포인트 내역</h1>
        <div class="point-summary">
            <div>포인트: <span>1,000 P</span></div>
            <div>11월 ▼</div>
            <div>
                적립: 2,500P<br>
                사용: 1,500P
            </div>
        </div>
    </div>

    <!-- 탭 메뉴 -->
    <div class="tabs">
        <div id="allTab" class="active">전체</div>
        <div id="usedTab">사용</div>
        <div id="earnedTab">적립</div>
    </div>

    <!-- 전체 내역 -->
    <div id="allContent" class="tab-content active">
        <div class="point-item">
            <div class="name">쇼핑몰 결제</div>
            <div class="value minus">-500P</div>
            <div>잔여: 1,000P</div>
        </div>
        <div class="point-item">
            <div class="name">이벤트 참여</div>
            <div class="value">+1,500P</div>
            <div>잔여: 1,500P</div>
        </div>
        <div class="point-item">
            <div class="name">친구 초대 보너스</div>
            <div class="value">+500P</div>
            <div>잔여: 2,000P</div>
        </div>
        <div class="point-item">
            <div class="name">상품권 교환</div>
            <div class="value minus">-1,000P</div>
            <div>잔여: 1,000P</div>
        </div>
    </div>

    <!-- 사용 내역 -->
    <div id="usedContent" class="tab-content">
        <div class="point-item">
            <div class="name">쇼핑몰 결제</div>
            <div class="value minus">-500P</div>
            <div>잔여: 1,000P</div>
        </div>
        <div class="point-item">
            <div class="name">상품권 교환</div>
            <div class="value minus">-1,000P</div>
            <div>잔여: 1,000P</div>
        </div>
    </div>

    <!-- 적립 내역 -->
    <div id="earnedContent" class="tab-content">
        <div class="point-item">
            <div class="name">이벤트 참여</div>
            <div class="value">+1,500P</div>
            <div>잔여: 1,500P</div>
        </div>
        <div class="point-item">
            <div class="name">친구 초대 보너스</div>
            <div class="value">+500P</div>
            <div>잔여: 2,000P</div>
        </div>
    </div>
</div>

<script>
    // 탭 전환 기능
    const allTab = document.getElementById("allTab");
    const usedTab = document.getElementById("usedTab");
    const earnedTab = document.getElementById("earnedTab");

    const allContent = document.getElementById("allContent");
    const usedContent = document.getElementById("usedContent");
    const earnedContent = document.getElementById("earnedContent");

    function showTab(tab) {
        allTab.classList.remove("active");
        usedTab.classList.remove("active");
        earnedTab.classList.remove("active");

        allContent.classList.remove("active");
        usedContent.classList.remove("active");
        earnedContent.classList.remove("active");

        if (tab === "all") {
            allTab.classList.add("active");
            allContent.classList.add("active");
        } else if (tab === "used") {
            usedTab.classList.add("active");
            usedContent.classList.add("active");
        } else if (tab === "earned") {
            earnedTab.classList.add("active");
            earnedContent.classList.add("active");
        }
    }

    allTab.addEventListener("click", () => showTab("all"));
    usedTab.addEventListener("click", () => showTab("used"));
    earnedTab.addEventListener("click", () => showTab("earned"));
</script>

</body>
</html>
