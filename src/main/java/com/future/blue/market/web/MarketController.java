package com.future.blue.market.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.future.blue.market.service.MarketService;
import com.future.blue.market.vo.MarketVO;

@Controller
public class MarketController{
	
	@Autowired
	private MarketService marketService;
	
	// 시세 확인 페이지
	@RequestMapping("/market/priceMain")
	public String priceMain(Model model) {
		
		List<MarketVO> marketList = marketService.selectCode();
		model.addAttribute("marketList", marketList);

		return "market/main_kmh";
	}
	
	@ResponseBody
	@PostMapping("/market/priceMain")
	public List<MarketVO> priceMain(MarketVO marketVO) {
		
		List<MarketVO> marketList = marketService.selectNm(marketVO);

		return marketList;
	}
	
    @ResponseBody
    @PostMapping("/market/searchProduct")
    public List<MarketVO> searchProduct(MarketVO marketvo) {
        return marketService.searchProduct(marketvo);
    }
    
    // 예측 가격을 처리하는 메서드
    @RequestMapping(value = "/market/predictPrice", method = RequestMethod.POST)
    @ResponseBody
    public List<MarketVO> predictPrice(MarketVO marketvo) {
        return marketService.predictPrice(marketvo);
    }
}