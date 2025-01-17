package com.future.blue.purchase.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.purchase.dao.IChatDAO;
import com.future.blue.purchase.vo.ChatListVO;
import com.future.blue.purchase.vo.ChatVO;
import com.future.blue.purchase.vo.ReviewVO;
import com.future.blue.purchase.vo.RoomVO;

/**
 * 채팅 로직을 담당하는 Service 클래스
 * DAO를 통해 DB 액세스
 */
@Service
public class ChatService {

    @Autowired
    private IChatDAO dao;
    
    /**
     * 1) 기존에 동일한 판매자+구매자+상품 ID로 된 채팅방이 있는지 조회
     * @param room (chatSeller, chatBuyer, chatProdId)
     * @return chatId or null
     */
    public String checkChat(RoomVO room) {
        return dao.findChatRoom(room);
    }

    /**
     * 2) 기존 채팅방이 없으면 새 채팅방 생성 후 chatId 리턴
     * @param room
     * @return chatId
     */
    public String getOrCreateChatRoom(RoomVO room) {
        // 기존 채팅방 조회
        String chatId = checkChat(room);
        if (chatId == null) {
            // 채팅방이 없으면 생성
            dao.createRoom(room);
            // room.getChatId() 에 시퀀스 값이 세팅되었다고 가정
            chatId = room.getChatId();
        }
        return chatId;
    }

    /**
     * 일반 텍스트/이미지 메시지 DB 저장
     */
    public void insertChatContent(ChatVO vo) {
        dao.insertChat(vo);
    }

    /**
     * 이미지 파일 저장 + 경로 리턴 (예시)
     */
    public String insertChatImage(ChatVO vo, String uploadDir, String webPath, MultipartFile file) throws Exception {
        // 1) 원본 파일명
        String origin = file.getOriginalFilename();
        // 2) 유니크 파일명
        String unique = UUID.randomUUID().toString() + "_" + origin;
        // 3) DB에 저장할 경로
        String dbPath = webPath + unique;
        // 4) 서버 물리 경로에 파일 복사
        Path filePath = Paths.get(uploadDir, unique);
        try {
            Files.copy(file.getInputStream(), filePath);
        } catch (IOException e) {
            e.printStackTrace();
            throw new Exception("이미지 저장 실패");
        }
        return dbPath;
    }

    /**
     * 특정 채팅방의 대화 내용 조회
     * @param chatId
     */
    public ArrayList<ChatVO> getChatList(String chatId) {
        return dao.getChatList(chatId);
    }

    /**
     * 전체 채팅방 리스트 조회
     */
    public ArrayList<RoomVO> getRoomList() {
        return dao.getRoomList();
    }

    /**
     * 특정 채팅방 상세 정보 조회
     */
    public RoomVO getRoomDetails(String chatId) {
        return dao.getRoomDetails(chatId);
    }

    /**
     * 특정 상품(prodId)에 대한 채팅 리스트
     */
    public List<ChatListVO> getChatListByProductId(int prodId) {
        return dao.selectChatListByProductId(prodId);
    }

    // ========== 약속/거래 로직 ==========

    /**
     * (1) 약속 잡기 (REQUEST)
     */
    public void makeAppointment(RoomVO room, ChatVO chatVO) {
        // CHAT 테이블: tmMeetDate, tmMeetPlace, tmStatus='REQUEST'
        dao.updateChatAppointment(room);
        // TRADEMSG: APPOINTMENT 메시지 insert
        dao.insertAppointmentMessage(chatVO);
    }

    /**
     * (2) 약속 확인(R)
     */
    public void confirmAppointment(RoomVO room, ChatVO chatVO) {
        dao.confirmAppointment(room);
        dao.insertConfirmMessage(chatVO);
        
        String chatId = room.getChatId();
        dao.confirmProduct(chatId);
    }

    /**
     * (3) 거래 완료(C)
     */
    public void completeAppointment(RoomVO room, ChatVO chatVO) {
        dao.completeAppointment(room);
        dao.insertCompleteMessage(chatVO);
        
        String chatId = room.getChatId();
        dao.completeProduct(chatId);
    }

 // 후기 작성
    public void writeReview(ReviewVO reviewVO) throws Exception {
        // tmStatus='C' 인지 체크할 수도 있음
        // ...
        dao.insertReview(reviewVO);
    }

    // 특정 후기 조회 (상품ID + 작성자 or 대상자)
    public ReviewVO getReview(ReviewVO reviewVO) throws Exception {

        return dao.selectReview(reviewVO);
    }

    // ========== 기타 유틸(시간 계산 예시) ==========

    public String getTimeAgo(long chatTimeMillis) {
        long currentTime = System.currentTimeMillis();
        long diffMillis = currentTime - chatTimeMillis;

        long diffMinutes = diffMillis / (60 * 1000);   // 분
        long diffHours = diffMillis / (60 * 60 * 1000);// 시

        if (diffMinutes < 5) {
            return "방금 전";
        } else if (diffMinutes < 60) {
            return diffMinutes + "분 전";
        } else if (diffHours < 24) {
            return diffHours + "시간 전";
        } else {
            return "하루 이상";
        }
    }
}