<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>   
<!-- 푸터 (모바일에서 5개의 메뉴를 아이콘으로 표시, 웹에서는 아이콘과 텍스트) -->
<!-- 웹 전용 푸터 -->
<footer class="container-fluid footer text-dark w-100">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-md-6 text-center text-md-start mb-md-0">
                <span><i class="fas fa-copyright me-2"></i>SunShine, All rights reserved.</span>
            </div>
            <div class="col-md-6 text-center text-md-end">
                This platform was developed by Junhee Han, Minho Kang, Yoona Kim, Jeongin Kim, Youngbeom Jeon, and Dohyeon Jeong.
            </div>
        </div>
    </div>
</footer>

<!-- 모바일 전용 푸터 -->
<div class="mobile-footer">
    <div class="icon-row">
        <a href="/" class="footer-icon-link" aria-label="홈">
            <span class="footer-icon-placeholder"><i class="fas fa-home"></i></span>
        </a>
        <a href="/mypage/chat" class="footer-icon-link" aria-label="채팅">
            <span class="footer-icon-placeholder"><i class="fas fa-comments"></i></span>
        </a>
       <a href="tips/status" class="footer-icon-link" aria-label="농작물 상태 확인">
            <span class="footer-icon-placeholder"><i class="fa fa-camera" aria-hidden="true"></i></span>
        </a>
       <a href="/market/priceMain" class="footer-icon-link" aria-label="시세 및 예측">
            <span class="footer-icon-placeholder"><i class="fa fa-line-chart" aria-hidden="true"></i></span>
        </a> 
        <a href="/mypage/main" class="footer-icon-link" aria-label="마이페이지">
            <span class="footer-icon-placeholder"><i class="fas fa-user"></i></span>
        </a>
    </div>
</div>

<!-- jQuery 라이브러리: DOM 조작, 이벤트 처리 등을 간편하게 하기 위해 사용 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- 팝오버는 Popper에 의존하고 있습니다. 팝오버를 동작시키기 위해서는 bootstrap.js 앞에 popper.min.js를 쓰거나 Popper를 포함한 bootstrap.bundle.min.js / bootstrap.bundle.js를 사용해야 합니다. -->
<!-- Bootstrap JavaScript: 부트스트랩의 컴포넌트 (모달, 캐러셀 등)를 사용하기 위해 필요 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
 integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
 crossorigin="anonymous"></script>

<!-- Summernote JS -->
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.js"></script>

<script>
    // 여기에 푸터 관련 스크립트 추가 (예: 푸터 메뉴 동작 등)
</script>

