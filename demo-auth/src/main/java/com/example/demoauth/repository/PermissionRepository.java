package com.example.demoauth.repository;

import com.example.demoauth.domain.Permission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface PermissionRepository extends JpaRepository<Permission, String> {
    Optional<Permission> findByPermissionName(String permissionName);

    List<Permission> findAllByPermissionNameIn(Collection<String> permissionNames);
}


