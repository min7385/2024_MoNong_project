	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<%@ page session="false" %>
	<!DOCTYPE html>
	<html lang="ko">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>내 정보</title>
	    <style>
	        /* 기본 스타일 */
	        body {
	            font-family: Arial, sans-serif;
	            margin: 0;
	            padding: 0;
	            background-color: #f9f9f9;
	            color: #333;
	        }
	
	        .mypage-container {
	            width: 90%;
	            margin: 20px auto;
	            background-color: white;
	            padding: 20px;
	            border-radius: 10px;
	            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	        }
	
	        h1 {
	            text-align: center;
	            color: #4CAF50;
	        }
	
	        /* 첫 번째 블록: 프로필 및 닉네임 */
	        .profile-block {
	            display: flex;
	            height: 500px;
	            background-color: #f4f4f4;
	            padding: 20px;
	            border-radius: 10px;
	            margin-bottom: 20px;
	        }
	        
	        .img-block{
	        	display: flex;
	        	width: 50%;
	        	height: 100%;
	        	align-items: center;
	            justify-content: center;
	        }
	
	        .profile-image {
	            width: 240px; /* 4배 크기 */
	            height: 240px;
	            border-radius: 50%;
	            object-fit: cover;
	            border: 3px solid #4CAF50;
	            display: block;
	        }
	
			.info-block{
				display: flex;
	        	width: 50%;
	        	height: 100%;
	        	align-items: center;
	            justify-content: right;
	            text-align: right;
	            padding-right:150px;
			}
			
	        .profile-info {
	        	display: block;
	        }
	        
	        .profile-actions button {
	            padding: 8px 12px;
	            font-size: 12px;
	            background-color: #4CAF50;
	            color: white;
	            border: none;
	            border-radius: 5px;
	            cursor: pointer;
	        }
	
	        .profile-actions button:hover {
	            background-color: #45a049;
	        }
	        
	        strong { 
			    font-size: 16px; 
			    margin:10px;
			}
			
			input {
			    padding: 10px;
			    margin:15px;
			    border: 1px solid #ccc;
			    border-radius: 5px;
			}
	
			.otherBtn {
	            padding: 8px 12px;
	            margin-right: 14px;
	            font-size: 12px;
	            background-color: #4CAF50;
	            color: white;
	            border: none;
	            border-radius: 5px;
	            cursor: pointer;
	        }
	
	        .otherBtn:hover {
	            background-color: #45a049;
	        }
			
	        /* 반응형 스타일 */
	        @media (max-width: 768px) {
	            .profile-block {
	                flex-direction: column;
	                align-items: center;
	            }
	
	            .profile-image {
	                width: 150px;
	                height: 150px;
	            }
	
	            .profile-info {
	                margin-left: 0;
	                text-align: center;
	            }
	        }
	    </style>
	    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	</head>
	<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="mypage-container">
	    <!-- 마이페이지 제목 -->
	    <h1>내 정보</h1>
	
	    <!-- 첫 번째 블록: 프로필 및 닉네임 -->
	    <div class="profile-block">
	        <!-- 프로필 이미지 -->
	        <div class="img-block">
		        <c:if test="${myPageInfo.memProfile == null}">
			        <img src="/download?imageFileName=non.png" id="myImage" class="profile-image" alt="프로필 이미지">
				</c:if>
				<c:if test="${myPageInfo.memProfile != null}">
					<img src="${myPageInfo.memProfile}" id="myImage" class="profile-image" alt="프로필 이미지">
				</c:if>
				<form id="profileForm" enctype="multipart/form-data">
					<input type="file" name="uploadImage" id="uploadImage" accept="image/*" style="display: none;">
				</form>
			</div>
			
			<div class="info-block">
		        <div class="profile-info">
		        	<div>
					    <strong>아이디 : </strong>
					    <input id="memId" value="${myPageInfo.memId != null ? myPageInfo.memId : '로그인x'}" style="margin:15px;" readonly>
					</div>
					<div>
					    <strong>이름 : </strong>
					    <input id="memName" value="${myPageInfo.memName != null ? myPageInfo.memName : '로그인x'}" style="margin:15px;" readonly>
					</div>
					<div>
					    <strong>닉네임 : </strong>
					    <input id="memNic" value="${myPageInfo.memNic != null ? myPageInfo.memNic : '로그인x'}" style="margin:15px;">
					</div>
                	<div style="display:flex; align-items: center;">
                   	 	<strong style="display:inline-box;">전화번호 : </strong>
                    	<div id="phoneInput" class="input-group" style="width:100%; display:inline-box; width:242.82px; height:45.45px; margin:15px;">
	                    	<input type="text" id="memPhone" name="memPhone" placeholder="전화번호를 설정해주세요" style="width:70%; margin:0px; padding:0px; padding-left:10px;" required
	                    		   value="${myPageInfo.memPhone != null ? myPageInfo.memPhone : null}" readonly>
	                    	<button type="button" class="input-group-text otherBtn" id="setPhoneBtn" style="width:30%; justify-content: center; margin:0px; padding:0px;" data-toggle="modal" data-target="#exampleModalCenter">번호 설정</button>
                    	</div>
                	</div>
					<div>
					    <strong>주소 : </strong>
					    <input id="memAddr" value="${myPageInfo.memAddr != null ? myPageInfo.memAddr : '로그인x'}" style="margin:15px;">
					</div>
					<button type="button" id="find-address" class="otherBtn">주소 찾기</button>
				</div>
	        </div>
	    </div>
        <div class="profile-actions" style="text-align: center;">
            <button id='changeBtn' type="button">개인정보 수정</button>
        </div>

        <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLongTitle">번호 설정</h5>
		      </div>
		      <div class="modal-body">
		        <div style="display:flex; align-items: center;">
                   	 	<strong style="display:inline-box;">전화번호 : </strong>
                    	<div id="phoneInput" class="input-group" style="width:100%; display:inline-box; width:300px; height:50px; margin:15px; margin-left:19px;">
	                    	<input type="text" id="modalMemPhone" name="modalMemPhone" placeholder="-제외하고 입력해주세요" style="width:70%; margin:0px; padding:0px; padding-left:10px;" required>
	                    	<button type="button" class="input-group-text otherBtn" id="sendVerButton" style="width:30%; justify-content: center; margin:0px; padding:0px;">인증</button>
                    	</div>
                	</div>
		        <div>
			      <strong>인증번호 : </strong>
				  <input id="modalVerCode" placeholder="숫자 6자리를 입력해주세요" style="margin:15px; width:300px; height:50px;">
				  <div class="invalid-feedback">
				      	인증번호를 다시 확인해주세요!!
			      </div>
				</div>
		      </div>
		      <div class="modal-footer">
		        <button id="modalSetButton" type="button" class="btn btn-primary">설정</button>
		      </div>
		    </div>
		  </div>
		</div>
        
    </div>
     <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	</body>
	<script>
	document.addEventListener("DOMContentLoaded", function() {
	    document.getElementById("myImage").addEventListener("click", function() {
	        document.getElementById("uploadImage").click();
	    });
		document.getElementById("uploadImage").addEventListener("change", function(event) {
		    let file = event.target.files[0];
		    if (file) {
		        let fileType = file.type;
		        let valTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'];
		        if (!valTypes.includes(fileType)) {
		            alert("유효한 이미지 타입이 아닙니다.");
		            event.target.value = ''; // 파일 input을 초기화
		        } else {
		            let formData = new FormData(document.getElementById("profileForm"));
	
		            fetch('<c:url value="/files/uploadProfile" />', {
		                method: 'POST',
		                body: formData,
		            })
		            .then(response => response.json()) // JSON 응답을 받음
		            .then(res => {
		                if (res.message === 'success') {
		                    // 이미지를 표시하는 부분
		                    document.getElementById("myImage").src = res.imagePath;
		                }
		            })
		            .catch(error => {
		                console.error('Error:', error);
		            });
		        }
		    }
		});
		
		const changeBtn = document.getElementById('changeBtn');
		document.getElementById('changeBtn').addEventListener('click',function(){
    		
 			const memId = document.getElementById('memId').value;
			const memNic = document.getElementById('memNic').value;
  			const memAddr = document.getElementById('memAddr').value;
  			const memPhone = document.getElementById('memPhone').value;
    		
  			const infoData = new FormData();
 			infoData.append('memId', memId);
 			infoData.append('memNic', memNic);
 			infoData.append('memAddr', memAddr);
 			infoData.append('memPhone', memPhone);
  			
    		fetch('/mypage/changeDo', {
    		    method: 'POST',
    		    body: infoData
    		})
		    .then(response => response.text())
		    .then(response => {
		    	alert("수정 성공했습니다.")
		    	window.location.href = '/mypage/main';
		    })
		    .catch(error => {
		    	alert("수정실패했습니다. 다시 시도해주세요.")
		    	window.location.reload();
		    });
		});	
		
		document.getElementById("find-address").addEventListener("click",findAddress);
		
	    function findAddress() {
	    	 new daum.Postcode({
		          oncomplete: function (data) {
		           	var addr = data.address;
		           	document.getElementById('memAddr').value = addr;
	              } 
	         }).open();
	    }
	    
    	const myModal = new bootstrap.Modal(document.getElementById('exampleModalCenter'));
	    function showModal() {
    	     myModal.show();
	    }
	    
		document.getElementById("setPhoneBtn").addEventListener("click",showModal);
		
		let randomNum = null;
		
		 function sendOne() {
		        const modalMemPhone = document.getElementById('modalMemPhone').value;

		        fetch('/auth/send-one', {
		            method: 'POST',
		            body: modalMemPhone
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

			document.getElementById('sendVerButton').addEventListener('click',sendOne);
			
			
			function modalSet(){
				const modalVerCode = document.getElementById('modalVerCode');
				if(modalVerCode.value == randomNum && randomNum != null){
					document.getElementById('memPhone').value = document.getElementById('modalMemPhone').value;
					modalVerCode.classList.remove('is-invalid');
					myModal.hide();
				}else{
	    			modalVerCode.classList.add('is-invalid');
		    	}
			    	
			}
			
			document.getElementById('modalSetButton').addEventListener('click',modalSet);
			
	});
	</script>
	</html>
