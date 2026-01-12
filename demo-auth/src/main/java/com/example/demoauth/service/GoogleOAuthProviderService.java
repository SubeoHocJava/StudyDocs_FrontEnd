package com.example.demoauth.service;

import java.util.List;
import java.util.Optional;

import com.example.demoauth.domain.User;
import com.example.demoauth.domain.UserIdentity;
import com.example.demoauth.dto.LoginProviderRequestDto;
import com.example.demoauth.dto.TokenResponseDto;
import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import com.example.demoauth.repository.RoleRepository;
import com.example.demoauth.repository.UserIdentityRepository;
import com.example.demoauth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
import org.springframework.security.oauth2.core.endpoint.OAuth2ParameterNames;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GoogleOAuthProviderService implements OAuthProviderService {

    private static final String PROVIDER_NAME = "google";
    private static final String GOOGLE_ISSUER = "https://accounts.google.com";
    private final UserRepository userRepository;
    private final UserIdentityRepository userIdentityRepository;
    private final JwtDecoder googleJwtDecoder;
    private final TokenService tokenService;
    private final RoleRepository roleRepository;

    public GoogleOAuthProviderService(UserRepository userRepository,
            UserIdentityRepository userIdentityRepository,
            TokenService tokenService,
            RoleRepository roleRepository,
            @Value("${spring.security.oauth2.client.registration.google.client-id}") String googleClientId) {
        this.userRepository = userRepository;
        this.userIdentityRepository = userIdentityRepository;
        this.tokenService = tokenService;
        this.roleRepository = roleRepository;
        this.googleJwtDecoder = buildGoogleJwtDecoder(googleClientId);
    }

    private JwtDecoder buildGoogleJwtDecoder(String clientId) {
        // Dùng helper của Spring để lấy đúng JWKS & config cho issuer Google
        JwtDecoder decoder = JwtDecoders.fromIssuerLocation(GOOGLE_ISSUER);

        var defaultValidator = JwtValidators.createDefaultWithIssuer(GOOGLE_ISSUER);

        OAuth2TokenValidator<Jwt> audienceValidator = jwt -> {
            List<String> audiences = jwt.getAudience();
            if (audiences != null && audiences.contains(clientId)) {
                return OAuth2TokenValidatorResult.success();
            }
            OAuth2Error error = new OAuth2Error(
                    "invalid_token",
                    "Invalid audience",
                    OAuth2ParameterNames.AUDIENCE);
            return OAuth2TokenValidatorResult.failure(error);
        };

        ((NimbusJwtDecoder) decoder)
                .setJwtValidator(new DelegatingOAuth2TokenValidator<>(defaultValidator, audienceValidator));

        return decoder;
    }

    @Override
    public String getProviderName() {
        return PROVIDER_NAME;
    }

    /**
     * Tạm thời: coi tokenId chính là provider_user_id.
     * Sau này khi tích hợp verify Google ID token, ta sẽ trích xuất sub/email/name
     * từ token.
     */
    @Override
    @Transactional
    public TokenResponseDto login(LoginProviderRequestDto request) {
        Jwt jwt;
        try {
            jwt = googleJwtDecoder.decode(request.getTokenId());
        } catch (JwtValidationException ex) {
            throw new AuthException(
                    HttpStatus.UNAUTHORIZED,
                    AuthErrorCodes.INVALID_PROVIDER_TOKEN,
                    "Google token validation failed: " + ex.getMessage(),
                    ex);
        }

        String providerUserId = jwt.getSubject(); // "sub" từ Google
        String email = jwt.getClaimAsString("email");
        Boolean emailVerified = jwt.getClaim("email_verified");
        String name = jwt.getClaimAsString("name");

        // 1. Tìm xem identity đã tồn tại chưa
        Optional<UserIdentity> existingIdentityOpt = userIdentityRepository
                .findByProviderAndProviderUserId(PROVIDER_NAME, providerUserId);

        User user;
        if (existingIdentityOpt.isPresent()) {
            // Đã có người dùng gắn với provider + providerUserId này
            user = existingIdentityOpt.get().getUser();
        } else {
            // 2. Nếu chưa có, tạo mới User + UserIdentity
            user = User.builder()
                    .email(email)
                    .username(email != null ? email : "google-" + providerUserId)
                    .passwordHash(null) // Login bằng Google nên không cần mật khẩu local
                    .displayName(name != null ? name : "GoogleUser-" + providerUserId)
                    .emailVerified(Boolean.TRUE.equals(emailVerified))
                    .build();
            user = userRepository.save(user);

            // Gán role mặc định nếu có (owner side ở Role)
            var defaultRole = roleRepository.findByRoleName("ROLE_USER").orElse(null);
            if (defaultRole != null) {
                defaultRole.getUsers().add(user);
                user.getRoles().add(defaultRole);
                roleRepository.save(defaultRole);
            }

            UserIdentity identity = UserIdentity.builder()
                    .user(user)
                    .provider(PROVIDER_NAME)
                    .providerUserId(providerUserId)
                    .build();
            userIdentityRepository.save(identity);
        }

        // 3. Sinh access/refresh token nội bộ
        return tokenService.generateTokens(user);
    }
}
