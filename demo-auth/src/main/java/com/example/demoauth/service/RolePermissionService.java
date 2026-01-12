package com.example.demoauth.service;

import com.example.demoauth.domain.Permission;
import com.example.demoauth.domain.Role;
import com.example.demoauth.exception.ApiException;
import com.example.demoauth.exception.CommonErrorCodes;
import com.example.demoauth.repository.PermissionRepository;
import com.example.demoauth.repository.RoleRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

@Service
public class RolePermissionService {

    private final RoleRepository roleRepository;
    private final PermissionRepository permissionRepository;

    public RolePermissionService(RoleRepository roleRepository, PermissionRepository permissionRepository) {
        this.roleRepository = roleRepository;
        this.permissionRepository = permissionRepository;
    }

    @Transactional(readOnly = true)
    public List<String> listRoleNames() {
        return roleRepository.findAll().stream()
                .map(Role::getRoleName)
                .sorted()
                .toList();
    }

    @Transactional(readOnly = true)
    public List<String> listPermissionNames() {
        return permissionRepository.findAll().stream()
                .map(Permission::getPermissionName)
                .sorted()
                .toList();
    }

    @Transactional(readOnly = true)
    public List<String> getPermissionsOfRole(String roleName) {
        Role role = getRoleByNameOrThrow(roleName);
        return role.getPermissions().stream()
                .map(Permission::getPermissionName)
                .sorted()
                .toList();
    }

    @Transactional
    public List<String> setPermissions(String roleName, Set<String> permissionNames) {
        Role role = getRoleByNameOrThrow(roleName);
        Set<Permission> permissions = resolvePermissionsOrThrow(permissionNames);
        role.getPermissions().clear();
        role.getPermissions().addAll(permissions);
        roleRepository.save(role);
        return getPermissionsOfRole(roleName);
    }

    @Transactional
    public List<String> addPermissions(String roleName, Set<String> permissionNames) {
        Role role = getRoleByNameOrThrow(roleName);
        Set<Permission> permissions = resolvePermissionsOrThrow(permissionNames);
        role.getPermissions().addAll(permissions);
        roleRepository.save(role);
        return getPermissionsOfRole(roleName);
    }

    @Transactional
    public List<String> removePermissions(String roleName, Set<String> permissionNames) {
        Role role = getRoleByNameOrThrow(roleName);
        Set<String> removeNames = new TreeSet<>(permissionNames);
        role.getPermissions().removeIf(p -> removeNames.contains(p.getPermissionName()));
        roleRepository.save(role);
        return getPermissionsOfRole(roleName);
    }

    private Role getRoleByNameOrThrow(String roleName) {
        return roleRepository.findByRoleName(roleName)
                .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, CommonErrorCodes.ROLE_NOT_FOUND, "Role not found: " + roleName));
    }

    private Set<Permission> resolvePermissionsOrThrow(Collection<String> permissionNames) {
        List<Permission> found = permissionRepository.findAllByPermissionNameIn(permissionNames);
        Set<String> foundNames = found.stream().map(Permission::getPermissionName).collect(Collectors.toSet());
        List<String> missing = permissionNames.stream()
                .filter(p -> !foundNames.contains(p))
                .distinct()
                .sorted()
                .toList();
        if (!missing.isEmpty()) {
            throw new ApiException(HttpStatus.NOT_FOUND, CommonErrorCodes.PERMISSION_NOT_FOUND, "Permissions not found: " + missing);
        }
        return Set.copyOf(found);
    }
}


