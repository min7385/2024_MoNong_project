<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>findId</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
	                    <label for="memName">이름</label>
	                    <input type="text" id="memName" name="memName" placeholder="이름을 입력해주세요">
	                </div>
					<div class="form-group">
	                    <label for="memPhone">전화번호</label>
	                    <div class="input-group mb-3">
		                    <input type="text" id="memPhone" name="memPhone" placeholder="-제외하고 입력해주세요" style="width:70%;" required>
		                    <button type="button" class="input-group-text otherBtn" id="SMSBtn" style="width:30%; justify-content: center; ">코드 전송</button>
	                    </div>
	                </div>
	                <div class="form-group">
	                    <label for="verCode">인증번호</label>
	                    <input type="text" id="verCode" name="verCode" placeholder="인증번호를 입력해주세요">
	                    <div class="invalid-feedback">
				      		인증번호를 다시 확인해주세요!!
				    	</div>
	                </div>
	                <button id="findBtn" type="button" class="sign-in-btn">아이디찾기</button>
                </div>
                
		
			
			
<!-- 				<div id="findDiv"> -->
<!-- 					<div class="form-group"> -->
<!-- 						<label for="phoneNumber">핸드폰번호를 입력해주세요</label>  -->
<!-- 						<input type="text" id="phoneNumberInput" placeholder="phoneNumber"> -->
<!-- 					</div> -->
					
<!-- 				</div> -->
				<div id="resultDiv" style="display:none;">
					<p>해당 번호로 가입되어있는 아이디는 <br>
					<strong id="result"></strong><br>
					입니다.</p><br>
					<button id="goToLoginBtn" type="button" class="sign-in-btn">로그인하기</button>
				</div>
			</form>
		</div>
	</div>
</body>
<script>
	/* jshint esversion: 6 */ 
	document.addEventListener('DOMContentLoaded', function() {
		let randomNum = null;
		
		document.getElementById("findBtn").addEventListener('click', function() {
			const verCode = document.getElementById('verCode')
			
	    	if (verCode.value === randomNum && randomNum != null){
    			verCode.classList.remove('is-invalid');
    			findIdDo();
    		}else if (randomNum == null || verCode.value === "") {
    			verCode.classList.remove('is-invalid');
    		}else{
    			verCode.classList.add('is-invalid');
    		}
		});
		
		function findIdDo() {
			const findDiv = document.getElementById('findDiv')
		    const resultDiv = document.getElementById('resultDiv')
		    const result = document.getElementById('result')
		    const formData = new FormData();
    		formData.append('memName', document.getElementById('memName').value);
  			formData.append('memPhone', document.getElementById('memPhone').value);

			 fetch('/auth/findIdDo', {
			        method: 'POST',
			        body: formData
			    })
			    .then(response => {
		 		        if (response.ok) {
	 		            return response.text(); 
	 		        } else {
	 		            throw new Error('찾기 실패');
	 		        }
	 		    })
	 		    .then(response => {
	 		    	console.log(response)
	 		    	findDiv.style.display = 'none';
	 		    	result.innerHTML = response;
	 		    	resultDiv.style.display = 'block';
	 		    	alert("찾기 성공")
	 		    })
	 		    .catch(error => {
	 		        console.log('찾기 실패', error);
	 		        alert('전화번호를 확인해주세요');
	 		    });

		}
		
		 function sendOne() {
		        const memPhone = document.getElementById('memPhone').value;
	
		        fetch('/auth/send-one', {
		            method: 'POST',
		            body: memPhone
		        })
		        .then(response => {
	             	response.text().then(text => {
							randomNum = text;
							alert('인증번호를 발송했습니다.')
	             	})
	          })
		        .catch(error => {
		            console.error('Error:', error);  // 오류 처리
		        });
		    }
	
			document.getElementById('SMSBtn').addEventListener('click',sendOne);
		
		/* jshint esversion: 6 */ 
		function goToLogin() {
			const memId = document.getElementById('result').innerHTML;
		    window.location.href = 'loginView?memId=' + encodeURIComponent(memId);
		}
		
		document.getElementById("memPhone").addEventListener('keydown', function(event) {
		    if (event.key === 'Enter') {
		    	findId();
		    }
		});
		
		document.getElementById("goToLoginBtn").addEventListener('click', goToLogin)
	})
	
</script>

</html>

