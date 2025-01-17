package com.future.blue.tips.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.future.blue.tips.service.TipsService;
import com.future.blue.tips.vo.TipsVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TipsController {

    @Autowired
    private TipsService tipsService;

    @GetMapping("/tips")
    public String tips() {
        return "tips/main";
    }
    
    // 상세 페이지 매핑 수정
    @GetMapping("/tips/detail/{id}")
    public String detail(@PathVariable("id") int id, Model model) {
        // 특정 id로 데이터 조회
        TipsVO tipsVO = tipsService.findTipsById(id);
        System.out.println(tipsVO);
        if (tipsVO != null) {
            // 모델에 데이터 추가
            model.addAttribute("tip", tipsVO);
            return "tips/detail"; // JSP 뷰 이름
        } else {
            // 데이터가 없을 경우 404 페이지 또는 에러 페이지로 이동
            return "error/404"; // 404 에러 페이지 JSP
        }
    }

    @GetMapping("/tips/search")
    @ResponseBody
    public Map<String, Object> searchSurveyData(
            @RequestParam(value = "region", defaultValue = "전체") String region,
            @RequestParam(value = "kind", defaultValue = "고추") String kind,
            @RequestParam(value = "page", defaultValue = "1") int page,  // 페이지 번호 (기본값 1)
            @RequestParam(value = "size", defaultValue = "3") int size   // 한 페이지에 표시할 데이터 개수 (기본값 3)
    ) {
        TipsVO tipsVO = new TipsVO();
        tipsVO.setSurveyRegion(region);  // 지역을 surveyRegion에 설정
        tipsVO.setKind(kind);  // 농작물 종류 설정
        
        // 페이지 네이션 계산
        int offset = (page - 1) * size;  // 페이지 시작 위치

        // 데이터 조회 (페이지 네이션 포함)
        List<TipsVO> tipsData = tipsService.findSurveyData(tipsVO, offset, size);
        
        // 총 데이터 개수 계산
        int totalCount = tipsService.countSurveyData(tipsVO);

        // 응답할 데이터
        Map<String, Object> response = new HashMap<>();
        response.put("data", tipsData);
        response.put("totalCount", totalCount);
        response.put("totalPages", (int) Math.ceil((double) totalCount / size));  // 총 페이지 수 계산
        return response;
    }
    
    @RequestMapping("/tips/status")
    public String checkStatus() {
    	return "tips/checkStatus";
    }
}
