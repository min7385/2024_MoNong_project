package com.future.blue.crop.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.future.blue.crop.vo.CropVO;

@Mapper
public interface CropDAO {

    // 게시글 목록 조회
    public ArrayList<CropVO> getBoardList();
    
    // 게시글 상세 조회
    public CropVO getBoard(@Param("boardId") int boardId);
    
    // 게시글 작성 
    public int writeBoard(CropVO vo);
    
    // 게시글 수정
    public int updateBoard(CropVO board);
}
