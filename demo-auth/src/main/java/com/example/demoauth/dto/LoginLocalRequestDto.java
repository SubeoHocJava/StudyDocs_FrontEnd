package com.example.demoauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginLocalRequestDto {
    @NotBlank
    private String username;
    @NotBlank
    private String password;
}
