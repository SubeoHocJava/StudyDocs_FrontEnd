-- Seed role & permission mẫu
INSERT INTO roles (id, role_name, description)
VALUES ('11111111-1111-1111-1111-111111111111', 'ROLE_USER', 'Default user role')
ON DUPLICATE KEY UPDATE role_name = role_name;

INSERT INTO permissions (id, permission_name, description)
VALUES ('22222222-2222-2222-2222-222222222222', 'READ_USER', 'Allow read user info')
ON DUPLICATE KEY UPDATE permission_name = permission_name;

INSERT INTO role_permissions (role_id, permission_id)
VALUES ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222')
ON DUPLICATE KEY UPDATE role_id = role_id;

