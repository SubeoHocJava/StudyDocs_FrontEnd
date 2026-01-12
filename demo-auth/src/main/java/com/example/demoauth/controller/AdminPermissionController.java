package com.example.demoauth.controller;

import com.example.demoauth.dto.CreatePermissionRequestDto;
import com.example.demoauth.shared.web.ApiResponse;
import com.example.demoauth.service.PermissionService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminPermissionController {

    private final PermissionService permissionService;

    public AdminPermissionController(PermissionService permissionService) {
        this.permissionService = permissionService;
    }

    @PostMapping("/permissions")
    public ApiResponse<String> createPermission(@Valid @RequestBody CreatePermissionRequestDto request) {
        return ApiResponse.success(permissionService.create(request.getPermissionName(), request.getDescription()));
    }
}


