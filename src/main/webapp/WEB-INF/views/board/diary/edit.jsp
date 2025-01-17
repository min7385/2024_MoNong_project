<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>농사 팁 게시판</title>

<!-- Summernote CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css"
	rel="stylesheet">

<!-- jQuery와 Summernote JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>

<link rel="stylesheet" href="/css/diary_create.css">

</head>
<body>
	<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

	<div class="unique-wrapper">

		<div class="unique-content">
			<h2>게시글 수정</h2>

			<!-- 제목 입력란 -->
			<div class="unique-input-container">
				<label for="unique-postTitle">제목</label> <input type="text"
					id="unique-postTitle" value="${diary.diaryTitle}"
					placeholder="게시글 제목을 입력하세요" />
			</div>

			<!-- Summernote 에디터 -->
			<textarea id="summernote">${diary.diaryContents}</textarea>

			<!-- 버튼들 -->
			<button class="unique-cancel-button" onclick="uniqueCancelEdit()">취소</button>
			<button class="unique-write-button" onclick="uniqueSavePost()">수정
				완료</button>
		</div>
	</div>

	<script>
		var uniqueLastUploadedImageUrl = ''; // 마지막 업로드된 이미지 URL을 저장할 변수

		$(document)
				.ready(
						function() {
							// Summernote 초기화
							$('#summernote')
									.summernote(
											{
												height : 500, // 에디터 높이 설정
												placeholder : '여기에 글을 작성해주세요...',
												toolbar : [
														[
																'style',
																[
																		'bold',
																		'italic',
																		'underline',
																		'clear' ] ],
														[
																'font',
																[
																		'strikethrough',
																		'superscript',
																		'subscript' ] ],
														[ 'color', [ 'color' ] ],
														[
																'para',
																[ 'ul', 'ol',
																		'paragraph' ] ],
														[
																'insert',
																[ 'link',
																		'picture' ] ] // 이미지 삽입 기능
												],
												callbacks : {
													onImageUpload : function(
															files) {
														var formData = new FormData();
														var file = files[0];
														formData.append("file",
																file);

														var fileName = file.name;
														var headers = {
															"file-name" : fileName
														};

														// 이미지 업로드 요청
														$
																.ajax({
																	url : '/files/upload', // 서버 이미지 업로드 처리 URL
																	type : 'POST',
																	data : formData,
																	processData : false,
																	contentType : false,
																	headers : headers,
																	success : function(
																			response) {
																		var imgUrl = response.imagePath;
																		if (imgUrl) {
																			var imgTag = '<img src="' + imgUrl + '" alt="Uploaded Image" />';
																			$(
																					'#summernote')
																					.summernote(
																							'insertNode',
																							$(imgTag)[0]);
																			uniqueLastUploadedImageUrl = imgUrl;
																		}
																	},
																	error : function(
																			xhr,
																			status,
																			error) {
																		console
																				.log(
																						'이미지 업로드 실패:',
																						error);
																	}
																});
													}
												}
											});

							// 기존 게시글 내용 불러오기
							$('#summernote').summernote('code',
									'${diary.diaryContents}');
						});

		// 수정 완료 후 저장하는 함수
		function uniqueSavePost() {
			var title = $('#unique-postTitle').val();
			var content = $('#summernote').val();

			var postData = {
				diaryId : '${diary.diaryId}', // 다이어리 ID
				diaryTitle : title,
				diaryContents : content,
				diaryImage : uniqueLastUploadedImageUrl
			// 마지막 업로드된 이미지 URL
			};

			$.ajax({
				url : '/diary/update', // 실제 API 엔드포인트로 수정 필요
				type : 'POST',
				data : postData,
				success : function(response) {
					console.log('게시글 수정 성공:', response);
					window.location.href = '/diary/detail/'
							+ '${diary.diaryId}'; // 수정된 게시글 상세 페이지로 이동
				},
				error : function(error) {
					console.log('게시글 수정 실패:', error);
				}
			});
		}

		// 취소 버튼 클릭 시 상세 페이지로 이동
		function uniqueCancelEdit() {
			window.location.href = '/diary/detail/${diary.diaryId}'; // 취소 시 상세 페이지로 돌아가기
		}
	</script>

	<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>
</body>
</html>
