package com.example.demoauth.dto;

import lombok.Data;

@Data
public class TokenResponseDto {
    private String accessToken;//jwt token
    private String refreshToken;//refresh token
    private String tokenType;//Bearer
}
