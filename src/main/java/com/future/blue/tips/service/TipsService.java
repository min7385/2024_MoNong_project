package com.future.blue.tips.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.future.blue.tips.dao.ITipsDAO;
import com.future.blue.tips.vo.TipsVO;

@Service
public class TipsService {

    @Autowired
    private ITipsDAO tipsDAO;

    // 데이터 조회 (페이지네이션 적용)
    public List<TipsVO> findSurveyData(TipsVO tipsVO, int offset, int size) {
        Map<String, Object> params = new HashMap<>();
        params.put("tipsVO", tipsVO);  // TipsVO를 Map에 추가
        params.put("offset", offset);  // offset을 Map에 추가
        params.put("size", size);      // size를 Map에 추가
        
        return tipsDAO.findSurveyData(params); // 페이지 네이션에 맞는 쿼리 호출
    }

    // 전체 데이터 개수 조회
    public int countSurveyData(TipsVO tipsVO) {
        return tipsDAO.countSurveyData(tipsVO); // 전체 데이터 개수 조회
    }

    public TipsVO findTipsById(int id) {
        return tipsDAO.findTipsById(id);
    }
}