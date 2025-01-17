package com.future.blue.purchase.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.future.blue.purchase.vo.ChatListVO;
import com.future.blue.purchase.vo.ChatVO;
import com.future.blue.purchase.vo.ReviewVO;
import com.future.blue.purchase.vo.RoomVO;

@Mapper
public interface IChatDAO {
	 // ---------- 채팅방 관련 ----------

    /**
     * 전체 채팅방 리스트 조회
     * @return ArrayList<RoomVO>
     */
    public ArrayList<RoomVO> getRoomList();

    /**
     * 기존에 같은 조건(판매자, 구매자, 상품ID) 채팅방이 있는지 조회
     * @param room (chatSeller, chatBuyer, chatProdId)
     * @return chatId (문자열) 또는 null
     */
    public String findChatRoom(RoomVO room);

    /**
     * 채팅방 생성 (시퀀스 SEQ_CHAT_NO.NEXTVAL 사용)
     * @param roomVO (chatId, chatSeller, chatBuyer, chatProdId)
     * @return int (insert 결과)
     */
    public int createRoom(RoomVO roomVO);

    /**
     * 특정 채팅방 상세 정보 조회
     * (상품명, 판매자, TM_STATUS, TM_MEET_DATE 등 포함)
     * @param chatId
     * @return RoomVO
     */
    public RoomVO getRoomDetails(String chatId);

    // ---------- 메시지(TRADEMSG) 관련 ----------

    /**
     * 특정 채팅방의 대화 기록 조회
     * @param chatId
     * @return ArrayList<ChatVO>
     */
    public ArrayList<ChatVO> getChatList(String chatId);

    /**
     * 일반 텍스트/이미지 메시지 insert
     * (insertChat 라는 이름)
     */
    public int insertChat(ChatVO vo);

    // ---------- 약속/거래 관련 ----------

    /**
     * (1) 약속잡기: CHAT 테이블 갱신 + TRADEMSG insert
     */
    public int updateChatAppointment(RoomVO room);       // CHAT (tmStatus='REQUEST')
    public int insertAppointmentMessage(ChatVO chatVO);  // TRADEMSG (tmContentType='APPOINTMENT')

    /**
     * (2) 약속 확인: tmStatus='R'
     */
    public int confirmAppointment(RoomVO room);
    public int insertConfirmMessage(ChatVO chatVO);      // "약속 확인되었습니다."
    public void confirmProduct(String chatId);
    /**
     * (3) 거래 완료: tmStatus='C'
     */
    public int completeAppointment(RoomVO room);
    public int insertCompleteMessage(ChatVO chatVO);     // "거래 완료!"
    public void completeProduct(String chatId);

    // ---------- 후기 ----------

    /**
     * 후기 작성
     */
    public int insertReview(ReviewVO reviewVO);
    
    /**
     * 후기 조회
     */
    public ReviewVO selectReview(ReviewVO reviewVO);

    // ---------- 기타 기능 ----------

    /**
     * 특정 상품 ID에 대한 채팅 리스트 조회
     * (ChatListVO에는 마지막 메시지, 구매자, 판매자 등 정보 포함)
     */
    public List<ChatListVO> selectChatListByProductId(int prodId);
}

