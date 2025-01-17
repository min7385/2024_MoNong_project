package com.future.blue.mypage.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.future.blue.mypage.vo.MypageChatVO;
import com.future.blue.mypage.vo.MypageReviewVO;
import com.future.blue.mypage.vo.MypageTradeVO;
import com.future.blue.mypage.vo.MypageVO;
import com.future.blue.mypage.vo.PointVO;

public interface IMypageService {
	
	public MypageVO getMyData(String memId);

	public PointVO getMyPoint(String memId);
	
	public String profileUpload(MypageVO vo, String uploadDir, String webPath, MultipartFile file) throws Exception;
	
	public void changeInfo(MypageVO vo); 
	
	public List<MypageChatVO> getChatData(String memId);
	
	public List<MypageTradeVO> getTradeData(String memId);
	
	public List<MypageReviewVO> getReviewData(String memId);
}
