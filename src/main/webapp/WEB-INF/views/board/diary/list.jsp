<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>작물 성장 일기 게시판</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
        .header {
			padding: 20px 0;
			text-align: center;
			background-color: #005100;
			color: white;
			margin-bottom: 20px;
		}

        .diary-container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* 제목 */
        .diary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .diary-header h1 {
            font-size: 24px;
            color: #005100;
        }

        .diary-header select, .diary-header button, .diary-header input {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .diary-header button {
            background-color: #005100;
            color: white;
            border: none;
            cursor: pointer;
        }

        .diary-header button:hover {
            background-color: #2558c2;
        }

        /* 게시판 그리드 */
        .diary-post-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .diary-post-item {
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
            transition: transform 0.3s;
        }

        .diary-post-item:hover {
            transform: scale(1.02);
        }

        .diary-post-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .diary-post-item .content {
            padding: 10px;
        }

        .diary-post-item h3 {
            font-size: 16px;
            margin: 10px 0;
            color: #333;
        }

        .diary-post-item p {
            font-size: 12px;
            color: #777;
        }

        /* 비밀글 자물쇠 표시 */
        .lock-icon {
            font-size: 20px;
            color: #f44336;
        }

        /* 더보기와 글쓰기 버튼 */
        .diary-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .diary-buttons button {
            padding: 10px 15px;
            font-size: 14px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .diary-buttons .more {
            background-color: #4CAF50;
        }

        .diary-buttons .write {
            background-color:#005100;
        }

        .diary-buttons button:hover {
            opacity: 0.9;
        }

        .diary-pagination {
            text-align: center;
            margin: 20px 0;
            font-size: 16px;
        }

        .diary-pagination a {
            display: inline-block;
            padding: 8px 16px;
            margin: 0 5px;
            text-decoration: none;
            color: #333;
            background-color: #f0f0f0;
            border-radius: 5px;
            border: 1px solid #ddd;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .diary-pagination a:hover {
            background-color: #4CAF50;
            color: white;
        }

        .diary-pagination .current {
            background-color: #005100;
            color: white;
            border-color: #005100;
        }

        .diary-pagination .ellipsis {
            padding: 8px 16px;
            color: #666;
            background-color: transparent;
            border: none;
        }

        @media (max-width: 768px) {
            .diary-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .diary-header input, .diary-header select, .diary-header button {
                width: 100%;
                margin-bottom: 10px;
            }
            .diary-buttons {
                flex-direction: column;
                gap: 10px;
            }
            .diary-buttons button {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>
	<div class="header">
		<h1>작물성장일기</h1>
		<div class="sub-header">작물을 직접 키우며 멋진 기록들을 남겨보세요!</div>
	</div>
    <div class="diary-container">
        <!-- 상단 제목과 검색/정렬 -->
        <div class="diary-header">
            <h1>작물 성장 일기 게시판</h1>
            <div>
                <form method="get" action="/diary/list">
                    <select name="sortBy">
                        <option value="new" ${sortBy == 'new' ? 'selected' : ''}>최신순</option>
                        <option value="old" ${sortBy == 'old' ? 'selected' : ''}>오래된순</option>
                    </select> 
                    <input type="text" name="search" placeholder="검색어를 입력하세요" value="${search}" />
                    <button type="submit" style="background-color:#005100;">검색</button>
                </form>
            </div>
        </div>

        <!-- 게시판 그리드 -->
        <div class="diary-post-grid">
            <!-- 게시물 리스트 출력 -->
            <c:forEach var="diary" items="${diaryList}">
                <div class="diary-post-item">
                    <!-- 대표 이미지 출력 -->
                    
                    <!-- diaryContents에서 첫 번째 이미지 URL 추출 -->
<c:set var="content" value="${diary.diaryContents}" />
<c:choose>
    <c:when test="${fn:contains(content, 'src=')}">
        <c:set var="firstImgUrl" value="${fn:substringBefore(fn:substringAfter(content, 'src=\"'), '\"')}" />
    </c:when>
    <c:otherwise>
        <c:set var="firstImgUrl" value="" />
    </c:otherwise>
</c:choose>

<!-- 추출된 URL이 있으면 사용, 없으면 대체 URL 사용 -->
<img src="${firstImgUrl != '' ? firstImgUrl : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKQUeq_yvvXPtm3HBvXyQ8i7CgF47xTNAeHg&s'}" alt="작물 이미지">
                    
                    
                    <div class="content">
                        <h3>
                            <a href="/diary/detail/${diary.diaryId}"> 
                                ${diary.diaryTitle != null && !diary.diaryTitle.isEmpty() ? diary.diaryTitle : '제목없음' }
                            </a>
                            <c:if test="${diary.useYn == 'N'}">
                                <span class="lock-icon">🔒</span>
                            </c:if>
                        </h3>
                        <p>${diary.diaryWriter != null && !diary.diaryWriter.isEmpty() ? diary.diaryWriter : '글쓴이 없음'} · ${diary.createDt != null ? diary.createDt : '날짜 없음'}</p>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 페이지네이션 -->
        <div class="diary-pagination">
            <!-- 이전 페이지 버튼 -->
            <c:if test="${currentPage > 1}">
                <a href="/diary/list?currentPage=${currentPage - 1}&sortBy=${sortBy}&search=${search}">◀ 이전</a>
            </c:if>

            <!-- 첫 번째 페이지 -->
            <c:if test="${currentPage > 3}">
                <a href="/diary/list?currentPage=1&sortBy=${sortBy}&search=${search}">1</a>
                <span class="ellipsis">...</span>
            </c:if>

            <!-- 중앙 페이지 버튼들 -->
            <c:forEach var="i" begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}" end="${currentPage + 2}" step="1">
                <c:if test="${i > 0 && i <= totalPages}">
                    <a href="/diary/list?currentPage=${i}&sortBy=${sortBy}&search=${search}" class="${i == currentPage ? 'current' : ''}">${i}</a>
                </c:if>
            </c:forEach>

            <!-- 마지막 페이지 -->
            <c:if test="${currentPage < totalPages - 2}">
                <span class="ellipsis">...</span>
                <a href="/diary/list?currentPage=${totalPages}&sortBy=${sortBy}&search=${search}">${totalPages}</a>
            </c:if>

            <!-- 다음 페이지 버튼 -->
            <c:if test="${currentPage < totalPages}">
                <a href="/diary/list?currentPage=${currentPage + 1}&sortBy=${sortBy}&search=${search}">다음 ▶</a>
            </c:if>
        </div>

        <!-- 글쓰기 버튼 (로그인 상태일 때만 보이도록 설정) -->
        <div class="diary-buttons">
            <button class="write" id="writeButton" style="display:none" onclick="location.href='/diary/create'">글쓰기</button>
        </div>
    </div>

<jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

<script>
    // 로그인 여부 확인 및 버튼 보이기/숨기기
    window.onload = function() {
        var cookies = document.cookie;
        if (cookies.indexOf("accessToken") !== -1) {
            document.getElementById('writeButton').style.display = 'block';  // 로그인 상태라면 글쓰기 버튼 보이기
        } else {
            document.getElementById('writeButton').style.display = 'none';   // 로그인 안 되어있으면 글쓰기 버튼 숨기기
        }
    }
</script>

</body>
</html>
