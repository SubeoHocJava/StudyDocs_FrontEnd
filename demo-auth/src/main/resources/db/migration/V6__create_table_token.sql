CREATE TABLE refresh_tokens(
    refresh_token_jti VARCHAR(255) PRIMARY KEY, 
    user_id          CHAR(36) NOT NULL,
    expires_at       TIMESTAMP NOT NULL,
    revoked          BOOLEAN DEFAULT FALSE,    
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revoked_at       TIMESTAMP NULL,          

        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
);