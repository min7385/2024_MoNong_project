<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>채팅 화면</title>
<link rel="stylesheet" href="/css/chat.css">
</head>

<body>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/inc/modal/promiseModal.jsp"></jsp:include>

<!-- 약속 상세 모달 -->
<div class="modal fade" id="appointmentDetailModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md">
    <div class="modal-content">
      <!-- 모달 헤더 color: #000100, padding 축소 -->
      <div class="modal-header" style="background-color:#005100; color:#fff; padding:8px 10px;">
        <strong class="modal-title" style="font-size:1rem;">약속 상세 정보</strong>
        <button type="button" class="btn-close" data-bs-dismiss="modal"
                aria-label="Close" style="margin:0;"></button>
      </div>
      <!-- 연한 회색 배경 -->
      <div class="modal-body" id="appointmentDetailBody" style="background-color:#f5f5f5;">
        <!-- 약속 정보 표시 영역 -->
      </div>
      <!-- 아주 옅은 회색 바탕 -->
      <div class="modal-footer" style="background-color:#005100;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- 후기 작성 모달 -->
<div class="modal fade" id="insertReviewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md">
    <div class="modal-content">
      <!-- 같은 색상 / 크기 조절 -->
      <div class="modal-header" style="background-color:#005100; color:#fff; padding:8px 10px;">
        <strong class="modal-title" style="font-size:1rem;">후기 작성</strong>
        <button type="button" class="btn-close" data-bs-dismiss="modal"
                aria-label="Close" style="margin:0;"></button>
      </div>
      <div class="modal-body" style="background-color:#005100;">
        <!-- hidden inputs -->
        <input type="hidden" id="revWriter"/>
        <input type="hidden" id="revTarget"/>
        <input type="hidden" id="revProdId"/>

        <!-- 별점 -->
        <div class="mb-3">
          <label class="form-label"><strong>별점</strong></label>
          <div class="star-rating">
            <input type="radio" id="star5" name="revScore" value="5">
            <label for="star5">★</label>
            <input type="radio" id="star4" name="revScore" value="4">
            <label for="star4">★</label>
            <input type="radio" id="star3" name="revScore" value="3">
            <label for="star3">★</label>
            <input type="radio" id="star2" name="revScore" value="2">
            <label for="star2">★</label>
            <input type="radio" id="star1" name="revScore" value="1">
            <label for="star1">★</label>
          </div>
        </div>
        <!-- 후기 내용 -->
        <div class="mb-3">
          <label for="revContent" class="form-label"><strong>후기 내용</strong></label>
          <textarea class="form-control" id="revContent" rows="4"
                    placeholder="후기를 작성해주세요" required></textarea>
        </div>
      </div>
      <div class="modal-footer" style="background-color:#eeeeee;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="button" class="btn btn-primary" onclick="submitReview()">등록</button>
      </div>
    </div>
  </div>
</div>

<!-- 후기 보기 모달 -->
<div class="modal fade" id="viewReviewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md">
    <div class="modal-content">
      <!-- 헤더 색 동일, 크기 축소 -->
      <div class="modal-header" style="background-color:#000100; color:#fff; padding:8px 10px;">
        <strong class="modal-title" style="font-size:1rem;">후기 내용</strong>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="margin:0;"></button>
      </div>
      <div class="modal-body" style="background-color:#f5f5f5;">
        <!-- 후기 정보 표시 영역 -->
        <div id="reviewDetail"></div>
      </div>
      <div class="modal-footer" style="background-color:#eeeeee;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- 메인 컨테이너 -->
