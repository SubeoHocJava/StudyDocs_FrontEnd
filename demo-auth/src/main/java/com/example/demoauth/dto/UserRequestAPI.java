package com.example.demoauth.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserRequestAPI {
    private String fullName;
    private String username;
    private String email;
}
