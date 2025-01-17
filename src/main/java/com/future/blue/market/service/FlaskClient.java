package com.future.blue.market.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class FlaskClient {

    private final String FLASK_URL = "http://127.0.0.1:5000/predict"; // Flask 서버 URL

    public String getPrediction(Map<String, Object> requestData) {
        RestTemplate restTemplate = new RestTemplate();
        // REST API 호출 (POST)
        String response = restTemplate.postForObject(FLASK_URL, requestData, String.class);
        return response;
    }
}
