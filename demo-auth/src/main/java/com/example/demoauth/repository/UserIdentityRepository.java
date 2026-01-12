package com.example.demoauth.repository;

import com.example.demoauth.domain.UserIdentity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserIdentityRepository extends JpaRepository<UserIdentity, String> {

    Optional<UserIdentity> findByProviderAndProviderUserId(String provider, String providerUserId);
}


