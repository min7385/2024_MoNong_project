<%
  /* ================================================================= 
   * 작성일     : 2024. 12. 31. 
   * 작성자     : 한준희
   * 상세설명  : 
   * 화면ID  :
   * ================================================================= 
   * 수정일         작성자             내용      
   * ----------------------------------------------------------------------- 
   * ================================================================= 
   */
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
  :root {
    --primary-color: #005100;
  }

  .form-group {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
  }

  .form-group label {
    flex: 0 0 80px;
    font-weight: bold;
    margin-right: 10px;
  }

  .form-group input {
    flex: 1;
    padding: 5px 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
  }

  .form-group button {
    margin-left: 10px;
    padding: 5px 15px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 5px;
  }

  .form-group button:hover {
    background-color: #003b00;
  }

  #map {
    width: 80%;
    height: 250px;
    margin: 10px auto;
    border: 1px solid #ddd;
    border-radius: 5px;
  }

  .modal-content {
    border-radius: 10px;
    background-color: #ffffff;
    border: 2px solid var(--primary-color);
  }

  .modal-header {
    background-color: var(--primary-color);
    color: white;
    border-bottom: 2px solid var(--primary-color);
    font-weight: bold;
    font-size: 1.2rem; /* 헤더 크기 축소 */
  }

  .modal-footer {
    border-top: 2px solid var(--primary-color);
  }

  .btn-secondary {
    background-color: var(--primary-color);
    border: none;
    color: white;
  }

  .btn-secondary:hover {
    background-color: #003b00;
  }
</style>

<!-- 약속 정보 모달 -->
<div class="modal fade" id="promiseModal" tabindex="-1" aria-labelledby="promiseModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="promiseModalLabel"><strong>약속 잡기</strong></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <!-- 날짜 -->
        <div class="form-group">
          <label for="tmMeetDate"><strong>날짜:</strong></label>
          <input type="date" id="tmMeetDate" name="tmMeetDate">
        </div>

        <!-- 시간 -->
        <div class="form-group">
          <label for="tmMeetTime"><strong>시간:</strong></label>
          <input type="time" id="tmMeetTime" name="tmMeetTime">
        </div>

        <!-- 거래 희망 장소 -->
        <div class="form-group">
          <label for="fullAddr"><strong>약속 장소:</strong></label>
          <input type="text" id="fullAddr" name="tmMeetPlace" placeholder="주소를 입력해주세요" readonly>
          <button type="button" class="btn btn-secondary" onclick="fn_search()">주소 검색</button>
        </div>

        <!-- 지도 컨테이너 -->
        <div id="map"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="sendAppointment()">약속 잡기</button>
      </div>
    </div>
  </div>
</div>

<!-- 다음 우편번호, 카카오맵 SDK -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=539b508df6c017894a2691b6cfff05ce&libraries=services"></script>

<script>
  // ---------- 지도 초기화 ----------
  var mapContainer = document.getElementById('map'); 
  var mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667),
    level: 3
  };
  var map = new kakao.maps.Map(mapContainer, mapOption);
  var geocoder = new kakao.maps.services.Geocoder();
  var marker = null;

  // ---------- 주소 검색 ----------
  function fn_search() {
    new daum.Postcode({
      oncomplete: function (data) {
        var addr = data.address;
        document.getElementById('fullAddr').value = addr;
        geocoder.addressSearch(addr, function (result, status) {
          if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            if (marker) marker.setMap(null);
            marker = new kakao.maps.Marker({
              map: map,
              position: coords
            });
            map.setCenter(coords);
          } else {
            alert("주소를 검색할 수 없습니다.");
          }
        });
      }
    }).open();
  }

  // ---------- 모달 열릴 때 지도 재정렬 ----------
  var promiseModal = document.getElementById('promiseModal');
  promiseModal.addEventListener('shown.bs.modal', function () {
    map.relayout();
    map.setCenter(new kakao.maps.LatLng(33.450701, 126.570667));
  });

  // ---------- 약속잡기 (STOMP 전송) ----------
  function sendAppointment() {
  var date = $("#tmMeetDate").val();   // yyyy-MM-dd
  var time = $("#tmMeetTime").val();   // HH:mm
  var place = $("#fullAddr").val();

  if (!date || !time || !place) {
    alert("날짜, 시간, 장소를 모두 입력해주세요.");
    return;
  }
  
  // 날짜+시간 합치기
  var dateTime = date + " " + time;  // "2025-01-16 14:27"
  var appointmentMessage = "약속: " + dateTime + " " + place;

  // tmStatus='REQUEST', tmContentType='APPOINTMENT'
  client.send("/app/hello/" + tmChatId, {}, JSON.stringify({
    tmContent: appointmentMessage,
    tmSender: memId,
    tmContentType: "APPOINTMENT",
    tmStatus: "REQUEST",
    tmChatId: tmChatId,

    // 필요하면 ChatVO에 tmMeetDate, tmMeetPlace 따로 담아서
    tmMeetDate: dateTime,
    tmMeetPlace: place
  }));

  // 모달 닫기 + 초기화
  $("#promiseModal").modal("hide");
  $("#tmMeetDate").val("");
  $("#tmMeetTime").val("");
  $("#fullAddr").val("");
}
</script>