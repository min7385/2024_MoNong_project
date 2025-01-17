package com.future.blue.mypage.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.auth.service.AuthServiceImpl;
import com.future.blue.auth.util.JwtUtil;
import com.future.blue.common.util.MemberUtil;
import com.future.blue.mypage.service.IMypageService;
import com.future.blue.mypage.service.MypageServiceImpl;
import com.future.blue.mypage.vo.MypageChatVO;
import com.future.blue.mypage.vo.MypageReviewVO;
import com.future.blue.mypage.vo.MypageTradeVO;
import com.future.blue.mypage.vo.MypageVO;

@Controller
public class MypageController {
	
	@Autowired
	IMypageService mypageService;
	
	@GetMapping("/mypage/main")
	public String mypageMain(HttpServletRequest request, Model model) {
		String memId = MemberUtil.getMemIdFromCookie(request);
		List<MypageChatVO> chatVOList = mypageService.getChatData(memId);
		int totalChat = 0;
		int sellingChat = 0;
		int buyingChat = 0;
		for (int i = 0; i < chatVOList.size(); i++) {
			MypageChatVO chatVO = chatVOList.get(i);
			if (!chatVO.getMemId().equals(memId)) {
				totalChat += 1;
			} 
			if (chatVO.getChatSeller().equals(memId) && !chatVO.getMemId().equals(memId)) {
				sellingChat += 1;
			}else if (chatVO.getChatBuyer().equals(memId) && !chatVO.getMemId().equals(memId)) {
				buyingChat += 1;
			}
		}
		
		int sellingProd = 0;
		int requestProd = 0;
		int completeProd = 0;
		List<MypageTradeVO> tradeVOList = mypageService.getTradeData(memId);
		for (int i = 0; i < tradeVOList.size(); i++) {
			MypageTradeVO tradeVO = tradeVOList.get(i);
			if(tradeVO.getProdStatus().equals("S")) {
				sellingProd += 1;
			}else if(tradeVO.getProdStatus().equals("R")) {
				requestProd += 1;
			}else if(tradeVO.getProdStatus().equals("C")) {
				completeProd += 1;
			}
		}
		List<Integer> chatInfoList = Arrays.asList(totalChat, sellingChat, buyingChat, sellingProd, requestProd, completeProd);
		model.addAttribute("chatInfoList", chatInfoList);
		return "mypage/main";
	}
	
	@GetMapping("/mypage/info")
	public String mypageInfo() {
		return "mypage/info";
	}
	
	@GetMapping("/mypage/trade")
	public String mypageTrade(HttpServletRequest request, Model model) {
		String memId = MemberUtil.getMemIdFromCookie(request);
		List<MypageTradeVO> totalVO = mypageService.getTradeData(memId);
		List<MypageTradeVO> sellingVO = new ArrayList<>();
		List<MypageTradeVO> requestVO = new ArrayList<>();
		List<MypageTradeVO> completeVO = new ArrayList<>();
		for (int i = 0; i < totalVO.size(); i++) {
			MypageTradeVO tradeVO = totalVO.get(i);
			tradeVO.setRelativeTime();
			if(tradeVO.getProdStatus().equals("S")) {
				sellingVO.add(tradeVO);
			}else if(tradeVO.getProdStatus().equals("R")) {
				requestVO.add(tradeVO);
			}else if(tradeVO.getProdStatus().equals("C")) {
				completeVO.add(tradeVO);
			}
		}
		model.addAttribute("sellingVO", sellingVO);
		model.addAttribute("requestVO", requestVO);
		model.addAttribute("completeVO", completeVO);
		return "mypage/trade";
	}

	@GetMapping("/mypage/change")
	public String mypageChange() {
		return "mypage/change";
	}
	
	@PostMapping("/mypage/changeDo")
	public void mypageChangeDo(@RequestParam String memId, @RequestParam String memNic, @RequestParam String memAddr, @RequestParam String memPhone) {
		MypageVO vo = mypageService.getMyData(memId);
		vo.setMemNic(memNic);
		vo.setMemAddr(memAddr);
		vo.setMemPhone(memPhone);
		mypageService.changeInfo(vo);
	}
	
	@GetMapping("/mypage/chat")
	public String mypageChatView(HttpServletRequest request, Model model) {
		String memId = MemberUtil.getMemIdFromCookie(request);
		List<MypageChatVO> chatVOList = mypageService.getChatData(memId);
		List<MypageChatVO> totalChatList = new ArrayList<>();
		List<MypageChatVO> sellChatList = new ArrayList<>();
		List<MypageChatVO> buyChatList = new ArrayList<>();
		for (int i = 0; i < chatVOList.size(); i++) {
			MypageChatVO chatVO = chatVOList.get(i);
			chatVO.setRelativeTime();
			if (chatVO.getTmContentType().equals("APPOINTMENT")) {
				chatVO.setTmContent("약속을 신청했습니다.");
			}else if(chatVO.getTmContentType().equals("IMG")) {
				chatVO.setTmContent("사진을 보냈습니다.");
			}
			if (!chatVO.getMemId().equals(memId)) {
				totalChatList.add(chatVO);
			} 
			if (chatVO.getChatSeller().equals(memId) && !chatVO.getMemId().equals(memId)) {
				sellChatList.add(chatVO);
			}else if (chatVO.getChatBuyer().equals(memId) && !chatVO.getMemId().equals(memId)) {
				buyChatList.add(chatVO);
			}
		}
		model.addAttribute("totalChatList", totalChatList);
		model.addAttribute("sellChatList", sellChatList);
		model.addAttribute("buyChatList", buyChatList);
		return "mypage/chat";
	}
	
	@GetMapping("/mypage/review")
	public String mypageReviewView(HttpServletRequest request, Model model) {
		String memId = MemberUtil.getMemIdFromCookie(request);
		List<MypageReviewVO> reviewVOList = mypageService.getReviewData(memId);
		List<MypageReviewVO> totalReviewList = new ArrayList<>();
		List<MypageReviewVO> toMeReviewList = new ArrayList<>();
		List<MypageReviewVO> fromMeReviewList = new ArrayList<>();
		for (int i = 0; i < reviewVOList.size(); i++) {
			MypageReviewVO reviewVO = reviewVOList.get(i);
			reviewVO.setRelativeTime();
			totalReviewList.add(reviewVO);
			if(reviewVO.getRevTarget().equals(memId)){
				toMeReviewList.add(reviewVO);
			}else if(reviewVO.getRevWriter().equals(memId)){
				fromMeReviewList.add(reviewVO);
			}
		}
		model.addAttribute("totalReviewList", totalReviewList);
		model.addAttribute("toMeReviewList", toMeReviewList);
		model.addAttribute("fromMeReviewList", fromMeReviewList);
		return "mypage/review";
	}
}
