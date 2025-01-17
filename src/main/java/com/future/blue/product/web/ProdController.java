package com.future.blue.product.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.future.blue.auth.service.IAuthService;
import com.future.blue.auth.util.JwtUtil;
import com.future.blue.auth.vo.AuthVO;
import com.future.blue.product.service.ProductService;
import com.future.blue.product.vo.CropQualityVO;
import com.future.blue.product.vo.PhotoVO;
import com.future.blue.product.vo.ProductVO;

@Controller
public class ProdController {

	@Value("#{util['kakao.api.key']}")
	private String kakaoApiKey;

	@Autowired
	private ProductService prodService;

	@Autowired
	private IAuthService authService;

	@GetMapping("/sell/main")
	public String prodView(Model model) {

		model.addAttribute("kakaoApiKey", kakaoApiKey);
		return "sell/main";
	}

	/**
	 * 판매 등록 요청을 처리하는 컨트롤러 메서드입니다. 판매 정보와 업로드된 사진 파일을 처리하여 데이터베이스에 저장합니다.
	 * 
	 * @param prodVO             판매 정보를 담은 객체 (폼 입력값 매핑)
	 * @param photos             업로드된 사진 파일 배열
	 * @param redirectAttributes 리다이렉트 시 성공/오류 메시지를 전달하기 위한 객체
	 * @return 리다이렉트 URL
	 */
	@PostMapping("/sell/register")
	public String registerprod(@ModelAttribute ProductVO prodVO, // 폼의 텍스트 입력값을 매핑
			@RequestParam("imageUpload") MultipartFile[] photos, // 다중 파일 업로드 처리
			RedirectAttributes redirectAttributes, HttpServletRequest request) {

		String accessToken = JwtUtil.extractToken(request);
		String memId = JwtUtil.getMemIdFromToken(accessToken);
		AuthVO userInfo = authService.loadUserByMemId(memId);
		// 1. 회원 ID 설정 (로그인된 사용자 정보가 있다고 가정)
		prodVO.setProdSeller(userInfo.getMemId()); // 실제 구현에서는 세션에서 가져오도록 수정 필요!!
		try {
			// 2. 판매 정보와 사진 파일 저장
			// 서비스 계층에서 판매 정보와 사진 데이터를 처리 및 저장
			prodService.registerProdWithPhotos(prodVO, photos);

			// 3. 성공 메시지 설정
			// 판매 등록 성공 메시지를 리다이렉트 시 함께 전달
			redirectAttributes.addFlashAttribute("message", "판매 등록이 완료되었습니다!");
			return "redirect:/"; // 메인 페이지로 리다이렉트

		} catch (Exception e) {
			// 4. 오류 처리
			e.printStackTrace(); // 예외 로그 출력
			// 판매 등록 실패 메시지를 리다이렉트 시 함께 전달
			redirectAttributes.addFlashAttribute("error", "판매 등록 중 오류가 발생했습니다.");
			return "redirect:/sell/main"; // 등록 페이지로 리다이렉트
		}
	}

	/**
	 * 특정 상품의 상세 정보와 사진 데이터를 뷰로 전달합니다.
	 * 
	 * @param prodId 조회할 상품 ID
	 * @param model  뷰에 전달할 데이터 모델
	 * @return 상품 상세 페이지 뷰 이름
	 */
	@GetMapping("/product/detail")
	public String productDetail(@RequestParam("prodId") int prodId, Model model) {
		// 상품 상세 정보 가져오기
		ProductVO product = prodService.getProductDetails(prodId);

		// 상품 사진 목록 가져오기
		List<PhotoVO> photos = prodService.getProductPhotos(prodId);

		// 뷰로 전달할 데이터 추가
		model.addAttribute("kakaoApiKey", kakaoApiKey);
		model.addAttribute("product", product); // 상품 상세 정보
		model.addAttribute("photoList", photos); // 이미지 리스트

		return "purchase/detail"; // 상품 상세 페이지 뷰 이름
	}

	/**
	 * flask http://192.168.0.44:5001/predict 로 첫번째 상품이미지 전달 (양배추, 배추, 마늘, 감자, 겨율무
	 * 가능)
	 * 
	 * @param 첫번째 상품 이미지
	 * @return 해당 이미지의 상품 퀄리티 반환 (CROP_QUALITY_MAPPING) 테이블의 값과 매핑하여 필요한 값 전달(예 :
	 *         양배추 (특상))
	 */
	@PostMapping("/image/predict")
	@ResponseBody
	public Map<String, String> predictImage(@RequestParam("file") MultipartFile file) {
		// 결과를 저장할 Map 선언
		Map<String, String> result = new HashMap<>();

		try {
			// Flask 서버 URL
			String flaskUrl = "http://192.168.0.42:5001/predict";

			// RestTemplate 객체 생성 - REST API 호출을 위한 객체
			RestTemplate restTemplate = new RestTemplate();

			// HTTP 요청 헤더 설정 (멀티파트 데이터 전송)
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.MULTIPART_FORM_DATA);

			// HTTP 요청 본문 설정 (파일 데이터를 포함)
			MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
			body.add("file", new ByteArrayResource(file.getBytes()) { // 파일 데이터를 ByteArrayResource로 변환
				@Override
				public String getFilename() {
					// Flask 서버에 전송할 파일 이름
					return file.getOriginalFilename();
				}
			});

			// 요청 엔티티 생성 (헤더와 본문 포함)
			HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

			// Flask 서버로 요청 보내기
			ResponseEntity<Map> response = restTemplate.postForEntity(flaskUrl, requestEntity, Map.class);

			// Flask 서버 응답 확인 및 처리
			if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
				// Flask 서버에서 반환된 class 값을 가져오기
				String predictedClass = (String) response.getBody().get("class");

				// DB에서 매핑된 데이터를 가져오기
				CropQualityVO mapping = prodService.getCropMapping(predictedClass);

				if (mapping != null) {
					// 결과 맵에 DB에서 가져온 품목 정보를 추가
					result.put("cropNameGpt", mapping.getCropNameGpt());
					result.put("cropNameKr", mapping.getCropNameKr()); // 한글 품목명
					result.put("quality", mapping.getQuality()); // 품질 등급
					result.put("qualityDesc", mapping.getQualityDesc()); // 품질 설명
				} else {
					// DB에서 매핑된 데이터가 없을 경우 에러 메시지 추가
					result.put("error", "퀄리티를 확인할 수 없습니다. 수동으로 입력하세요.");
				}
			} else {
				// Flask 서버 응답이 비정상적일 경우 에러 메시지 추가
				result.put("error", "Flask 서버에서 예측 결과를 가져올 수 없습니다.");
			}
		} catch (Exception e) {
			// 예외 발생 시 스택 트레이스 출력 및 에러 메시지 추가
			e.printStackTrace();
			result.put("error", "예외 발생: " + e.getMessage());
		}

		// 결과 반환
		return result;
	}

}
