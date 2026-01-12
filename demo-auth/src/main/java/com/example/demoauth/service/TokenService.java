package com.example.demoauth.service;

import com.example.demoauth.domain.Permission;
import com.example.demoauth.domain.RefreshToken;
import com.example.demoauth.domain.Role;
import com.example.demoauth.domain.User;
import com.example.demoauth.dto.TokenResponseDto;
import com.example.demoauth.exception.AuthErrorCodes;
import com.example.demoauth.exception.AuthException;
import com.example.demoauth.exception.RefreshTokenException;
import com.example.demoauth.repository.RefreshTokenRepository;
import com.example.demoauth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Sinh access/refresh token nội bộ cho cả local login và Google login.
 */
@Service
@RequiredArgsConstructor
public class TokenService {

    private final JwtEncoder jwtEncoder;
    private final JwtDecoder jwtDecoder;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;

    @Value("${jwt.access-token-ttl-seconds:900}") // 15 phút
    private long accessTokenTtlSeconds;

    @Value("${jwt.refresh-token-ttl-seconds:1209600}") // 14 ngày
    private long refreshTokenTtlSeconds;

    @Value("${jwt.issuer:http://localhost:8080}")
    private String issuer;

    @Transactional // Thay đổi từ readOnly = true vì cần write vào DB
    public TokenResponseDto generateTokens(User user) {
        // Thu thập roles/permissions từ user đã load (cần ở trong transaction để tránh LazyInit).
        Set<String> roles = user.getRoles().stream()
                .map(Role::getRoleName)
                .collect(Collectors.toSet());

        Set<String> permissions = user.getRoles().stream()
                .flatMap(role -> role.getPermissions().stream())
                .map(Permission::getPermissionName)
                .collect(Collectors.toSet());

        Instant now = Instant.now();

        // Access token
        JwtClaimsSet accessClaims = JwtClaimsSet.builder()
                .issuer(issuer)
                .issuedAt(now)
                .expiresAt(now.plusSeconds(accessTokenTtlSeconds))
                .subject(user.getId())
                .id(UUID.randomUUID().toString())
                .claim("name", user.getDisplayName())
                .claim("roles", roles)
                .claim("permissions", permissions)
                .build();

        String accessToken = jwtEncoder.encode(JwtEncoderParameters.from(accessClaims)).getTokenValue();

        // Refresh token
        String refreshTokenJti = UUID.randomUUID().toString(); // Generate JTI trước
        Instant refreshExpiresAt = now.plusSeconds(refreshTokenTtlSeconds);
        
        JwtClaimsSet refreshClaims = JwtClaimsSet.builder()
                .issuer(issuer)
                .issuedAt(now)
                .expiresAt(refreshExpiresAt)
                .subject(user.getId())
                .id(refreshTokenJti) // Dùng JTI đã generate
                .claim("type", "refresh_token")
                .build();

        String refreshToken = jwtEncoder.encode(JwtEncoderParameters.from(refreshClaims)).getTokenValue();

        // Lưu refresh token vào DB
        RefreshToken refreshTokenEntity = RefreshToken.builder()
                .refreshTokenJti(refreshTokenJti)
                .user(user)
                .expiresAt(LocalDateTime.ofInstant(refreshExpiresAt, ZoneId.systemDefault()))
                .revoked(false)
                .build();
        refreshTokenRepository.save(refreshTokenEntity);

        TokenResponseDto dto = new TokenResponseDto();
        dto.setAccessToken(accessToken);        
        dto.setRefreshToken(refreshToken);
        dto.setTokenType("Bearer");
        return dto;
    }

    /**
     * Refresh access token và refresh token mới.
     * Token rotation: revoke refresh token cũ, tạo refresh token mới.
     */
    @Transactional
    public TokenResponseDto refreshToken(String refreshTokenString) {
        // 1. Decode và verify refresh token
        Jwt jwt;
        try {
            jwt = jwtDecoder.decode(refreshTokenString);
        } catch (JwtException e) {
            throw RefreshTokenException.invalid();
        }

        // 2. Check type claim (phải là refresh_token)
        String type = jwt.getClaimAsString("type");
        if (!"refresh_token".equals(type)) {
            throw RefreshTokenException.invalid();
        }

        // 3. JwtDecoder đã verify expiration, nhưng double check
        Instant expiresAt = jwt.getExpiresAt();
        if (expiresAt == null || expiresAt.isBefore(Instant.now())) {
            throw RefreshTokenException.expired();
        }

        // 4. Lấy JTI từ token
        String refreshTokenJti = jwt.getId();
        if (refreshTokenJti == null) {
            throw RefreshTokenException.invalid();
        }

        // 5. Tìm refresh token trong DB và check chưa bị revoke
        RefreshToken refreshTokenEntity = refreshTokenRepository
                .findByRefreshTokenJtiAndRevokedFalse(refreshTokenJti)
                .orElseThrow(RefreshTokenException::notFound);

        // 6. Lấy user từ refresh token
        String userId = jwt.getSubject();
        User user = userRepository.findById(userId)
                // If user no longer exists, treat as invalid refresh token.
                .orElseThrow(() -> new AuthException(HttpStatus.UNAUTHORIZED, AuthErrorCodes.REFRESH_TOKEN_INVALID, "User not found"));

        // 7. Revoke refresh token cũ
        refreshTokenEntity.setRevoked(true);
        refreshTokenEntity.setRevokedAt(LocalDateTime.now());
        refreshTokenRepository.save(refreshTokenEntity);

        // 8. Tạo cặp token mới (access + refresh)
        return generateTokens(user);
    }
}