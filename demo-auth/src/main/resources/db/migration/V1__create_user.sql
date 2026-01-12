-- Khơi tạo bảng người dùng
CREATE TABLE users
(
    id             CHAR(36) PRIMARY KEY,
    email          VARCHAR(255) UNIQUE,
    username          VARCHAR(255) UNIQUE,
    password_hash  VARCHAR(255) DEFAULT NULL,
    display_name   VARCHAR(255),

    email_verified  BOOLEAN DEFAULT FALSE,
    is_active       BOOLEAN DEFAULT TRUE,

    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Khởi tạo bảng provider xác thực bên thứ ba

CREATE TABLE user_identities
(
    id               CHAR(36) PRIMARY KEY,
    user_id          CHAR(36)     NOT NULL,
    provider          VARCHAR(100) NOT NULL,        -- google, facebook, github
    provider_user_id  VARCHAR(255) NOT NULL,        -- ID do provider cung cấp

    UNIQUE (provider, provider_user_id),

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

