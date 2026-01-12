package com.example.demoauth.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "refresh_tokens")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RefreshToken {
    @Id
    @Column(name = "refresh_token_jti", length = 255)
    private String refreshTokenJti;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    @Column(name = "revoked", nullable = false)
    private Boolean revoked;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "revoked_at", nullable = true)
    private LocalDateTime revokedAt;

    @PrePersist
    void onCreate() {
        if(createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if(revoked == null) {
            revoked = Boolean.FALSE;
        }
    };
}
