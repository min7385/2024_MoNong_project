<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시세 확인</title>
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
            max-width: 1000px;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 22px;
            color: #4CAF50;
            margin-bottom: 20px;
            text-align: center;
        }

        /* 입력 필드 및 버튼 */
        .input-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .input-row div {
            flex: 1;
            margin: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .input-row input, .input-row button {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        button {
            background-color: #3366FF;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2558c2;
        }

        /* 그래프 선택 버튼 */
        .graph-buttons {
            display: flex;
            margin: 10px 0;
            gap: 10px;
        }

        .graph-buttons button {
            flex: 1;
            padding: 15px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
        }

        .graph-buttons .current {
            background-color: #4CAF50; /* 테마 초록색 */
        }

        .graph-buttons .current:hover {
            background-color: #45a049;
        }

        .graph-buttons .prediction {
            background-color: #FF9800; /* 테마 주황색 */
        }

        .graph-buttons .prediction:hover {
            background-color: #FB8C00;
        }

        /* 결과 섹션 */
        .result-section {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }

        .result-box {
            flex: 1;
            margin: 10px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .result-box img {
            width: 100px;
            height: auto;
        }

        /* 그래프 스타일 */
        .result-box.chart {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%; 
            max-width: 400px; 
            height: 250px; 
            margin: 0 auto; 
        }

        canvas {
            width: 100% !important;
            height: 100% !important;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .input-row {
                flex-direction: column;
                align-items: center;
            }

            .input-row div {
                width: 100%;
            }

            .result-section, .graph-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <!-- 제목 -->
    <h1>시세 확인</h1>

    <!-- 입력 필드 -->
    <div class="input-row">
        <div><input type="month" value="2024-12" /></div>
        <div><input type="text" placeholder="지역 입력" /></div>
        <div><input type="text" placeholder="부류 입력" /></div>
        <div><input type="text" placeholder="품목 입력" /></div>
        <div><button>검색하기</button></div>
        <div><button style="background-color: #999;">선택 초기화</button></div>
    </div>

    <!-- 그래프 선택 버튼 -->
    <div class="graph-buttons">
        <button class="current">현재 그래프</button>
        <button class="prediction">예측 그래프</button>
    </div>

    <!-- 결과 섹션 -->
    <div class="result-section">
        <div class="result-box">
            <p><strong>품목:</strong> 사과</p>
            <p><strong>단위:</strong> 1kg</p>
            <img src="https://via.placeholder.com/100" alt="사과 이미지">
        </div>
        <div class="result-box chart">
            <p>시세 그래프</p>
            <canvas id="priceChart"></canvas>
        </div>
    </div>
</div>

<!-- Chart.js 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // 그래프 데이터
    const ctx = document.getElementById('priceChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['11/30', '12/02', '12/03', '12/04', '12/05'],
            datasets: [{
                label: '시세 (원)',
                data: [3329, 3410, 3473, 3475, 3327],
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2,
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: false,
                    ticks: { stepSize: 500 }
                }
            }
        }
    });
</script>

</body>
</html>
