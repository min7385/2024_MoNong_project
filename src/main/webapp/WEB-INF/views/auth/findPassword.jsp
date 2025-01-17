<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>findPassword</title>
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
				<div id="findDiv">
					<div class="form-group">
						<label for="id">아이디</label> 
						<input type="text" id="idInput" placeholder="아이디를 입력해주세요">
					</div>
					<div class="form-group">
						<label for="phoneNumber">전화번호</label> 
						<input type="text" id="phoneNumberInput" placeholder="-제외하고 입력해주세요">
					</div>
					<button id="findBtn" type="button" class="sign-in-btn">비밀번호찾기</button>
				</div>
				<div id="resultDiv" style="display:none;">
					<div class="form-group">
						<label for="newPassword">새비밀번호를 입력해주세요</label> 
						<input type="password" id="newPasswordInput" placeholder="새비밀번호">
					</div>
					<div class="form-group">
						<label for="repeatPassword">새비밀번호를 다시 입력해주세요</label> 
						<input type="password" id="repeatPasswordInput" placeholder="비밀번호 확인">
					</div>
					<button id="updateBtn" type="button" class="sign-in-btn">비밀번호찾기</button>
				</div>
			</form>
		</div>
	</div>
</body>
<script>
	/* jshint esversion: 6 */ 
	function findPassword() {
	    const memId = document.getElementById('idInput').value;
	    const memPhone = document.getElementById('phoneNumberInput').value;
		
		const findDiv = document.getElementById('findDiv')
	    const resultDiv = document.getElementById('resultDiv')
	    
	    const formData = new FormData();
	    formData.append('memId', memId);
	    formData.append('memPhone', memPhone);
	
	    fetch('/auth/findPasswordDo', {
	        method: 'POST',
	        body: formData
	    })
	    .then(response => response.json())
	    .then(result => {
	        if (result) {
	        	findDiv.style.display = 'none';
	        	resultDiv.style.display = 'block';
	        } else {
	            alert('아이디와 번호를 다시 확인해주세요.')
	        }
	    })
	    .catch(error => {
	        console.log('실패', error);
	    });
	}

	function updatePassword() {
		const newPassword = document.getElementById('newPasswordInput').value;
	    const repeatPassword = document.getElementById('repeatPasswordInput').value;
	    if(newPassword == repeatPassword){
	    	const memId = document.getElementById('idInput').value;
	    	
	    	const formData = new FormData();
	    	formData.append('memId', memId);
		    formData.append('memPw', newPassword);
	    	
	    	fetch('/auth/updatePassword', {
		        method: 'POST',
		        body: formData
		    })
		    .then(response => {
		        alert("비밀번호 재설정에 성공했습니다. 로그인해주세요.")
		        window.location.href = 'loginView'
		    })
		    .catch(error => {
		        console.log('실패', error);
		        alert("비밀번호 재설정에 실패하셨습니다. 다시 시도해주세요.")
	    		const memPhone = document.getElementById('phoneNumberInput').value;
		        newPassword = '';
		        repeatPassword = '';
		        memId = '';
		        memPhone = '';
		        findDiv.style.display = 'block';
	        	resultDiv.style.display = 'none';
		    });
	    }else{
	    	console.log('diff');
	    }
	}

	
	
	document.getElementById("findBtn").addEventListener('click', findPassword);
	document.getElementById("idInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	    	findPassword();
	    }
	});
	document.getElementById("phoneNumberInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	    	findPassword();
	    }
	});

	document.getElementById("updateBtn").addEventListener('click', updatePassword);
	document.getElementById("newPasswordInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	    	updatePassword();
	    }
	});
	document.getElementById("repeatPasswordInput").addEventListener('keydown', function(event) {
	    if (event.key === 'Enter') {
	    	updatePassword();
	    }
	});
</script>

</html>

