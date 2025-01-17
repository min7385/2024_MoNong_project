<%
  /* ================================================================= 
   * 작성일     : 2024. 12. 17. 
   * 작성자     : 팽수
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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>간단한 채팅 테스트</title>
<script type="text/javascript">
    let ws;

    /**
     * WebSocket 연결을 설정하는 함수입니다.
     * 서버의 WebSocket 핸들러에 연결합니다.
     */
    function connect() {
        const serverIp = "192.168.0.46"; // 서버의 IP 주소
        ws = new WebSocket("ws://" + serverIp + ":8080/chat");

        // WebSocket 연결이 성공했을 때 실행
        ws.onopen = function () {
            console.log("WebSocket 연결 성공!");
        };

        // 서버로부터 메시지를 받았을 때 실행
        ws.onmessage = function (event) {
            const chatBox = document.getElementById("chatBox");
            chatBox.value += event.data + "\n"; // 메시지를 채팅 박스에 추가
        };

        // WebSocket 연결이 종료되었을 때 실행
        ws.onclose = function () {
            console.log("WebSocket 연결이 종료되었습니다.");
        };

        // WebSocket 오류 발생 시 실행
        ws.onerror = function (error) {
            console.error("WebSocket 오류 발생:", error);
        };
    }

    /**
     * 사용자가 입력한 메시지를 서버로 전송하는 함수입니다.
     * WebSocket 연결 상태를 확인 후 메시지를 전송합니다.
     */
    function sendMessage() {
        const messageInput = document.getElementById("message");
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(messageInput.value); // 메시지 전송
            messageInput.value = ""; // 입력창 초기화
        } else {
            alert("WebSocket 연결이 아직 열리지 않았습니다. 잠시 후 다시 시도해주세요.");
        }
    }
</script>
</head>
<body onload="connect()"> <!-- 페이지 로드 시 WebSocket 연결 -->
    <h2>채팅</h2>
    <!-- 채팅 메시지를 표시할 영역 -->
    <textarea id="chatBox" rows="20" cols="50" readonly></textarea><br>
    <!-- 메시지를 입력할 입력창 -->
    <input type="text" id="message" placeholder="메시지 입력">
    <button onclick="sendMessage()">전송</button>
</body>
</html>