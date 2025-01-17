<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>sign up</title>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
 	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link rel="stylesheet" href="/css/login.css">
	<style>
		#find-address {
			background-color: #9FF781; /* 화사한 하늘색 */
		    color: #6E6E6E;
		}
		
		body {
			height:150vh;
		}
	</style>
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
                <h2>회원가입</h2>
                
                <div class="form-group">
                    <label for="mem_id">아이디</label>
                    <div class="input-group mb-3">
	                    <input type="text" id="mem_id" name="mem_id" placeholder="아이디를 입력해주세요" style="width:70%;" required>
	                    <button type="button" class="input-group-text otherBtn" id="id_check" style="width:30%; justify-content: center; ">중복 확인</button>
	                    <div class="invalid-feedback">
					      	사용중인 아이디입니다
					    </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="mem_pass">비밀번호</label>
                    <input type="password" id="mem_pass" name="mem_pass" placeholder="비밀번호를 입력해주세요" required>
                </div>
                <div class="form-group">
                    <label for="mem_pass_repeat">비밀번호 확인</label>
                    <input type="password" id="mem_pass_repeat" name="mem_pass_repeat" placeholder="비밀번호를 다시 입력해주세요" required>
                    <div class="invalid-feedback">
				      	비밀번호가 다릅니다
				    </div>
                </div>
                <div class="form-group">
                    <label for="mem_name">이름</label>
                    <input type="text" id="mem_name" name="mem_name" placeholder="이름을 입력해주세요" required>
                </div>
                <div class="form-group">
                    <label for="mem_phone">전화번호</label>
                    <div class="input-group mb-3">
	                    <input type="text" id="mem_phone" name="mem_phone" placeholder="-제외하고 입력해주세요" style="width:70%;" required>
	                    <button type="button" class="input-group-text otherBtn" id="SMSBtn" style="width:30%; justify-content: center; ">코드 전송</button>
                    </div>
                </div>
                <div class="form-group">
                    <label for="ver_code">인증번호</label>
                    <input type="text" id="ver_code" name="ver_code" placeholder="인증번호를 입력해주세요">
                    <div class="invalid-feedback">
				      	인증번호를 다시 확인해주세요!!
				    </div>
                </div>
                <div class="form-group">
                    <label for="mem_nic">닉네임</label>
                    <input type="text" id="mem_nic" name="mem_nic" placeholder="닉네임을 입력해주세요">
                </div>
				<div class="form-group">
				    <label for="mem_addr">주소</label>
				    <!-- 주소 표시 영역 -->
				    <div id="address-container" style="display:none;">
				        <span id="address-value"></span>
				        <button type="button" id="delete-address">X</button>
				    </div>
				    <!-- 주소 찾기 버튼 -->
				    <div><button type="button" id="find-address" class="otherBtn">주소 찾기</button></div>
				</div>
                <button id="singinBtn" type="button" class="sign-in-btn">가입하기</button>
            </form>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
    	
    	let randomNum = null;
    	
    	const memPass = document.getElementById('mem_pass');
	    const memPassRe = document.getElementById('mem_pass_repeat');
    	
	    function passwordCheck(){
    		if (memPass.value === memPassRe.value && memPass.value !== ""){
    			memPassRe.classList.remove('is-invalid');
    		} else if (memPass.value === "" && memPassRe.value === "") {
    			memPassRe.classList.remove('is-invalid');
    	    } else {
    	    	memPassRe.classList.add('is-invalid');
    	    }
    	}
	    
    	memPass.addEventListener('change', passwordCheck);
    	memPassRe.addEventListener('change', passwordCheck);

//     	const verCode = document.getElementById('ver_code');
    	
//     	function verCheck(){
//     		if (verCode.value === randomNum && randomNum != null){
//     			verCode.classList.remove('is-invalid');
//     		}else if (randomNum == null) {
//     			verCode.classList.remove('is-invalid');
//     		}else{
//     			verCode.classList.add('is-invalid');
//     		}
//     	}
    	
//     	verCode.addEventListener('change', verCheck);
    	
   		const memId = document.getElementById('mem_id');
    	
    	document.getElementById("id_check").addEventListener('click', function () {
    		const idValue = memId.value.trim();
    		
    		fetch('/auth/idCheck', {
    			method: 'POST', 
    			headers: {
    	            'Content-Type': 'application/json', // 데이터 형식은 JSON
    	        },
    	        body: JSON.stringify(idValue),
    		})
    		.then(response => response.text())
    		.then(data => {
    			if (data != "") {
    				memId.classList.add('is-invalid');
    			}else{
    				memId.classList.remove('is-invalid');
    				alert("사용가능한 아이디입니다")
    			}
    		})
    		.catch(error => {
    			console.error("오류 발생", error)
    			alert('오류가 발생했습니다. 다시 시도해주세요')
    		})
    	});
    	
    	
    	document.getElementById("singinBtn").addEventListener('click', function () {
    		const verCode = document.getElementById('ver_code');
    		if (verCode.value === randomNum && randomNum != null){
    			verCode.classList.remove('is-invalid');
    			signUpDo();
    		}else if (randomNum == null || verCode.value === "") {
    			verCode.classList.remove('is-invalid');
    		}else{
    			verCode.classList.add('is-invalid');
    		}
		});	
    	
    	function signUpDo() {
    		const formData = {
	    		    memId: document.getElementById('mem_id').value,
	    		    memPass: document.getElementById('mem_pass').value,
	    		    memPassRe: document.getElementById('mem_pass_repeat').value,
	    		    memName: document.getElementById('mem_name').value,
	    		    memPhone: document.getElementById('mem_phone').value,
	    		    memNic: document.getElementById('mem_nic').value,
	    		    memAddr: document.getElementById("address-value").textContent
	    		};
			
	    		fetch('/auth/signupDo', {
	    		    method: 'POST',
	    		    headers: {
	    		        'Content-Type': 'application/json'
	    		    },
	    		    body: JSON.stringify(formData)
	    		})
		
			    .then(response => response.text())
			    .then(response => {
			        alert("회원가입에 성공했습니다")
			        window.location.href = '/auth/loginView';
			    })
			    .catch(error => {
			        console.log('로그인 실패', error);
			        alert('오류가 발생했습니다. 다시 시도해주세요.');
			    });
    	}
    
    	document.getElementById("find-address").addEventListener("click",findAddress);
    	
	    function findAddress() {
	    	 new daum.Postcode({
		          oncomplete: function (data) {
		           	var addr = data.address; // 사용자가 선택한 주소
		           	document.getElementById("address-value").textContent = addr;
	     		    document.getElementById("address-container").style.display = "block"; // 주소 영역 보이기
	              } 
	         }).open();
// 	    	주소 찾기 창 호출 (여기서는 임시값 설정으로 대체)
	        
	    }
	    
	    document.getElementById("delete-address").addEventListener("click",deleteAddress);
	
	    function deleteAddress() {
	        // 주소 삭제
	        document.getElementById("address-value").textContent = "";
	        document.getElementById("address-container").style.display = "none"; // 주소 영역 숨기기
	    }
	
	    // 초기 상태에서 주소 표시 영역 숨기기
	    document.addEventListener("DOMContentLoaded", () => {
	        document.getElementById("address-container").style.display = "none";
	    });
	    
	    
	    function sendOne() {
	        const memPhone = document.getElementById('mem_phone').value;

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
	    
    });
	</script>
    
</body>
</html>

