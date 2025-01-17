package com.future.blue;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.future.blue.auth.service.IAuthService;
import com.future.blue.product.service.ProductService;
import com.future.blue.product.vo.ProductVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
    private ProductService prodService;
	
	@Autowired
	IAuthService authService;
	
	@Autowired
	private RedisTemplate<String, String> redisTemplate;
	
	//private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
//	@RequestMapping(value = "/", method = RequestMethod.GET)
//	public String home(Locale locale, Model model) {
//		logger.info("Welcome home! The client locale is {}.", locale);
//		
//		Date date = new Date();
//		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
//		
//		String formattedDate = dateFormat.format(date);
//		
//		model.addAttribute("serverTime", formattedDate );
//		
//		return "home";
//	}
	
	@Value("#{util['vapid.publicKey']}")
	private String publicKey;
	
	@GetMapping("/")
	public String products(
	    @RequestParam(value = "query", required = false) String query,
	    @RequestParam(value = "latitude", required = false, defaultValue = "36.35212915") double latitude,
	    @RequestParam(value = "longitude", required = false, defaultValue = "127.37818526") double longitude,
	    Model model) {
	    // 처음 20개의 상품 목록 조회 (Haversine 공식을 사용하여 거리순 정렬)
	    List<ProductVO> productList = prodService.getProductsByDistance(query, 0, 8, latitude, longitude);
	    model.addAttribute("productList", productList); // 상품 목록 전달
	    model.addAttribute("query", query); // 검색 키워드 전달
	    model.addAttribute("vapidPublicKey", publicKey); // VAPID 키 전달
	    
	    
	    
	    return "home"; // 메인페이지
	}

	@GetMapping("/distance")
	@ResponseBody
	public List<ProductVO> loadProductsByDistance(
	    @RequestParam(value = "query", required = false) String query,
	    @RequestParam(value = "latitude") double latitude,
	    @RequestParam(value = "longitude") double longitude,
	    @RequestParam("offset") int offset) {

	    // 거리순으로 상품 목록 조회
	    return prodService.getProductsByDistance(query, offset, 4, latitude, longitude);
	}

	/**
	 * 더보기 AJAX 요청 처리 (추가 상품 목록을 조회하여 반환)
	 * @param query (선택) 검색 키워드
	 * @param latitude 현재 위치 위도
	 * @param longitude 현재 위치 경도
	 * @param offset 추가로 조회를 시작할 위치
	 * @return JSON 형식으로 추가된 상품 목록 반환
	 */
	@GetMapping("/more")
	@ResponseBody
	public List<ProductVO> loadMoreProducts(
	    @RequestParam(value = "query", required = false) String query,
	    @RequestParam(value = "latitude", required = true) double latitude,
	    @RequestParam(value = "longitude", required = true) double longitude,
	    @RequestParam("offset") int offset) {

	    // offset부터 4개의 상품 목록 조회 (거리순 정렬)
	    return prodService.getProductsByDistance(query, offset, 4, latitude, longitude);
	}
	
}
