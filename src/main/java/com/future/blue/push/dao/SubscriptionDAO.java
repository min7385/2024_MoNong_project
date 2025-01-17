package com.future.blue.push.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.future.blue.purchase.vo.ChatVO;
import com.future.blue.push.vo.SubscriptionVO;

import nl.martijndwars.webpush.Subscription;

@Mapper
public interface SubscriptionDAO {
	
	// 구독 추가
    public void insertSubscription(SubscriptionVO subscription);
    // 방장이 고객에게 
    public List<SubscriptionVO> sendToBuyer(ChatVO vo);
    // 고객이 방장에게 
    public List<SubscriptionVO> sendToSeller(ChatVO vo);
    // 특정 사용자 구독 조회
    public List<SubscriptionVO> getSubscriptionByUserId(String userId);

    // 모든 구독 조회
    public List<SubscriptionVO> getAllSubscriptions();

    // 구독 제거
    public void deleteSubscription(@Param("userId") String userId);

}
