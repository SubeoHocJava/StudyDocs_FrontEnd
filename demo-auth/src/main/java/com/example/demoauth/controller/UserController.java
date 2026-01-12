package com.example.demoauth.controller;

import com.example.demoauth.dto.UserResponseDto;
import com.example.demoauth.shared.web.ApiResponse;
import com.example.demoauth.service.UserService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    @PreAuthorize("hasAuthority('READ_USER')")
    public ApiResponse<UserResponseDto> me(Authentication authentication) {
        String userId = (String) authentication.getPrincipal(); // lấy từ sub trong JWT
        return ApiResponse.success(userService.getById(userId));
    }
}


