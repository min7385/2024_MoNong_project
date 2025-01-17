package com.future.blue.crop.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.future.blue.crop.vo.CropVO;
import com.future.blue.crop.dao.CropDAO;

	@Service
	public class CropService {
		@Autowired
		CropDAO dao;
	
		public ArrayList<CropVO> getBoardList() {
			return dao.getBoardList();
		}
	
		public CropVO getBoard(int boardId) throws Exception {
		    CropVO result = dao.getBoard(boardId); // DAO에서 게시글 조회
		    if (result == null) {
		        throw new Exception("게시글을 찾을 수 없습니다."); // 게시글 없을 경우 예외 발생
		    }
		    return result;
		}

	
		public void writeBoard(CropVO vo) throws Exception {
			int result = dao.writeBoard(vo);
			if (result == 0) {
				throw new Exception();
			}
		}
	
		public void updateBoard(CropVO board) throws Exception {
			int result = dao.updateBoard(board);
			if (result == 0) {
				throw new Exception();
			}
		}
	}