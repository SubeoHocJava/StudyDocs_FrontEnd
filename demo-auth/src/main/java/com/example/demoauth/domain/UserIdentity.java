package com.example.demoauth.domain;


import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;

/**
 * Liên kết tài khoản hệ thống với tài khoản của provider (google, facebook...).
 */
@Entity
@Table(
    name = "user_identities",
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_provider_user", columnNames = {"provider", "provider_user_id"})
    }
)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserIdentity {

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(length = 36)
    private String id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 100)
    private String provider; // google, facebook,...

    @Column(name = "provider_user_id", nullable = false, length = 255)
    private String providerUserId;
}


