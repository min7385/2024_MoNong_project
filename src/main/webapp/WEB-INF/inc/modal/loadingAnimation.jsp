<%
  /* ================================================================= 
   * 작성일     : 2025. 1. 6. 
   * 작성자     : 한준희
   * 상세설명  : 농작물 상태 분석 로딩 애니메이션
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
    .image-preview {
        position: relative;
        width: 300px;
        height: 300px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
        margin: 0 auto; /* 중앙 정렬 */
    }

    .image-preview img {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: cover; /* 이미지가 컨테이너에 꽉 차게 설정 */
    }

    .scan-line {
        position: absolute;
        width: 100%;
        height: 8px;
        background: linear-gradient(90deg, rgba(0, 174, 255, 0) 0%, rgba(0, 174, 255, 1) 50%, rgba(0, 174, 255, 0) 100%);
        box-shadow: 0 0 20px 5px rgba(0, 174, 255, 0.8);
        z-index: 2;
    }

    .scan-line-1 {
        top: -10%;
        animation: scan1 3s ease-in-out infinite;
    }

    .scan-line-2 {
        top: 110%;
        animation: scan2 3s ease-in-out infinite;
    }

    @keyframes scan1 {
        0% {
            top: -10%;
        }
        50% {
            top: 50%;
        }
        100% {
            top: 110%;
        }
    }

    @keyframes scan2 {
        0% {
            top: 110%;
        }
        50% {
            top: 50%;
        }
        100% {
            top: -10%;
        }
    }
</style>

<div class="image-preview">
    <img id="resultImage" src="https://via.placeholder.com/300" alt="분석 이미지">
    <div class="scan-line scan-line-1"></div>
    <div class="scan-line scan-line-2"></div>
</div>