<div class="container">
  <!-- 서버에서 넘겨준 memId, chatId, roomView 등 -->
  <c:set var="memId" value="${userInfo.memId}" />
  <c:if test="${not empty roomView}">
    <c:set var="tmStatus" value="${roomView.tmStatus != null ? roomView.tmStatus : 'N'}" />
  </c:if>
  <c:set var="detailReview" value="${detailReview.revId != null ? detailReview.revId : null}" />

  <!-- 상태 바 (라운드 적용) -->
  <div class="status-bar" style="border-radius:8px;">
    <button onclick="history.back()">←</button>
    <span class="chat-seller">아이디: ${roomView.chatSeller}</span>
    <span class="trust-level">
      신뢰도:
      <c:out value="${roomView.memReliability != null ? roomView.memReliability : 0}" />
    </span>
  </div>

  <!-- 물품 정보 영역 -->
  <div class="item-info">
    <img src="${roomView.prodPhotoPath}" alt="상품이미지" class="item-image"
         onerror="this.src='/images/default_image.jpg';">
    <div class="item-details">
      <div class="title">${roomView.prodName}</div>
      <div>${roomView.prodPrice}원</div>
      <div style="color:#666; font-size:0.9rem;">${roomView.prodPlace}</div>

      <!-- 거래 버튼들 (약속/완료/후기) -->
      <div class="trade-buttons" id="tradeButtons">
        <button id="btnAppointment">약속잡기</button>
        <button id="btnComplete">거래완료</button>
        <button id="btnReview">후기보내기</button>
      </div>
      <div id="alreadyReviewed" style="display:none;">
        <span style="color:#e91e63; font-weight:bold;">이미 후기 작성됨</span>
        <button id="btnViewReview" onclick="openReviewDetail()">내가 쓴 후기보기</button>
      </div>

      <!-- 상대방 후기 보기 -->
      <button id="btnOtherReview" style="display:none;" onclick="openOtherReviewDetail()">
        상대방 후기 보기
      </button>
    </div>
  </div>

  <!-- 채팅 영역 -->
  <div class="chat-container">
    <div class="content chatcontent">
      <c:choose>
        <c:when test="${empty chatList}">
          <!-- 비어있는 경우에도 <ul class="chat-messages"> 생성 -->
          <ul class="chat-messages">
            <li style="text-align:center; color:gray; margin-top:20px;">
              아직 대화 내용이 없습니다. 첫 메시지를 보내보세요!
            </li>
          </ul>
        </c:when>
        <c:otherwise>
          <ul class="chat-messages">
            <c:forEach var="chat" items="${chatList}">
              <!-- 내가 보낸 메시지 -->
              <c:if test="${memId == chat.tmSender}">
                <li class="my-message">
                  <strong>${chat.tmSender}</strong>
                  <div class="message-content">
                    <c:choose>
                      <c:when test="${chat.tmContentType eq 'TEXT'}">
                        <p class="chat-box">${chat.tmContent}</p>
                      </c:when>
                      <c:when test="${chat.tmContentType eq 'IMG'}">
                        <!-- 이미지만 표시 -->
                        <img src="${chat.tmContent}" alt="이미지" class="chat-image">
                      </c:when>
                      <c:when test="${chat.tmContentType eq 'APPOINTMENT'}">
                        <span class="appointment-message">약속 장소와 시간이 잡혔습니다.</span>
                        <c:if test="${chat.tmStatus eq 'REQUEST'}">
                          <span style="color:orange;">(약속 요청중)</span>
                        </c:if>
                        <c:if test="${chat.tmStatus eq 'R'}">
                          <span style="color:blue; font-weight:bold;">(예약중)</span>
                        </c:if>
                        <c:if test="${chat.tmStatus eq 'C'}">
                          <span style="color:red; font-weight:bold;">(거래완료)</span>
                        </c:if>
                        <!-- 약속 상세보기 -->
                        <span class="fake-link" style="margin-left:5px; color:blue; text-decoration:underline; cursor:pointer;"
                              onclick="showAppointmentDetail('${chat.tmMeetDate}','${chat.tmMeetPlace}')">상세보기</span>
                      </c:when>
                    </c:choose>
                    <small class="chat-time">${chat.tmDate}</small>
                  </div>
                </li>
              </c:if>

              <!-- 상대방 메시지 -->
              <c:if test="${memId != chat.tmSender}">
                <li class="other-message">
                  <strong>${chat.tmSender}</strong>
                  <div class="message-content">
                    <c:choose>
                      <c:when test="${chat.tmContentType eq 'TEXT'}">
                        <p class="chat-box bg-light">${chat.tmContent}</p>
                      </c:when>
                      <c:when test="${chat.tmContentType eq 'IMG'}">
                        <img src="${chat.tmContent}" alt="이미지" class="chat-image">
                      </c:when>
                      <c:when test="${chat.tmContentType eq 'APPOINTMENT'}">
                        <span class="appointment-message">약속 장소와 시간이 잡혔습니다.</span>
                        <c:if test="${chat.tmStatus eq 'REQUEST'}">
                          <button class="confirm-button" onclick="confirmAppointment('${chat.tmChatId}')">확인</button>
                        </c:if>
                        <c:if test="${chat.tmStatus eq 'R'}">
                          <span style="color:blue; font-weight:bold;">(예약중)</span>
                        </c:if>
                        <c:if test="${chat.tmStatus eq 'C'}">
                          <span style="color:red; font-weight:bold;">(거래완료)</span>
                        </c:if>
                        <span class="fake-link" style="margin-left:5px; color:green; text-decoration:underline; cursor:pointer;"
                              onclick="showAppointmentDetail('${chat.tmMeetDate}','${chat.tmMeetPlace}')">상세보기</span>
                      </c:when>
                    </c:choose>
                    <small class="chat-time">${chat.tmDate}</small>
                  </div>
                </li>
              </c:if>
            </c:forEach>
          </ul>
        </c:otherwise>
      </c:choose>

      <!-- 거래완료 안내문 (배경 제거, 진한 파랑 텍스트) -->
      <div id="completeNotice" class="complete-notice"
           style="display:none; color:#0D47A1; font-weight:bold; margin-top:10px; text-align:center;">
        거래가 완료되었습니다!
      </div>
    </div>
  </div>

  <!-- 채팅 입력창 -->
  <div class="input-container">
    <button id="btnImgAttach">
      <img src="/images/plus.png" alt="이미지첨부">
    </button>
    <input type="file" id="fileInput" accept="image/*" style="display:none;">
    <input type="text" id="msgInput" placeholder="메시지를 입력해주세요..." class="form-control">
    <button id="btnSend" disabled>
      <img src="/images/send.png" alt="전송">
    </button>
  </div>
