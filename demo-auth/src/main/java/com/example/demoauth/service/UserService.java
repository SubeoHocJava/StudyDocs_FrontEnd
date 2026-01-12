package com.example.demoauth.service;

import com.example.demoauth.domain.Permission;
import com.example.demoauth.domain.Role;
import com.example.demoauth.domain.User;
import com.example.demoauth.domain.UserIdentity;
import com.example.demoauth.dto.UserResponseDto;
import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import com.example.demoauth.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public UserResponseDto getById(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AuthException(HttpStatus.NOT_FOUND, AuthErrorCodes.USER_NOT_FOUND, "User not found"));

        Set<String> roles = user.getRoles().stream()
                .map(Role::getRoleName)
                .collect(Collectors.toSet());
        Set<String> permissions = user.getRoles().stream()
                .flatMap(r -> r.getPermissions().stream())
                .map(Permission::getPermissionName)
                .collect(Collectors.toSet());

        Optional<UserIdentity> identityOpt = user.getIdentities().stream().findFirst();

        return UserResponseDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .username(user.getUsername())
                .displayName(user.getDisplayName())
                .isActive(user.getIsActive())
                .emailVerified(user.getEmailVerified())
                .createdAt(user.getCreatedAt())
                .roles(roles)
                .permissions(permissions)
                .provider(identityOpt.map(UserIdentity::getProvider).orElse("local"))
                .build();
    }
}


