<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- CSS 추가 라인-->
<!-- bootstrap 스타일링크 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<!-- 기본 스타일 설정, 폰트 설정, 모바일 크기 설정 등 커스텀 스타일 정의해 놓은 곳  -->
<link rel="stylesheet" href="/css/custom.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    .tip {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 20px;
        margin-top: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
    }

    .tip h3 {
        margin-top: 0;
        font-size: 18px;
        color: #333;
    }

    .tip img {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
        margin-top: 15px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .tip-footer {
        font-size: 14px;
        color: #888;
        margin-top: 10px;
    }

    .tip-footer a {
        color: #4CAF50;
        text-decoration: none;
        font-weight: bold;
    }

    .tip-footer a:hover {
        text-decoration: underline;
    }
</style>

<div class="tip">
    <h3>전남 겨울배추 생육기 상황</h3>
    <p>장원호 (2023년 11월 27일)</p>
    <img src="https://i.namu.wiki/i/NwW-aPY09MfK-UwVy8j4_xf9lcGwRJ99JovHxjSBPy-gmflhyLCyMOkkZdq2LIwe0WKHtgJTkK6ClOE6U1CSuA.webp"
        alt="겨울배추 사진 1">
    <div class="tip-footer">
        <a href="#">자세히보기</a> | <span>2023년 11월 27일</span>
    </div>
</div>