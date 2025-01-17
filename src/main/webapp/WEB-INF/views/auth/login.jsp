<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>login</title>
<link rel="stylesheet" href="/css/login.css">
</head>
<body>
	<div class="container">
		<div class="logo-section">
			<img src="/static/assets/img/parm.png" alt="푸른이음 로고" class="logo" onclick="window.location.href = '/'">
			<p class="logo-text">
				농산물 직거래 플랫폼
			</p>
		</div>
		<div class="form-section">
			<form class="login-form">
				<div class="form-group">
					<label for="email">아이디</label> 
					<input type="email" id="idInput" placeholder="아이디를 입력해주세요">
				</div>
				<div class="form-group">
					<label for="password">비밀번호</label> 
					<input type="password" id="passwordInput" placeholder="비밀번호를 입력해주세요">
				</div>
				<button id="loginBtn" type="button" class="sign-in-btn">로그인</button>
				<button id="kakaoLoginBtn" type="button" style="background-color:rgba(0, 0, 0, 0); padding:0px; padding-top:10px;"><img id='kakaoLoginImg' src="//k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" alt="카카오 로그인 버튼"  width="300"/></button>
				<div style="text-align: center;">
					<a href="/auth/findIdView" class="forgot-id">아이디찾기</a>
					<p class="partition">|</p>
					<a href="/auth/findPasswordView" class="forgot-password">비밀번호찾기</a>
					<p class="partition">|</p>
					<a href="/auth/signupView" class="signup">회원가입</a>
				</div>
			</form>
		</div>
	</div>
</body>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>


<script>
//     Kakao.init('aec68c95dc07259cc3bcc5af7b2802c3'); 
    Kakao.init('e30dcae662514c1ba98b132b68403075'); 
	
    function loginWithKakao() {
        Kakao.Auth.login({
            success: function(authObj) {
                const accessToken = authObj.access_token;
                fetch('/auth/kakaoLogin', {
                    method: 'POST',
                    body: accessToken
                })
                .then(response => {
                	response.text().then(text => {
                    	document.cookie = "accessToken=" + text + "; path=/; samesite=strict";
                    	window.location.href = '/';
                	})
                })
                .catch(error => console.error('Error:', error)); // 오류 처리
            },
            fail: function(error) {
                console.log(error); // 로그인 실패 시 오류 처리
            }
        });
    }
    
    document.getElementById("kakaoLoginBtn").addEventListener('click', loginWithKakao);
    
	const urlParams = new URLSearchParams(window.location.search);
	const memId = urlParams.get('memId');
	
	// 아이디 입력창에 값 설정
	if (memId) {
	    document.getElementById('idInput').value = memId;
	}
	/* jshint esversion: 6 */ 
	function login() {
		const memId = document.getElementById('idInput').value;
		const memPass = document.getElementById('passwordInput').value;
	
		const formData = new FormData();
	    formData.append('memId', memId);
	    formData.append('memPass', memPass);
	
	    fetch('/auth/loginDo', {
	        method: 'POST',
	        body: formData
	    })
	    .then(response => {
	        if (response.ok) {
	            return response.text(); 
	        } else {
	            throw new Error('로그인 실패');
	        }
	    })
	    .then(response => {
	        document.cookie = "accessToken=" + response + "; path=/; samesite=strict";
	        window.location.href = '/';
	    })
	    .catch(error => {
	        console.log('로그인 실패', error);
	        alert('아이디와 비밀번호를 확인해주세요');
	    });
	}
	
	document.getElementById("loginBtn").addEventListener('click', login);
	
	document.getElementById("idInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	        login();
	    }
	});

	document.getElementById("passwordInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	        login();
	    }
	});

</script>

</html>

