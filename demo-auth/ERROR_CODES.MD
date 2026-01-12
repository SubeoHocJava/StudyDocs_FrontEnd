# Danh sách mã lỗi Auth Service

Tài liệu này mô tả các mã lỗi của Auth Service.  
Giá trị được quy định trực tiếp trong `AuthErrorCodes` (0–99) và `CommonErrorCodes` (50+).

---

## Mã lỗi xác thực (Auth Error Codes: 0–99)

### NOT FOUND / INVALID STATE

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `USER_NOT_FOUND` | 4 | Không tìm thấy user tương ứng (ví dụ: `/me` với userId không tồn tại). |
| `REFRESH_TOKEN_NOT_FOUND` | 13 | Không tìm thấy refresh token trong DB (đã bị xoá hoặc chưa lưu). |

### AUTH / LOGIN

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `INVALID_CREDENTIALS` | 1 | Sai username hoặc password khi login local. |
| `USERNAME_EXISTS` | 2 | Username đã tồn tại khi đăng ký. |
| `EMAIL_EXISTS` | 3 | Email đã tồn tại khi đăng ký. |
| `UNSUPPORTED_PROVIDER` | 5 | Provider OAuth không được hỗ trợ (ví dụ: path không mapping với provider nào). |

### REFRESH TOKEN

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `REFRESH_TOKEN_EXPIRED` | 10 | Refresh token đã hết hạn theo claim `exp`. |
| `REFRESH_TOKEN_REVOKED` | 11 | Refresh token đã bị revoke (không còn hợp lệ). |
| `REFRESH_TOKEN_INVALID` | 12 | Refresh token không hợp lệ (signature/type/claim sai hoặc user không còn tồn tại). |

### SECURITY

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `ACCESS_TOKEN_INVALID_OR_EXPIRED` | 90 | Access token không hợp lệ hoặc đã hết hạn → trả HTTP 401. |
| `FORBIDDEN` | 91 | Đã xác thực nhưng không có quyền đủ (permission/role thiếu) → trả HTTP 403. |

### UNKNOWN

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `AUTH_UNKNOWN` | 99 | Lỗi auth không xác định (fallback). |

---

## Mã lỗi chung (Common Error Codes: 50–59, 500)

Các mã lỗi chung được định nghĩa trong `CommonErrorCodes` và dùng cho nhiều service (không chỉ auth).

### VALIDATION & BAD REQUEST

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `VALIDATION_FAILED` | 50 | Request validation thất bại (ví dụ: `@Valid` lỗi, JSON parse lỗi, field thiếu). |
| `BAD_REQUEST` | 51 | Bad request chung (tham số không hợp lệ, business rule basic). |

### ROLE / PERMISSION

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `ROLE_NOT_FOUND` | 52 | Không tìm thấy role khi thao tác admin (gán/bỏ permission). |
| `PERMISSION_NOT_FOUND` | 53 | Không tìm thấy permission khi thao tác admin. |
| `PERMISSION_ALREADY_EXISTS` | 54 | Permission đã tồn tại (trùng `permission_name`). |

### SYSTEM

| Mã lỗi | Giá trị | Mô tả |
| :--- | :--- | :--- |
| `INTERNAL_ERROR` | 500 | Lỗi server không xử lý được (fallback, exception không được map riêng). |

---

## Mapping HTTP Status & ApiResponse

Tất cả lỗi được trả về dưới dạng `ApiResponse`:

{
  "statusCode": <HTTP_STATUS>,
  "errorCode": <ERROR_CODE>,
  "data": null,
  "traceId": null
}
