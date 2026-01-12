-- Bảng mặc định Spring Security dùng cho JdbcOAuth2AuthorizedClientService
CREATE TABLE IF NOT EXISTS oauth2_authorized_client (
    client_registration_id varchar(100) NOT NULL,
    principal_name         varchar(200) NOT NULL,
    access_token_type      varchar(100),
    access_token_value     text,
    access_token_issued_at timestamp,
    access_token_expires_at timestamp,
    access_token_scopes    text,
    refresh_token_value    text,
    refresh_token_issued_at timestamp,
    created_at             timestamp DEFAULT CURRENT_TIMESTAMP,
    attributes             text,
    PRIMARY KEY (client_registration_id, principal_name)
);


