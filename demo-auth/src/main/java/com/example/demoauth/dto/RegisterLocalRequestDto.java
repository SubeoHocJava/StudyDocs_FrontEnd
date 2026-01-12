package com.example.demoauth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterLocalRequestDto {

    @NotBlank
    private String username;

    @NotBlank
    private String password;

    @Email
    private String email;

    private String displayName;
}


