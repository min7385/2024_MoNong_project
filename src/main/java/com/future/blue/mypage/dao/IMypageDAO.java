package com.future.blue.mypage.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.mypage.vo.MypageChatVO;
import com.future.blue.mypage.vo.MypageReviewVO;
import com.future.blue.mypage.vo.MypageTradeVO;
import com.future.blue.mypage.vo.MypageVO;
import com.future.blue.mypage.vo.PointVO;


@Mapper
public interface IMypageDAO {
	
	public MypageVO getMyData(String memId);
	
	public PointVO getMyPoint(String memId);
	
	public int profileUpload(MypageVO vo);
	
	public void changeInfo(MypageVO vo);
	
	public List<MypageChatVO> getChatData(String memId);
	
	public List<MypageTradeVO> getTradeData(String memId);
	
	public List<MypageReviewVO> getReviewData(String memId);
}
