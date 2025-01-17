package com.future.blue.market.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.future.blue.market.dao.IMarketDAO;
import com.future.blue.market.vo.MarketVO;

@Service
public class MarketService {
	
	@Autowired
	private IMarketDAO MarketDAO;
	
	public List<MarketVO> selectCode(){
		return MarketDAO.selectCode();
	}
	
	public List<MarketVO> selectNm(MarketVO marketvo){
		return MarketDAO.selectNm(marketvo);
	}
	
    public List<MarketVO> searchProduct(MarketVO marketvo) {
//        return MarketDAO.searchProduct(marketvo);
        return MarketDAO.searchProductWeek(marketvo); //5주
    }
    
    public List<MarketVO> searchProduct2(MarketVO marketvo) {
        return MarketDAO.searchProduct2(marketvo);
    }
    
    // 예측 가격을 계산하는 메서드
    public List<MarketVO> predictPrice(MarketVO marketvo) {
        return MarketDAO.PredictedProduct(marketvo);
    }

}