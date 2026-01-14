/// Tiện ích ánh xạ mã lỗi từ Backend sang thông báo tiếng Việt thân thiện
class ErrorMapper {
  /// Map chứa các mã lỗi (errorCode dạng int) và thông báo tương ứng
  static const Map<String, String> _errorMap = {
    // --- Auth Error Codes (0–99) ---
    '1': 'Sai tên đăng nhập hoặc mật khẩu.',
    '2': 'Tên đăng nhập đã tồn tại.',
    '3': 'Email đã tồn tại.',
    '4': 'Không tìm thấy thông tin người dùng.',
    '5': 'Nhà cung cấp đăng nhập (OAuth) không được hỗ trợ.',
    
    // Refresh Token logic
    '10': 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.',
    '11': 'Phiên đăng nhập đã bị hủy, vui lòng đăng nhập lại.',
    '12': 'Phiên đăng nhập không hợp lệ, vui lòng đăng nhập lại.',
    '13': 'Không tìm thấy thông tin phiên làm việc.',

    // Security
    '90': 'Access token không hợp lệ hoặc đã hết hạn.',
    '91': 'Bạn không có quyền thực hiện hành động này (Forbidden).',
    '99': 'Lỗi xác thực không xác định.',

    // --- Common Error Codes (50–59, 500) ---
    '50': 'Dữ liệu gửi lên không đúng định dạng (Validation failed).',
    '51': 'Yêu cầu không hợp lệ (Bad request).',
    '52': 'Không tìm thấy vai trò (Role) yêu cầu.',
    '53': 'Không tìm thấy quyền (Permission) yêu cầu.',
    '54': 'Quyền truy cập này đã tồn tại trong hệ thống.',
    
    // System
    '500': 'Lỗi hệ thống, máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
  };

  /// Chuyển đổi errorCode (int) thành message tiếng Việt
  /// Nếu không tìm thấy mã lỗi, trả về defaultMessage hoặc thông báo lỗi mặc định
  static String map(int? errorCode, {String? defaultMessage}) {
    if (errorCode == null) return defaultMessage ?? 'Đã có lỗi xảy ra, vui lòng thử lại.';
    
    final codeStr = errorCode.toString();
    
    return _errorMap[codeStr] ?? defaultMessage ?? 'Lỗi không xác định (Mã: $codeStr)';
  }

  /// Helper để xử lý lỗi nhanh từ ApiResponse
  static String fromErrorCode(int? errorCode) => map(errorCode);
}
