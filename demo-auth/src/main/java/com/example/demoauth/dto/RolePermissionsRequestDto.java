package com.example.demoauth.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.Set;

@Data
public class RolePermissionsRequestDto {
    @NotEmpty
    private Set<String> permissionNames;
}


