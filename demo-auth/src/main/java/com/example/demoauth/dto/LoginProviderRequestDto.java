package com.example.demoauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginProviderRequestDto {
    @NotBlank
    private String tokenId;
    
}
