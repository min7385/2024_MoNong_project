<%
  /* ================================================================= 
   * 작성일     : 2024. 12. 30. 
   * 작성자     : 한준희
   * 상세설명  : 농작물 이미지 등록시 뜨는 모달창
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
<style>
  :root {
    --primary-color: #005100;
    --text-color: #333333; /* 내용 텍스트 색상 */
  }

  .modal-content {
    border-radius: 10px;
    background-color: #ffffff; /* 흰색 배경 */
    border: 2px solid var(--primary-color);
  }

  .modal-header {
    background-color: var(--primary-color);
    color: white;
    border-bottom: 2px solid var(--primary-color);
    font-weight: bold;
    font-size: 1.2rem; /* 헤더 크기 축소 */
  }

  .modal-body p {
    color: var(--text-color);
    font-size: 14px;
    margin: 5px 0;
  }

  .modal-footer {
    border-top: 2px solid var(--primary-color);
  }

  .btn-secondary {
    background-color: var(--primary-color);
    border: none;
    color: white;
    border-radius: 5px;
  }

  .btn-secondary:hover {
    background-color: #003b00; /* 버튼 호버 시 어두운 초록색 */
  }
</style>

<!-- 농작물 정보 모달 -->
<div class="modal fade" id="cropInfoModal" tabindex="-1" aria-labelledby="cropInfoModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cropInfoModalLabel"><strong>농작물 정보</strong></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p><strong>농작물 종류:</strong> <span id="cropType"></span></p>
        <p><strong>농작물 품질:</strong> <span id="cropQuality"></span></p>
        <p><strong>농작물 가격:</strong> <span id="cropPrice"></span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>