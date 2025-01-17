package com.future.blue.mypage.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.auth.vo.AuthVO;
import com.future.blue.mypage.dao.IMypageDAO;
import com.future.blue.mypage.vo.MypageChatVO;
import com.future.blue.mypage.vo.MypageReviewVO;
import com.future.blue.mypage.vo.MypageTradeVO;
import com.future.blue.mypage.vo.MypageVO;
import com.future.blue.mypage.vo.PointVO;

@Service("IMypageService")
public class MypageServiceImpl implements IMypageService {

	@Autowired
	IMypageDAO dao;

	@Override
	public MypageVO getMyData(String memId) {
		return dao.getMyData(memId);
	}

	@Override
	public PointVO getMyPoint(String memId) {
		return dao.getMyPoint(memId);
	};

	@Override
	public String profileUpload(MypageVO vo, String uploadDir, String webPath, MultipartFile file) throws Exception {
		String origin = file.getOriginalFilename();
		String uniqe = UUID.randomUUID().toString() + "_" + origin;
		String dbPath = webPath + uniqe;
		Path filePath = Paths.get(uploadDir, uniqe);
		try {
			Files.copy(file.getInputStream(), filePath);
		} catch (IOException e) {
			throw new Exception("fail to save the file", e);
		}
		vo.setMemProfile(dbPath);
		int result = dao.profileUpload(vo);
		if (result == 0) {
			throw new Exception();
		}
		return dbPath;
	}

	@Override
	public void changeInfo(MypageVO vo) {
		dao.changeInfo(vo);
	};
	
	@Override
	public List<MypageChatVO> getChatData(String memId) {
		return dao.getChatData(memId);
	};
	
	@Override
	public List<MypageTradeVO> getTradeData(String memId){
		return dao.getTradeData(memId);
	};
	
	@Override
	public List<MypageReviewVO> getReviewData(String memId){
		return dao.getReviewData(memId);
	};
}
