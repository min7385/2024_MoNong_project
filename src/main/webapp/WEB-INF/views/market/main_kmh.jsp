<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시세 확인</title>
	<!-- Chart.js 라이브러리 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
		.header {
			padding: 20px 0;
			text-align: center;
			background-color: #005100;
			color: white;
			margin-bottom: 20px;
		}
        .result-container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            min-height: 40vh;
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
            background-color: #005100;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #4CAF50;
        }
        .btn-success {
        	background-color: #005100;
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
		
		#productImage {
		    width: 100%;              /* 이미지의 너비를 부모 요소에 맞게 100%로 설정 */
		    max-width: 300px;         /* 최대 너비를 500px로 제한 (필요에 따라 조정 가능) */
		    height: auto;             /* 이미지의 높이는 비율에 맞게 자동 조정 */
		    object-fit: contain;      /* 이미지 비율을 유지하면서 부모 요소에 맞게 조정 */
		    margin: 0 auto;           /* 이미지가 중앙에 위치하도록 설정 */
		    display: block;           /* 이미지가 블록 요소로 표시되도록 설정 (중앙 정렬을 위해 필요) */
		}
		#loading-message {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 1.5rem;
            color: rgba(128, 128, 128, 0.9);
            text-align: center;
            animation: blink 1.2s infinite;
            z-index: 9999;
        }

        @keyframes blink {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }

    </style>

</head>
<body>

<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="header">
		<h1>시세 및 예측</h1>
		<div class="sub-header">현재 농작물의 시세와 예측 가격을 알려 주는 서비스입니다.</div>
	</div>

	    <!-- 결과 섹션 -->
	    <div class="result-container">

	    <!-- 입력 필드 -->
	    <div class="input-row">
	        <div class="col">
	        	<input class="form-control" name="prceRegYmd" type="date" id="dateInput" value="${marketList[0].prceRegYmd}" />
	    	</div>
	        <div class="col">
		        <select id="pdltCtgSelect" class="form-select" style="height: 44.22222px;">
		        	<option value="">-- 부류 선택 --</option>
		        <c:forEach var="code" items="${marketList}">       
		        	 <option value="${code.pdltCtgCode}">${code.pdltCtgNm}</option>
		        </c:forEach>
			    </select>
			</div>
			<div class="col">
				<select id="pdltNmSelect" class="form-select"  style="height: 44.22222px;">
					<option value="">-- 품목 선택 --</option>
			    </select>
	        </div>
	         <div class="col">
	         	<button id="btn">검색</button>
	         </div>
	         <div class="col">
	    		<button id="prediction_btn" class="btn-success">예측</button>
			</div>
	    </div>
            <!-- <p><strong>품목:</strong></p> -->
			<img id="productImage" alt="제품 이미지" style="display: none;">
       	    <div class="result-container" id="chart01"></div>
       	    <div id="loading-message" style="display: none;">예측 모델 분석 중...</div>
       	    <div class="result-container" id="chart02"></div>
	    </div>

<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

</body>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/series-label.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="http://code.highcharts.com/modules/export-data.js"></script>
    <script src="http://code.highcharts.com/maps/modules/offline-exporting.js"></script>
    <script src="http://code.highcharts.com/modules/accessibility.js"></script>
