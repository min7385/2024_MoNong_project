<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시세 예측</title>
	<!-- Chart.js 라이브러리 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	
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

        .result-section {
		    display: flex;
		    justify-content: space-between;
		    flex-wrap: wrap;
		    margin-top: 20px;
		}
		
		.result-box {
		    flex: 1; /* 동일한 너비를 가짐 */
		    margin: 10px;
		    text-align: center;
		    border: 1px solid #ddd;
		    border-radius: 10px;
		    padding: 15px;
		    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		    box-sizing: border-box; /* padding, border가 크기에 포함되도록 */
		}
		
		.result-box img {
		    width: 100%;  /* 이미지가 박스를 넘지 않도록 */
		    height: auto; /* 이미지의 비율을 유지 */
		    max-height: 150px; /* 이미지 크기 제한 */
		}
		
		/* 차트 스타일 */
		.result-box.chart {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    height: 300px; /* 차트 높이 설정 */
		}
		
		canvas {
		    width: 100% !important;
		    height: 100% !important;
		}
	}
    </style>
</head>
<body>

<div class="container">
	<!-- 제목 -->
	<h1>시세 예측</h1>
	
	<!-- 입력 필드 -->
	<div class="input-row">
		<div>
			<input name="prceRegYmd" type="date" id="dateInput" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" />
		</div>
		<select id="pdltCtgSelect">
			<option value="">-- 부류 선택 --</option>
		</select>
		<select id="pdltNmSelect">
			<option value="">-- 품목 선택 --</option>
		</select>
		<div><button id="button">검색하기</button></div>
		<div><button id="resetButton" style="background-color: #999;">선택 초기화</button></div>
	</div>
	
	<!-- 결과 섹션 -->
	<div class="result-section">
		<div class="result-box">
			<p><strong>품목:</strong></p>
			<p><strong>단위:</strong></p>
			<img id="productImage" src="pdltPath" alt="제품 이미지">
		</div>
		<div class="result-box chart">
			<p><strong>가격</strong></p>
			<canvas id="priceChart"></canvas>
		</div>
	</div>
</div>

</body>
</html>
