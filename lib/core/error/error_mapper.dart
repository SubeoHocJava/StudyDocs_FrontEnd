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

    //Academic Service
    '201': 'Không tìm thấy trường đại học.',
    '202': 'Không tìm thấy khoa.',
    '203': 'Không tìm thấy bộ môn.',
    '204': 'Không tìm thấy ngành học.',
    '205': 'Slug trường đại học đã tồn tại (duplicate).',
    '206': 'Slug khoa đã tồn tại (duplicate).',
    '207': 'Slug bộ môn đã tồn tại (duplicate).',
    '208': 'Slug ngành học đã tồn tại (duplicate).',
    '209': 'University ID không khớp (resource không thuộc về university được chỉ định).',
    '210': 'Faculty ID không khớp (resource không thuộc về faculty/university được chỉ định).',
    '211': 'Department ID không khớp (resource không thuộc về department/faculty/university được chỉ định).',
    '212': 'Major ID không khớp (resource không thuộc về major/department/faculty/university được chỉ định).',
    '213': 'UUID format không hợp lệ.',
    '299': 'Lỗi academic không xác định (fallback).',

    //File Service
    '300': 'Không tìm thấy file.',
    '301': 'Định dạng tệp tin không được hỗ trợ.',
    '302': 'Định dạng tệp tin không hợp lệ.',
    '303': 'Tên tệp tin không hợp lệ.',
    '304': 'Kích thước tệp tin vượt quá giới hạn.',
    '305': 'Tổng số trang không hợp lệ.',
    '306': 'Thời gian tạo tệp tin không hợp lệ.',
    '307': 'Storage Location không hợp lệ.',
    '308': 'Tệp tin rỗng.',
    '309': 'Upload tệp tin thất bại.',
    '310': 'Xóa tệp tin thất bại.',
    '399': 'Dữ liệu đã bị thay đổi bởi người khác (Optimistic Locking).',

    //Document Service
    '400': 'Yêu cầu không hợp lệ. Dữ liệu đầu vào không hợp lệ hoặc kiểm tra dữ liệu thất bại.',
    '401': 'Không tìm thấy tài liệu. Không tồn tại tài liệu với ID được cung cấp.',
    '402': 'Loại tệp không hợp lệ. Định dạng hoặc MIME type của tệp không được hỗ trợ.',
    '403': 'Dung lượng tệp vượt quá giới hạn cho phép.',
    '404': 'Không tìm thấy người dùng liên quan đến thao tác này.',
    '405': 'Tiêu đề không hợp lệ. Tiêu đề bị thiếu hoặc để trống.',
    '406': 'Từ chối truy cập. Người dùng không có quyền thực hiện hành động này.',
    '407': 'Tải tệp từ xa thất bại. Không thể tải tệp lên dịch vụ lưu trữ.',

    // Notification Service
    '600': 'Không tìm thấy thông báo.',
    '601': 'Không tìm thấy mẫu thông báo theo ID.',
    '602': 'Không tìm thấy mẫu thông báo theo tên.',
    '603': 'Không tìm thấy người nhận.',
    '604': 'Không tìm thấy danh sách người nhận.',
    '605': 'Không tìm thấy người gửi.',
    '606': 'Không tìm thấy hồ sơ thông báo người dùng.',
    '607': 'Không tìm thấy thông tin người nhận trong thông báo.',

    '608': 'Trạng thái thông báo không hợp lệ.',
    '609': 'Loại thông báo không hợp lệ.',
    '610': 'Kênh thông báo không hợp lệ.',
    '611': 'Thời gian tạo thông báo không hợp lệ.',
    '612': 'Thời gian xóa thông báo không hợp lệ.',
    '613': 'Tên mẫu thông báo không hợp lệ.',
    '614': 'Tiêu đề mẫu thông báo không hợp lệ.',
    '615': 'Nội dung mẫu thông báo không hợp lệ.',
    '616': 'Mô tả mẫu thông báo không hợp lệ.',
    '617': 'Mô tả mẫu thông báo bị bỏ trống.',
    '618': 'Mô tả mẫu thông báo quá ngắn.',
    '619': 'Mô tả mẫu thông báo quá dài.',
    '620': 'Kênh mẫu thông báo không hợp lệ.',
    '621': 'Thời gian tạo mẫu thông báo không hợp lệ.',
    '622': 'Thời gian cập nhật mẫu thông báo không hợp lệ.',
    '623': 'Loại mẫu thông báo không hợp lệ.',
    '624': 'Dữ liệu nội dung không hợp lệ.',
    '625': 'Dữ liệu cá nhân hóa không hợp lệ.',
    '626': 'Snapshot tiêu đề thông báo không hợp lệ.',
    '627': 'Snapshot nội dung thông báo không hợp lệ.',
    '628': 'Token FCM không hợp lệ.',
    '637': 'Địa chỉ email không hợp lệ.',
    '638': 'Số điện thoại không hợp lệ.',

    '629': 'Mẫu thông báo đã tồn tại.',
    '630': 'Token FCM bị trùng lặp.',
    '631': 'Thông báo đã bị xóa mềm trước đó.',
    '632': 'Người nhận thông báo đã tồn tại.',
    '633': 'Hồ sơ thông báo người dùng đã tồn tại.',
    '634': 'Thông báo chưa bị xóa mềm.',
    '635': 'Người nhận thông báo đã bị xóa.',
    '636': 'Từ chối truy cập.',

    // System
    '500': 'Lỗi hệ thống, máy chủ đang gặp sự cố. Vui lòng thử lại sau.',

    // Follow
    '801': 'Follow relationship không tồn tại',
    '802': 'Đã follow người này rồi',
    '803': 'KKhông thể follow chính mình',
    '805': 'UUID format không hợp lệ',
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