</div>

<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

<!-- SockJS, stomp.js -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
/* -----------------------------
   전역 변수 (채팅방 정보 등)
----------------------------- */
var tmChatId    = "${chatId}";
var memId       = "${memId}";
var chatSeller  = "${roomView.chatSeller}";
var chatBuyer   = "${roomView.chatBuyer}";
var tmStatus    = "${tmStatus}";
var client      = null; 
var detailReview= "${detailReview}";

console.log("tmChatId=", tmChatId);

$(document).ready(function () {
  console.log("[DEBUG] tmChatId =", tmChatId, ", memId =", memId);

  // 1) 거래 버튼 초기화
  initTradeButtons();

  // 2) STOMP 연결
  var sock = new SockJS("/endpoint");
  client = Stomp.over(sock);

  client.connect(
    { userId: memId, chatId: tmChatId },
    function () {
      console.log("[DEBUG] STOMP 연결 성공");

      // 3) 메시지 구독
      client.subscribe("/subscribe/chat/" + tmChatId, function (msg) {
        var data = JSON.parse(msg.body);
        console.log("[DEBUG] 수신된 메시지:", data);

        if (data.type === "notification") {
          console.log("[DEBUG] 알림 메시지:", data.message);
          return;
        }

        // 일반 채팅 or 약속 메시지
        var html = renderMessage(data);
        var messagesUl = document.querySelector(".chat-messages");
        if (!messagesUl) {
          console.error("chat-messages 요소를 찾을 수 없습니다!");
          return;
        }
        messagesUl.innerHTML += html;
        scrollDown();

        // 약속(REQUEST, R, C) 상태라면 거래 상태 갱신
        if (data.tmContentType === "APPOINTMENT") {
          updateTradeStatus(data.tmStatus); 
        }
      });
    },
    function (err) {
      console.error("[ERROR] STOMP 연결 실패:", err);
      document.querySelector(".chatcontent").innerHTML =
        "<p style='color:red;'>채팅 서버 연결에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.</p>";
    }
  );

  // 4) 채팅 입력창/버튼 이벤트
  $("#btnSend").click(sendMessage);
  $("#msgInput").on("input", toggleSendButton);
  $("#msgInput").keydown(function (e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  $("#btnImgAttach").click(function () {
    $("#fileInput").click();
  });
  $("#fileInput").change(onImageSelected);

  // 후기 작성 모달 닫힐 때
  $("#insertReviewModal").on("hide.bs.modal", function () {
    $("#revContent").val("");
    $("input[name='revScore']").prop("checked", false);
  });
});

/* -----------------------------
   메시지 입력 여부 체크
----------------------------- */
function toggleSendButton() {
  var msg = $("#msgInput").val().trim();
  $("#btnSend").prop("disabled", msg === "");
}

/* -----------------------------
   거래 버튼 초기화
----------------------------- */
function initTradeButtons() {
  // 모든 버튼/요소 숨기기
  $("#btnAppointment, #btnComplete, #btnReview, #alreadyReviewed, #completeNotice").hide();

  if (tmStatus === "N" || tmStatus === "REQUEST") {
    $("#btnAppointment")
      .show()
      .off("click")
      .on("click", handleAppointment);

  } else if (tmStatus === "R") {
    $("#btnComplete")
      .show()
      .off("click")
      .on("click", handleComplete);

  } else if (tmStatus === "C") {
    // 거래 완료 상태
    if (!detailReview) {
      $("#btnReview")
        .show()
        .off("click")
        .on("click", openReviewModal);
    } else {
      $("#alreadyReviewed").show();
    }
    $("#completeNotice").show();
    // 상대방 후기 보기 버튼
    $("#btnOtherReview").show();
  }
}

/* -----------------------------
   이미지 파일 업로드 처리
----------------------------- */
function onImageSelected(e) {
  var file = e.target.files[0];
  if (!file) return;

  var validTypes = ["image/jpeg", "image/png", "image/gif"];
  if (validTypes.indexOf(file.type) === -1) {
    alert("이미지 파일만 업로드 가능합니다.");
    $(this).val("");
    return;
  }

  var fd = new FormData();
  fd.append("file", file);
  fd.append("tmSender", memId);
  fd.append("tmChatId", tmChatId);

  $.ajax({
    url: "/files/upload",
    type: "POST",
    data: fd,
    dataType: "json",
    processData: false,
    contentType: false,
    success: function (res) {
      console.log("[DEBUG] 이미지 업로드 성공:", res);
      // 업로드 성공 후 STOMP (IMG)
      client.send(
        "/app/hello/" + tmChatId,
        {},
        JSON.stringify({
          tmContent: res.imagePath,
          tmContentType: "IMG",
          tmSender: memId,
          tmChatId: tmChatId
        })
      );
    },
    error: function (err) {
      console.log("[ERROR] 이미지 업로드 실패", err);
      alert("이미지 업로드 실패");
    }
  });
}

/* -----------------------------
   텍스트 메시지 전송
----------------------------- */
function sendMessage() {
  var msg = $("#msgInput").val().trim();
  if (!msg) return;

  client.send(
    "/app/hello/" + tmChatId,
    {},
    JSON.stringify({
      tmContent: msg,
      tmSender: memId,
      tmContentType: "TEXT",
      tmChatId: tmChatId,
      chatSeller: chatSeller
    })
  );
  $("#msgInput").val("").trigger("input");
}

/* -----------------------------
   메시지 렌더링 (TEXT, IMG, APPOINTMENT)
----------------------------- */
function renderMessage(data) {
  var content = "";

  if (data.tmContentType === "APPOINTMENT") {
    content = renderAppointment(data);
  } else if (data.tmContentType === "IMG") {
    content = "<img src='" + data.tmContent + "' class='chat-image'>";
  } else {
    // TEXT
    content = "<p class='chat-box'>" + data.tmContent + "</p>";
  }

  var html = "";
  if (data.tmSender === memId) {
    // 내가 보낸 메시지
    html += "<li class='my-message'>";
    html +=   "<strong>" + data.tmSender + "</strong>";
    html +=   "<div>" + content + "<small class='chat-time'>" + data.tmDate + "</small></div>";
    html += "</li>";
  } else {
    // 상대방 메시지
    html += "<li class='other-message'>";
    html +=   "<strong>" + data.tmSender + "</strong>";
    html +=   "<div>" + content + "<small class='chat-time'>" + data.tmDate + "</small></div>";
    html += "</li>";
  }
  return html;
}

/* -----------------------------
   약속 메시지 ("장소와 시간이 잡혔습니다.")
----------------------------- */
function renderAppointment(data) {
  var displayText = "약속 장소와 시간이 잡혔습니다.";
  var statusText = "";

  if (data.tmStatus === "REQUEST") {
    if (data.tmSender === memId) {
      statusText = "(약속 요청중)";
    } else {
      statusText = "<button class='confirm-button' onclick=\"confirmAppointment('" + data.tmChatId + "')\">확인</button>";
    }
  } else if (data.tmStatus === "R") {
    statusText = "<span style='color:blue; font-weight:bold;'>(예약중)</span>";
  } else if (data.tmStatus === "C") {
    statusText = "<span style='color:red; font-weight:bold;'>(거래완료)</span>";
  }

  var detailLink =
    "<span class='fake-link' style='margin-left:5px; color:blue; text-decoration:underline; cursor:pointer;'"
    + " onclick=\"showAppointmentDetail('" + data.tmMeetDate + "','" + data.tmMeetPlace + "')\">상세보기</span>";

  return "<span class='appointment-message'>" + displayText + "</span> "
       + statusText + " "
       + detailLink;
}

/* -----------------------------
   약속 확인
----------------------------- */
function confirmAppointment(chatId) {
  client.send(
    "/app/hello/" + chatId,
    {},
    JSON.stringify({
      tmContent: "약속 확인되었습니다.",
      tmSender: memId,
      tmContentType: "APPOINTMENT",
      tmStatus: "R",
      tmChatId: chatId
    })
  );
  updateTradeStatus("R");
}

/* -----------------------------
   거래 상태 업데이트
----------------------------- */
function updateTradeStatus(status) {
  tmStatus = status;
  initTradeButtons();
}

/* -----------------------------
   약속잡기 처리 (모달)
----------------------------- */
function handleAppointment() {
  if (tmStatus === "R" || tmStatus === "C") {
    alert("이미 약속 중이거나 거래 완료된 상태입니다.");
    return;
  }
  var modal = new bootstrap.Modal(document.getElementById("promiseModal"));
  modal.show();
}

/* -----------------------------
   거래완료 처리
----------------------------- */
function handleComplete() {
  if (tmStatus !== "R") {
    alert("예약 중 상태가 아니므로 거래 완료 불가합니다.");
    return;
  }
  client.send(
    "/app/hello/" + tmChatId,
    {},
    JSON.stringify({
      tmContent: "거래 완료",
      tmSender: memId,
      tmContentType: "APPOINTMENT",
      tmStatus: "C",
      tmChatId: tmChatId
    })
  );
  updateTradeStatus("C");
}

/* -----------------------------
   후기 작성 모달 열기
----------------------------- */
function openReviewModal() {
  $("#revWriter").val(memId);
  $("#revTarget").val(memId === chatSeller ? chatBuyer : chatSeller);
  $("#revProdId").val("${roomView.chatProdId}");
  $("input[name='revScore']").prop("checked", false);
  $("#revContent").val("");

  var modal = new bootstrap.Modal(document.getElementById("insertReviewModal"));
  modal.show();
}

/* -----------------------------
   후기 등록 (submitReview)
----------------------------- */
function submitReview() {
  var revWriter = $("#revWriter").val();
  var revTarget = $("#revTarget").val();
  var revProdId = $("#revProdId").val();
  var revScore  = $("input[name='revScore']:checked").val();
  var revContent= $("#revContent").val().trim();

  if (!revScore) {
    alert("별점을 선택하세요!");
    return;
  }
  if (!revContent) {
    alert("후기 내용을 입력하세요!");
    return;
  }

  $.ajax({
    url: "/review/write",
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      revWriter: revWriter,
      revTarget: revTarget,
      revProdId: revProdId,
      revScore: revScore,
      revContent: revContent
    }),
    success: function(res) {
      if (res.success) {
        alert("후기가 등록되었습니다!");
        var modal = bootstrap.Modal.getInstance(document.getElementById("insertReviewModal"));
        modal.hide();
        $("#btnReview").hide();
      } else {
        alert("후기 등록 실패: " + res.message);
      }
    },
    error: function(err) {
      console.error("후기 등록 중 에러:", err);
      alert("후기 등록 실패");
    }
  });
}

