-- Khởi tạo bảng vai trò
CREATE TABLE roles
(
    id          CHAR(36) PRIMARY KEY,
    role_name   VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255)
);

-- Khởi tạo bảng phân quyền vai trò cho người dùng

CREATE TABLE permissions
(
    id              CHAR(36) PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    description     VARCHAR(255)
);
