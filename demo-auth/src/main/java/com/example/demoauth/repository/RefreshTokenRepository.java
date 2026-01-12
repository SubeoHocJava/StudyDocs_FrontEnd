package com.example.demoauth.repository;

import com.example.demoauth.domain.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.time.LocalDateTime;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, String> {

 /**
     * Tìm refresh token bằng JTI và check chưa bị revoke.
     */
 Optional<RefreshToken> findByRefreshTokenJtiAndRevokedFalse(String refreshTokenJti);

 /**
  * Revoke tất cả refresh token của một user (dùng khi logout all devices).
  */
 @Modifying
 @Query("UPDATE RefreshToken rt SET rt.revoked = true, rt.revokedAt = :revokedAt WHERE rt.user.id = :userId AND rt.revoked = false")
 int revokeAllByUserId(@Param("userId") String userId, @Param("revokedAt") LocalDateTime revokedAt);

 /**
  * Xóa các refresh token đã hết hạn (cleanup job).
  */
 @Modifying
 @Query("DELETE FROM RefreshToken rt WHERE rt.expiresAt < :now")
 int deleteExpiredTokens(@Param("now") LocalDateTime now);
}