<%
  /* ================================================================= 
   * 작성일     : 2024. 12. 26. 
   * 작성자     : 한준희
   * 상세설명  : 판매자가 판매상세뷰에서 버튼 클릭시 볼수 있는 채팅리스트 화면
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat List</title>
</head>
<body>
<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
<div class="container mt-5">
    <div class="list-group">
        <c:forEach var="chat" items="${chatList}">
            <div class="list-group-item d-flex align-items-center"  style="cursor: pointer;" onclick="submitChatForm('${chat.prodId}', '${chat.chatBuyer}', '${chat.chatSeller}')">
                <!-- 프로필 이미지 (기본 이미지 처리) -->
                <img src="<c:choose>
                            <c:when test="${chat.buyerProfile != null}">
                                ${chat.buyerProfile}
                            </c:when>
                            <c:otherwise>
                                /static/assets/img/user.png
                            </c:otherwise>
                          </c:choose>"
                     alt="${chat.buyerNic}" class="rounded-circle me-3" 
                     style="width: 50px; height: 50px; object-fit: cover;">
                
                <!-- 닉네임과 마지막 메시지 -->
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between">
                        <h5 class="mb-1">${chat.buyerNic}</h5>
                        <small class="text-muted">${chat.createDt}</small>
                    </div>
                    <!-- 마지막 대화 내용 또는 이미지 표시 -->
                    <c:choose>
                        <c:when test="${chat.lastContent != null && fn:contains(chat.lastContent, '/download?')}">
                            <!-- 마지막 내용이 이미지라면 -->
                            <img src="${chat.lastContent}" alt="이미지" style="max-width: 100px; max-height: 100px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <!-- 텍스트 내용 -->
                            <p class="mb-0 text-truncate">${chat.lastContent}</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>
    <form id="commonForm" method="post" action="<c:url value='/chat' />">
    <input type="hidden" name="chatProdId" />
    <input type="hidden" name="chatBuyer" />
    <input type="hidden" name="chatSeller" />
	</form>
</div>
<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
<script>
  // (1) 공통 폼에 값 설정 후 전송하는 함수
  function submitChatForm(chatProdId, buyerId, sellerId) {
    const form = document.getElementById('commonForm');
    
    // hidden input에 값 주입
    form.chatProdId.value = chatProdId;
    form.chatBuyer.value = buyerId;
    form.chatSeller.value = sellerId;

    // 폼 제출(POST)
    form.submit();
  }
</script>
</body>
</html>