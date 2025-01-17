package com.future.blue.tips.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.future.blue.tips.vo.TipsVO;

@Mapper
public interface ITipsDAO {
	
    // 페이지 네이션을 고려한 데이터 조회
    List<TipsVO> findSurveyData(Map<String, Object> params);

    // 전체 데이터 개수 조회
    int countSurveyData(TipsVO tipsVO);

    TipsVO findTipsById(int id);
}
