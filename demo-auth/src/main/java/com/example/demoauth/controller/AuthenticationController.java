package com.example.demoauth.controller;

import com.example.demoauth.dto.LoginLocalRequestDto;
import com.example.demoauth.dto.LoginProviderRequestDto;
import com.example.demoauth.dto.RefreshTokenRequestDto;
import com.example.demoauth.dto.RegisterLocalRequestDto;
import com.example.demoauth.dto.TokenResponseDto;
import com.example.demoauth.shared.web.ApiResponse;
import com.example.demoauth.service.AuthenticationService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    private final AuthenticationService authenticationService;

    public AuthenticationController(AuthenticationService authenticationService) {
        this.authenticationService = authenticationService;
    }

    @PostMapping("/login/provider/{provider}")
    public ApiResponse<TokenResponseDto> loginProvider(
            @PathVariable String provider,
            @Valid @RequestBody LoginProviderRequestDto request) {

        return ApiResponse.success(authenticationService.loginWithProvider(provider, request));
    }

    @PostMapping("/login/local")
    public ApiResponse<TokenResponseDto> loginLocal(
            @Valid @RequestBody LoginLocalRequestDto request) {
        return ApiResponse.success(authenticationService.loginWithLocal(request));
    }

    @PostMapping("/register/local")
    public ApiResponse<TokenResponseDto> registerLocal(
            @Valid @RequestBody RegisterLocalRequestDto request) {
        return ApiResponse.success(authenticationService.registerLocal(request));
    }

    @PostMapping("/refresh")
    public ApiResponse<TokenResponseDto> refreshToken(
            @Valid @RequestBody RefreshTokenRequestDto request) {
        return ApiResponse.success(authenticationService.refreshToken(request));
    }
}