<script>
var mainChart;
var predChart;
$(document).ready(function(){
	
    // 페이지 로드 시 기본 이미지 설정
    <!--$('#productImage').attr('src', '/images/default_image.jpg');-->
    
    // 부류 선택 시 해당하는 품목을 가져오기
    $("#pdltCtgSelect").on('change', function(){
        var ctgNm = $(this).val();
        var prceRegYmd = $("#dateInput").val().replaceAll("-","");
        $.ajax({
            url: "/market/priceMain",
            type: "POST",
            data: {"pdltCtgCode" : ctgNm, "prceRegYmd": prceRegYmd},
            dataType: 'json',
            success: function(res){
                console.log(res);
                $("#pdltNmSelect").empty().append('<option value="">-- 품목 선택 --</option>');
                $.each(res, function(idx, item){
                    $("#pdltNmSelect").append('<option value="' + item.pdltCode + '">' + item.pdltNm + '</option>');
                });
                
                // 품목이 선택되었을 때, 선택된 품목 이름을 동적으로 표시
                $("#pdltNmSelect").on('change', function() {
                    var selectedItemName = $(this).find("option:selected").text();
                    if (selectedItemName) {
                        $('#itemName').html('<strong>품목:</strong> ' + selectedItemName);
                    } else {
                        $('#itemName').html('<strong>품목:</strong> 선택해주세요');
                    }
                });
            },
            error: function(e){
                console.log(e);
            }
        });
    });
    
    // 예측 데이터가 추가되었는지 여부를 확인하는 변수
    var isPredictionAdded = false;

    $("#prediction_btn").click(function(){
    	if(isPredictionAdded){	
    		return;
    	}
   	    if(mainChart===undefined){
   	    	alert("검색 이후 !!");
   	    	return;
   	    }

	    isPredictionAdded = true;

	 // 버튼 클릭 시 로딩 메시지 표시
	 document.getElementById("loading-message").style.display = "block";
	 document.getElementById("chart02").innerHTML = ""; // 이전 그래프 초기화
	    
   	 var prceRegYmd = $("#dateInput").val().replaceAll("-","");
     var pdltCtgCode = $("#pdltCtgSelect").val();
     var pdltCode = $("#pdltNmSelect").val();
     // 부류가 선택되지 않았을 경우
     if (!pdltCtgCode) {
         alert("부류를 선택해주세요.");
         return;
     }

     // 품목이 선택되지 않았을 경우
     if (!pdltCode) {
         alert("품목을 선택해주세요.");
         return;
     }

     console.log(prceRegYmd, pdltCtgCode, pdltCode);

     var formData = {
             pdlt_ctg_code: pdltCtgCode,
             pdlt_code: pdltCode,
             prce_reg_ymd: prceRegYmd
         };
     
     $.ajax({
	            url: "http://192.168.0.42:5000/predict",
	            type: "POST",
	            data: JSON.stringify(formData),
	            contentType: 'application/json',
	            dataType: 'json',
	            success: function(res) {
	             // 로딩 메시지 숨기기
		            if (res.predictions && res.predictions.length > 0) {
		            	 plotChart(res.predictions);
		            }
		        },
	            complete: function () {
	                // 로딩 메시지 숨기기 및 상태 업데이트
	                document.getElementById("loading-message").style.display = "none";
	                isPredictionAdded = false; // 예측 상태 업데이트
	            },
	            error: function(e){
	                console.log(e);
	            }
	    });
    });
    
    
    // 검색 버튼 클릭 시
    $("#btn").on('click', function(){
        var prceRegYmd = $("#dateInput").val();
        var pdltCtgCode = $("#pdltCtgSelect").val();
        var pdltCode = $("#pdltNmSelect").val();

        // 부류가 선택되지 않았을 경우
        if (!pdltCtgCode) {
            alert("부류를 선택해주세요.");
            return;
        }

        // 품목이 선택되지 않았을 경우
        if (!pdltCode) {
            alert("품목을 선택해주세요.");
            return;
        }

        console.log(prceRegYmd, pdltCtgCode, pdltCode);
        document.getElementById("chart02").innerHTML = ""; // 이전 그래프 초기화
        $.ajax({
	            url: "/market/searchProduct",
	            type: "POST",
	            data: {"prceRegYmd": prceRegYmd, "pdltCtgCode": pdltCtgCode, "pdltCode": pdltCode},
	            dataType: 'json',
	            success: function(res) {
	                console.log(res);
	                console.log("Server response:", res);
	             if (res && res.length > 0) {
	            	 const itemName = res[0].pdltNm || "정보 없음";
	            	 
	            	 // 기본 이미지와 문구 숨기기
	                 $('#productImage').hide();
	                 $('#defaultText').hide();
	            	 
	            	  $('p:contains("품목:")').html('<strong>품목:</strong> ' + itemName);
	                  
	            	  // 이미지 URL 업데이트
	                  const imageUrl = res[0].pdltPath;
	                  $('#productImage').attr('src', '/' + imageUrl);
	                  $('#productImage').show();  // 이미지 보이기

	                  // 차트 데이터 처리
	                  let chartData = processData(res);
	                  var config = {
	                      chart: {
	                          type: 'line'
	                      },
	                      title: {
	                          text:  '품목: ' + itemName
	                      },
	                      subtitle: {
	                          text: '단위별 가격 변화'
	                      },
	                      xAxis: {
	                          categories: chartData.categories, // 날짜
	                          crosshair: true
	                      },
	                      yAxis: {
	                          title: {
	                              text: '평균 가격 (원)'
	                          }
	                      },
	                      legend: {
	                          layout: 'vertical',
	                          align: 'right',
	                          verticalAlign: 'middle'
	                      },
	                      series: chartData.series // 동적으로 생성된 series
	                  };
					  console.log(config);
				      // Highcharts 차트 생성
				      mainChart = Highcharts.chart('chart01',config);
	            }
	        }
	    });
    });


    // 날짜 포맷팅 함수
    function formatDate(dateString) {
        const formattedDate = dateString.substring(0, 4) + '-' + dateString.substring(4, 6) + '-' + dateString.substring(6, 8);
        const date = new Date(formattedDate);
        const options = { month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('en-US', options);
    }
    // 데이터 처리
    function processData(data) {
    	// 날짜별로 정렬
        data.sort(function (a, b) {
//             return a.prceRegYmd.localeCompare(b.prceRegYmd);
            return a.prceRegYmd.localeCompare(a.prceRegYmd);  //반대로
        });
		console.log('data',data);
        // 품목 및 단위별 그룹화
        var groupedData = {};
        data.forEach(function (item) {
            var name = item.exmnSeNm +':' + item.pdltNm + '[' + item.dsbnStepActoWt + ' ' + item.dsbnStepActoUnitNm + ']'; // 품목명[크기(단위)]
            var date = item.prceRegYmd; // 날짜
            var price = parseInt(item.avrgPrce, 10); // 가격
//             var price = item.avrgPrce; // 가격

            if (!groupedData[name]) {
                groupedData[name] = {}; // 품목별 데이터 초기화
            }
            groupedData[name][date] = price;
        });

        // X축 카테고리 생성 (날짜)
        var categories = data.map(function (item) {
            return item.prceRegYmd;
        }).filter(function (value, index, self) {
            return self.indexOf(value) === index;
//         }).sort();   -- 원래 순서로 하려면
        }).sort(function (a, b) {
            return b.localeCompare(a);
        });

        // Series 데이터 생성
        var series = [];
        for (var name in groupedData) {
            if (groupedData.hasOwnProperty(name)) {
                var itemData = categories.map(function (date) {
                    return groupedData[name][date] || null; // 날짜별 데이터 정렬
                });
                series.push({
                    name: name, // 품목명[크기(단위)]
                    data: itemData
                });
            }
        }

        return { categories: categories, series: series };
        }
        
        
   
   
    function plotChart(data) {
        // 데이터 처리
        var categories = []; // 날짜 리스트
        var series = {}; // 품목별 데이터

        // 데이터 그룹화
        data.forEach(function (group) {
            group.predictions.forEach(function (prediction) {
                // 날짜가 없으면 추가
                if (!categories.includes(prediction.prceRegYmd)) {
                    categories.push(prediction.prceRegYmd);
                }

                // 품목 이름 생성
                var name = group.exmnSeNm + " [" + group.wactoWt + " " + group.actoNm + "]";
                if (!series[name]) {
                    series[name] = { lstm: [], transformer: [] }; // LSTM, Transformer 데이터를 분리
                }

                // LSTM 및 Transformer 예측값 추가
                series[name].lstm.push(prediction.avrgPrceLstm);
                series[name].transformer.push(prediction.avrgPrceTransformer);
            });
        });

        // Series 데이터 생성
        var finalSeries = [];
        for (var key in series) {
            if (series.hasOwnProperty(key)) {
                finalSeries.push({
                    name: key + " (LSTM)",
                    data: series[key].lstm
                });
                finalSeries.push({
                    name: key + " (Transformer)",
                    data: series[key].transformer
                });
            }
        }

        // Highcharts 설정
        var chartConfig = {
            chart: {
                type: 'line'
            },
            title: {
                text: '예측 가격 변화'
            },
            subtitle: {
                text: 'LSTM과 Transformer 모델의 예측 비교'
            },
            xAxis: {
                categories: categories, // X축: 날짜
                title: {
                    text: '날짜'
                }
            },
            yAxis: {
                title: {
                    text: '평균 가격 (원)'
                }
            },
            tooltip: {
                shared: true,
                crosshairs: true,
                valueDecimals: 2,
                valueSuffix: ' 원'
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },
            series: finalSeries // 정리된 Series 데이터
        };
		console.log(chartConfig);
        // Highcharts 차트 생성
        Highcharts.chart('chart02', chartConfig);
    }
	function updateChartWithPrediction(predictionCategories, predictionData, nm) {
		 if (!mainChart.xAxis || mainChart.xAxis.length === 0) {
	        console.error("X축이 초기화되지 않았습니다.");
	        return;
	    }

	    // 기존 카테고리와 새로운 카테고리를 병합
	    const updatedCategories = mainChart.xAxis[0].categories.concat(predictionCategories);

	    // X축 카테고리 업데이트
	    mainChart.xAxis[0].setCategories(updatedCategories, false);

	    // 새로운 시리즈 추가
	    mainChart.addSeries(
	        {
	            name: nm,
	            data: predictionData
	        },
	        false // 차트 리렌더링 방지
	    );

	    // 차트를 다시 그리기
	    mainChart.redraw();
	}
	
	
});
</script>


</html>