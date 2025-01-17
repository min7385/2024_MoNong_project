package com.future.blue.market.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.repository.query.Param;

import com.future.blue.market.vo.MarketVO;


@Mapper
public interface IMarketDAO {
	
	public List<MarketVO> selectCode();
	public List<MarketVO> selectNm(MarketVO marketvo);
	public List<MarketVO> searchProduct(MarketVO marketvo);
	public List<MarketVO> searchProductWeek(MarketVO marketvo);
	public List<MarketVO> searchProduct2(MarketVO marketvo);
	
	// 예측 가격을 조회하는 메서드 추가
    public List<MarketVO> PredictedProduct(MarketVO marketvo);
	
}