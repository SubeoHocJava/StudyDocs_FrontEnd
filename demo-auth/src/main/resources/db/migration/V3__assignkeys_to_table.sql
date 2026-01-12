-- Gắn khóa ngoại giữa bảng users và roles thông qua bảng user_roles
CREATE TABLE user_roles (
                            user_id CHAR(36) NOT NULL,
                            role_id CHAR(36) NOT NULL,

                            PRIMARY KEY (user_id, role_id),

                            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                            FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Gắn khóa ngoại giữa bảng roles và permissions thông qua bảng role_permissions
CREATE TABLE role_permissions (
                                  role_id CHAR(36) NOT NULL,
                                  permission_id CHAR(36) NOT NULL,

                                  PRIMARY KEY (role_id, permission_id),

                                  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
                                  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);