/* -----------------------------
   내가 쓴 후기 보기
----------------------------- */
function openReviewDetail() {
  var revProdId = "${roomView.chatProdId}";
  var revWriter = "${memId}"; 

  $.ajax({
    url: "/review/detail",
    type: "GET",
    data: { revProdId: revProdId, revWriter: revWriter },
    success: function(res) {
      if (res.success) {
        var review = res.review;
        var hearts = "";
        for (var i = 0; i < review.revScore; i++) {
          hearts += "♥";
        }

        var detailHtml  = "<p><strong>평점</strong> : " + hearts + "</p>"
                        + "<p><strong>내용</strong> : " + review.revContent + "</p>"
                        + "<p><strong>작성일</strong> : " + review.revDate + "</p>";
        
        $("#reviewDetail").html(detailHtml);

        var modal = new bootstrap.Modal(document.getElementById("viewReviewModal"));
        modal.show();
      } else {
        alert("후기를 찾을 수 없습니다.");
      }
    },
    error: function(err) {
      console.error("후기 불러오기 에러:", err);
      alert("후기 정보를 불러오지 못했습니다.");
    }
  });
}

/* -----------------------------
   상대방 후기 보기
----------------------------- */
function openOtherReviewDetail() {
  var otherId = (memId === chatSeller) ? chatBuyer : chatSeller;
  $.ajax({
    url: "/review/otherDetail",
    type: "GET",
    data: {
      revProdId: "${roomView.chatProdId}",
      revWriter: otherId
    },
    success: function(res) {
      if (res.success) {
        var review = res.review;
        var hearts = "";
        for (var i = 0; i < review.revScore; i++) {
          hearts += "♧";
        }

        var detailHtml  = "<p><strong>평점</strong> : " + hearts + "</p>"
                        + "<p><strong>작성자</strong> : " + review.revWriter + "</p>"
                        + "<p><strong>대상자</strong> : " + review.revTarget + "</p>"
                        + "<p><strong>내용</strong> : " + review.revContent + "</p>"
                        + "<p><strong>작성일</strong> : " + review.revDate + "</p>";
        $("#reviewDetail").html(detailHtml);

        var modal = new bootstrap.Modal(document.getElementById("viewReviewModal"));
        modal.show();
      } else {
        alert("상대방 후기를 찾을 수 없습니다.\n" + (res.message || ""));
      }
    },
    error: function(err) {
      console.error("상대방 후기 불러오기 에러:", err);
      alert("상대방 후기 조회 실패");
    }
  });
}

/* -----------------------------
   약속 상세보기
----------------------------- */
function showAppointmentDetail(dateTimeStr, placeStr) {
  // ex: "2025-01-10 22:46:00"
  var splitted = dateTimeStr.split(" ");
  var datePart = splitted[0]; 
  var timePart = splitted[1]; 

  // 초(:00) 제거
  if(timePart && timePart.length >= 5) {
    timePart = timePart.substring(0,5); 
  }

  var detailHtml =
    "<p><strong>약속 날짜</strong> : " + datePart + "</p>" +
    "<p><strong>약속 시간</strong> : " + timePart + "</p>" +
    "<p><strong>약속 장소</strong> : " + placeStr + "</p>";

  document.getElementById("appointmentDetailBody").innerHTML = detailHtml;
  var modal = new bootstrap.Modal(document.getElementById("appointmentDetailModal"));
  modal.show();
}
</script>
</body>
</html>