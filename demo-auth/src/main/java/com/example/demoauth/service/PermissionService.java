package com.example.demoauth.service;

import com.example.demoauth.domain.Permission;
import com.example.demoauth.exception.ApiException;
import com.example.demoauth.exception.CommonErrorCodes;
import com.example.demoauth.repository.PermissionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PermissionService {

    private final PermissionRepository permissionRepository;

    public PermissionService(PermissionRepository permissionRepository) {
        this.permissionRepository = permissionRepository;
    }

    @Transactional
    public String create(String permissionName, String description) {
        String normalized = permissionName == null ? null : permissionName.trim();
        if (normalized == null || normalized.isEmpty()) {
            throw new ApiException(HttpStatus.BAD_REQUEST, CommonErrorCodes.VALIDATION_FAILED, "permissionName is blank");
        }

        if (permissionRepository.findByPermissionName(normalized).isPresent()) {
            throw new ApiException(HttpStatus.CONFLICT, CommonErrorCodes.PERMISSION_ALREADY_EXISTS, "Permission already exists: " + normalized);
        }

        Permission permission = Permission.builder()
                .permissionName(normalized)
                .description(description)
                .build();

        return permissionRepository.save(permission).getPermissionName();
    }
}


