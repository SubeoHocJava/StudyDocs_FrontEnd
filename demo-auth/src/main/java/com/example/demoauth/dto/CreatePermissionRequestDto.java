package com.example.demoauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreatePermissionRequestDto {
    @NotBlank
    private String permissionName;

    private String description;
}


