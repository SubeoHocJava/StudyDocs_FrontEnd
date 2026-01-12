package com.example.demoauth.service;

import com.example.demoauth.domain.User;
import com.example.demoauth.dto.*;
import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import com.example.demoauth.remote.RemoteUserService;
import com.example.demoauth.repository.RoleRepository;
import com.example.demoauth.repository.UserRepository;
import com.nimbusds.oauth2.sdk.TokenResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final OAuthProviderFactory oAuthProviderFactory;
    private final UserRepository userRepository;
    private final TokenService tokenService;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final RemoteUserService remoteUserService;



    public TokenResponseDto loginWithProvider(String provider, LoginProviderRequestDto request) {
        OAuthProviderService providerService = oAuthProviderFactory.getProvider(provider);
        // Ủy quyền cho service cụ thể xử lý login và trả về TokenResponseDto
        return providerService.login(request);
    }

    @Transactional
    public TokenResponseDto loginWithLocal(LoginLocalRequestDto request) {
        Optional<User> userOpt = userRepository.findByUsername(request.getUsername());
        if (userOpt.isEmpty()) {
            throw new AuthException(HttpStatus.UNAUTHORIZED, AuthErrorCodes.INVALID_CREDENTIALS, "Username or password is invalid");
        }

        User user = userOpt.get();
        if (user.getPasswordHash() == null || !passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new AuthException(HttpStatus.UNAUTHORIZED, AuthErrorCodes.INVALID_CREDENTIALS, "Username or password is invalid");
        }

        // Đảm bảo có role mặc định nếu chưa gán
        if (user.getRoles().isEmpty()) {
            roleRepository.findByRoleName("ROLE_USER").ifPresent(role -> {
                role.getUsers().add(user);
                user.getRoles().add(role);
                roleRepository.save(role);
            });
        }

        return tokenService.generateTokens(user);
    }

    @Transactional
    public TokenResponseDto registerLocal(RegisterLocalRequestDto request) {
        if (userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new AuthException(HttpStatus.CONFLICT, AuthErrorCodes.USERNAME_EXISTS, "Username already exists");
        }
        if (request.getEmail() != null && userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AuthException(HttpStatus.CONFLICT, AuthErrorCodes.EMAIL_EXISTS, "Email already exists");
        }
        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .displayName(request.getDisplayName() != null ? request.getDisplayName() : request.getUsername())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .emailVerified(false)
                .isActive(true)
                .build();
        user = userRepository.save(user);
        UserRequestAPI requestAPI = UserRequestAPI.builder()
                .fullName(user.getDisplayName())
                .username(user.getUsername())
                .email(user.getEmail())
                .build();

        final User savedUser = user;
        roleRepository.findByRoleName("ROLE_USER").ifPresent(role -> {
            role.getUsers().add(savedUser);
            savedUser.getRoles().add(role);
            roleRepository.save(role);
        });

        var token = tokenService.generateTokens(savedUser);
        String accessToken = token.getAccessToken();


        remoteUserService.call(requestAPI,accessToken);
        return token;
    }

    @Transactional
    public TokenResponseDto refreshToken(RefreshTokenRequestDto request) {
        return tokenService.refreshToken(request.getRefreshToken());
    }

}


