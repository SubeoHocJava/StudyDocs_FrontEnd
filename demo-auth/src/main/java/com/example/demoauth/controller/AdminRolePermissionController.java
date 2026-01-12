package com.example.demoauth.controller;

import com.example.demoauth.dto.RolePermissionsRequestDto;
import com.example.demoauth.shared.web.ApiResponse;
import com.example.demoauth.service.RolePermissionService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminRolePermissionController {

    private final RolePermissionService rolePermissionService;

    public AdminRolePermissionController(RolePermissionService rolePermissionService) {
        this.rolePermissionService = rolePermissionService;
    }

    @GetMapping("/roles")
    public ApiResponse<List<String>> listRoles() {
        return ApiResponse.success(rolePermissionService.listRoleNames());
    }

    @GetMapping("/permissions")
    public ApiResponse<List<String>> listPermissions() {
        return ApiResponse.success(rolePermissionService.listPermissionNames());
    }

    @GetMapping("/roles/{roleName}/permissions")
    public ApiResponse<List<String>> getRolePermissions(@PathVariable String roleName) {
        return ApiResponse.success(rolePermissionService.getPermissionsOfRole(roleName));
    }

    /**
     * Replace ALL permissions of role.
     */
    @PutMapping("/roles/{roleName}/permissions")
    public ApiResponse<List<String>> setRolePermissions(@PathVariable String roleName,
                                                        @Valid @RequestBody RolePermissionsRequestDto request) {
        return ApiResponse.success(rolePermissionService.setPermissions(roleName, request.getPermissionNames()));
    }

    /**
     * Add permissions to role.
     */
    @PostMapping("/roles/{roleName}/permissions")
    public ApiResponse<List<String>> addRolePermissions(@PathVariable String roleName,
                                                        @Valid @RequestBody RolePermissionsRequestDto request) {
        return ApiResponse.success(rolePermissionService.addPermissions(roleName, request.getPermissionNames()));
    }

    /**
     * Remove permissions from role.
     *
     * Note: Spring supports request body in DELETE.
     */
    @DeleteMapping("/roles/{roleName}/permissions")
    public ApiResponse<List<String>> removeRolePermissions(@PathVariable String roleName,
                                                           @Valid @RequestBody RolePermissionsRequestDto request) {
        return ApiResponse.success(rolePermissionService.removePermissions(roleName, request.getPermissionNames()));
    }
}


