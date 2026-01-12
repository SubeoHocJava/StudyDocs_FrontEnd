package com.example.demoauth.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Set;

@Data
@Builder
public class UserResponseDto {
    private String id;
    private String email;
    private String username;
    private String displayName;
    private Boolean isActive;
    private Boolean emailVerified;
    private LocalDateTime createdAt;
    private Set<String> roles;
    private Set<String> permissions;
    private String provider; // provider đầu tiên (nếu có)
}


