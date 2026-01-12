## Auth Service

**AuthService** là microservice xác thực & phân quyền cho hệ thống **StudyDocs**, chịu trách nhiệm quản lý người dùng, đăng nhập (local & OAuth2 provider), phát hành JWT access/refresh token, quản lý vai trò (Role) & quyền (Permission), và expose JWKS cho các service khác verify token.

---

- Port: **8080**
- Database: MySQL (cấu hình qua environment variables)
- API base URLs:
  - `http://localhost:8080/api/auth`
  - `http://localhost:8080/api/user`
  - `http://localhost:8080/api/admin`
  - `http://localhost:8080/.well-known/jwks.json`

## 1. Giới thiệu

- **Mục đích**: Cung cấp dịch vụ xác thực/ủy quyền tập trung cho toàn bộ hệ thống StudyDocs.
- **Đặc điểm nổi bật**:
  - Local login/register bằng username/password.
  - Login qua OAuth provider (ví dụ: Google).
  - JWT access token + refresh token (token rotation + revoke trong DB).
  - JWKS endpoint để các service khác verify JWT.
  - Role/Permission nhúng vào JWT (`roles`, `permissions`) để service khác authorize.
  - API `/api/user/me` đọc thông tin user hiện tại từ JWT.
  - Admin APIs để quản lý permissions của role (`/api/admin/**`).
  - Chuẩn hóa response bằng `ApiResponse` (statusCode, errorCode, data, traceId=null).
  - Hệ thống error code cho auth (0–99) + common (50+).
  - Password hash với BCrypt, migration DB bằng Flyway.

---

## 2. Chức năng chi tiết

### 2.1 Authentication & Token

1. **Đăng nhập local**
   - `POST /api/auth/login/local`
   - Input: `username`, `password`
   - Xử lý:
     - Tìm user theo username.
     - So khớp password bằng BCrypt.
     - Đảm bảo gán `ROLE_USER` nếu user chưa có role.
     - Sinh access + refresh token, lưu refresh token xuống DB.
   - Output: `TokenResponseDto` (accessToken, refreshToken, tokenType) bọc trong `ApiResponse`.

2. **Đăng ký local**
   - `POST /api/auth/register/local`
   - Tạo user mới:
     - Validate unique username/email.
     - Hash password.
     - Gán `ROLE_USER` mặc định.
   - Trả về cặp token như login.

3. **Đăng nhập với OAuth provider**
   - `POST /api/auth/login/provider/{provider}`
   - Ủy quyền sang `OAuthProviderService` cụ thể (ví dụ: Google):
     - Lấy thông tin user từ provider.
     - Tìm/tạo user nội bộ + `UserIdentity`.
     - Trả về access + refresh token.

4. **Refresh token**
   - `POST /api/auth/refresh`
   - Input: `refreshToken`.
   - Xử lý:
     - Decode + verify refresh token (type, expiration).
     - Lấy `jti` và tìm trong bảng `refresh_tokens` chưa revoked.
     - Lấy user từ DB; revoke refresh token cũ; sinh cặp token mới.
   - Nếu lỗi: ném `RefreshTokenException` với error code chi tiết.

5. **Quản lý Refresh Token**
   - Lưu mỗi refresh token dưới dạng `refresh_token_jti` + userId + expiresAt + revoked.
   - Hỗ trợ:
     - Revoke từng token khi refresh.
     - Revoke theo user (logout all devices) bằng custom query.

### 2.2 User & Profile

6. **Lấy thông tin user hiện tại**
   - `GET /api/user/me`
   - Bảo vệ bằng `@PreAuthorize("hasAuthority('READ_USER')")`.
   - Security filter decode JWT → `principal = userId`.
   - Service:
     - Lấy user, roles, permissions, provider đầu tiên (nếu có).
     - Trả `UserResponseDto` bọc trong `ApiResponse`.

7. **Liên kết identity OAuth**
   - `UserIdentity` lưu `(provider, providerUserId)` gắn với `User`.
   - Giúp login lại từ provider map về đúng user nội bộ.

### 2.3 Role & Permission Management (Admin)

8. **List roles**
   - `GET /api/admin/roles`  
   - Trả danh sách tên role (ví dụ: `ROLE_USER`, `ROLE_ADMIN`).

9. **List permissions**
   - `GET /api/admin/permissions`  
   - Trả danh sách permission name (ví dụ: `READ_USER`, `MANAGE_ROLE_PERMISSION`).

10. **Tạo permission**
    - `POST /api/admin/permissions`
    - Body:
      { "permissionName": "WRITE_FILE", "description": "Allow write file" }
      