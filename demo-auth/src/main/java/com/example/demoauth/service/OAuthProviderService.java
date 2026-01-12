package com.example.demoauth.service;

import com.example.demoauth.dto.LoginProviderRequestDto;
import com.example.demoauth.dto.TokenResponseDto;

/**
 * Strategy cho từng provider cụ thể (google, facebook, ...).
 */
public interface OAuthProviderService {

    /**
     * Tên provider mà implementation này xử lý, ví dụ: "google", "facebook".
     */
    String getProviderName();

    /**
     * Xử lý login cho provider tương ứng và trả về TokenResponseDto.
     */
    TokenResponseDto login(LoginProviderRequestDto request);
}


