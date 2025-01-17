package com.future.blue.common.vo;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeUtil {

    /**
     * 상대 시간 계산 메서드
     * 
     * @param dateTimeStr 날짜/시간 문자열 (형식: "yyyy-MM-dd HH:mm:ss")
     * @return 상대 시간 문자열 (예: "방금 전", "3분 전", "2시간 전", "1일 전")
     */
    public static String calculateRelativeTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.isEmpty()) {
            return "알 수 없음";
        }

        try {
            // 문자열을 LocalDateTime 객체로 변환
            LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            // 현재 시간과의 차이 계산
            Duration duration = Duration.between(dateTime, LocalDateTime.now());
            long seconds = duration.getSeconds();

            // 상대 시간 계산
            if (seconds < 60) {
                return "방금 전";
            } else if (seconds < 3600) {
                return (seconds / 60) + "분 전";
            } else if (seconds < 86400) {
                return (seconds / 3600) + "시간 전";
            } else {
                return (seconds / 86400) + "일 전";
            }
        } catch (Exception e) {
            // 파싱 실패 시 기본값 반환
            return "알 수 없음";
        }
    }
}
