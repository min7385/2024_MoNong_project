<!-- 게시글 목록 --> 

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>자유게시판 리스트</title>
		
	<!-- CSS -->
	<style>
    /* 자유게시판 전용 헤더 */

    .header {
	   padding: 20px 0;
	   text-align: center;
	   background-color: #005100;
	   color: white;
	   margin-bottom: 20px;
}

    /* 자유게시판 기본 스타일 */
    .board-body {
        margin: 0;
        padding: 0;
        background-color: #f9f9f9;
        color: #333;
    }

    /* 검색 영역 */
    .board-search-container {
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #005100;
        color: white;
    }

    .board-search-container input,
    .board-search-container button {
        padding: 8px;
        margin: 5px;
        border: none;
        border-radius: 5px;
    }

    .board-search-container input {
        flex: 1;
        max-width: 300px;
    }

    .board-search-container button {
        background-color: white;
        color: #005100;
        cursor: pointer;
        font-weight: bold;
    }

    .board-search-container button:hover {
        background-color: #ddd;
    }

    /* 게시판 테이블 */
    .board-table {
        width: 90%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: white;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .board-table th, .board-table td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: center;
    }

    .board-table th {
        background-color: #f4f4f4;
        font-weight: bold;
    }

    .board-table td:nth-child(2) {
        text-align: left;
    }

    /* 페이지네이션 */
    .board-pagination {
        display: flex;
        justify-content: center;
        margin: 20px 0;
    }

    .board-pagination button {
        padding: 5px 10px;
        margin: 0 5px;
        border: none;
        background-color: #005100;
        color: white;
        cursor: pointer;
        border-radius: 5px;
    }

    .board-pagination button:hover {
        background-color: #45a049;
    }

    /* 반응형 스타일 */
    @media (max-width: 768px) {
        .board-table, .board-table th, .board-table td {
            font-size: 12px;
        }
        .board-search-container {
            flex-direction: column;
        }
        .board-search-container input {
            width: 100%;
            margin-bottom: 5px;
        }
    }

    @media (max-width: 480px) {
        .board-table, .board-table th, .board-table td {
            font-size: 10px;
            padding: 5px;
        }
    }

    /* 글쓰기 버튼 */
    .write-button {
        position: fixed;
        bottom: 20px;
        right: 20px;
        padding: 10px 20px;
        background-color: #005100;
        color: white;
        font-weight: bold;
        text-decoration: none;
        border-radius: 50px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: background-color 0.3s ease;
    }

    .write-button:hover {
        background-color: #45a049;
    }
    </style>
</head>
<body class="board-body">
    <jsp:include page="/WEB-INF/inc/common/header.jsp"></jsp:include>

    <!-- 헤더 -->
    <header class="header">
        <h1>자유게시판</h1>
    </header>

    <!-- 검색 영역 -->
    <div class="board-search-container">
        <form name="search" action="<c:url value='/board/list' />" method="post">
            <input type="hidden" name="curPage" id="curPage" value="${searchVO.curPage}">
            <input type="hidden" name="rowSizePerPage" value="${searchVO.rowSizePerPage}">
            <input type="text" id="title" name="title" value="${searchVO.title}" placeholder="제목">
            <input type="text" id="contents" name="contents" value="${searchVO.contents}" placeholder="내용">
            <button type="submit" id="searchBtn">검색</button>
            <button type="reset" id="resetBtn">초기화</button>
        </form>
    </div>

    <!-- 게시판 테이블 -->
    <table class="board-table">
        <thead>
            <tr>
                <th>No.</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일자</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody id="boardContent">
            <c:choose>
                <c:when test="${not empty boardList}">
                    <c:forEach items="${boardList}" var="board">
                        <tr>
                            <td>${board.boardId}</td>
                            <td><a href="<c:url value='/board/detail?boardId=${board.boardId}' />">${board.boardTitle}</a></td>
                            <td>${board.boardWriter}</td>
                            <td>${board.createDt}</td>
                            <td>${board.boardHit}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" style="text-align: center;">게시물이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="board-pagination" id="pagination">
        <c:if test="${searchVO.firstPage != 1}">
            <button data-page="${searchVO.firstPage - 1}">&laquo;</button>
        </c:if>
        <c:forEach begin="${searchVO.firstPage}" end="${searchVO.lastPage}" var="i">
            <c:if test="${searchVO.curPage != i}">
                <button data-page="${i}">${i}</button>
            </c:if>
            <c:if test="${searchVO.curPage == i}">
                <button data-page="${i}">${i}</button>
            </c:if>
        </c:forEach>
        <c:if test="${searchVO.lastPage != searchVO.totalPageCount}">
            <button data-page="${searchVO.lastPage + 1}">&raquo;</button>
        </c:if>
    </div>

    <!-- 글쓰기 버튼 -->
    <a href="<c:url value='/board/create' />" class="write-button">글쓰기</a>

    <jsp:include page="/WEB-INF/inc/common/footer.jsp"></jsp:include>

    <!-- 페이지네이션 동작 스크립트 -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll(".board-pagination button[data-page]").forEach(function(button) {
                button.addEventListener("click", function(e) {
                    e.preventDefault();
                    document.getElementById("curPage").value = this.getAttribute("data-page");
                    document.forms["search"].submit();
                });
            });
        });
    </script>
    
    <!-- 좋아요 수 표시 -->
	<div class="like-section" data-board-id="${board.boardId}">
    	<span class="like-count">${board.likeCount}</span> Likes
	</div>

	<!-- 좋아요 수 실시간 갱신 JS -->
	<script>
    	$(function () {
        	$('.like-section').each(function () {
            	const $likeSection = $(this);
            	const boardId = $likeSection.data('board-id');

            // 좋아요 수 조회 AJAX
            $.ajax({
                url: `/like/count/${boardId}`,
                type: 'GET',
                success: function (likeCount) {
                    $likeSection.find('.like-count').text(likeCount);
                },
                error: function () {
                    console.error('좋아요 수를 가져오는 중 오류 발생');
                	}
            	});
        	});
    	});
	</script>
</body>
</html>