/// Định nghĩa danh sách các Enum mã lỗi Backend trả về
enum AppErrorCode {
  // Generic & System
  success('SUCCESS'),
  uncategorizedException('UNCATEGORIZED_EXCEPTION'),
  invalidKey('INVALID_KEY'),
  invalidRequest('INVALID_REQUEST'),
  resourceNotFound('RESOURCE_NOT_FOUND'),
  unauthorized('UNAUTHORIZED'),
  forbidden('FORBIDDEN'),
  methodNotAllowed('METHOD_NOT_ALLOWED'),

  // Auth / User
  userExisted('USER_EXISTED'),
  userNotExisted('USER_NOT_EXISTED'),
  invalidCredentials('INVALID_CREDENTIALS'),
  invalidToken('INVALID_TOKEN'),
  refreshTokenExpired('REFRESH_TOKEN_EXPIRED'),
  passwordNotMatch('PASSWORD_NOT_MATCH'),
  weakPassword('WEAK_PASSWORD'),
  accountLocked('ACCOUNT_LOCKED'),
  accountDisabled('ACCOUNT_DISABLED'),
  emailNotVerified('EMAIL_NOT_VERIFIED'),

  // Academic Catalog
  academicNotFound('ACADEMIC_NOT_FOUND'),
  universityNotFound('UNIVERSITY_NOT_FOUND'),
  facultyNotFound('FACULTY_NOT_FOUND'),
  departmentNotFound('DEPARTMENT_NOT_FOUND'),
  subjectNotFound('SUBJECT_NOT_FOUND'),
  duplicateAcademicCode('DUPLICATE_ACADEMIC_CODE'),

  // Document & Storage
  documentNotFound('DOCUMENT_NOT_FOUND'),
  documentAccessDenied('DOCUMENT_ACCESS_DENIED'),
  fileEmpty('FILE_EMPTY'),
  fileUploadFailed('FILE_UPLOAD_FAILED'),
  invalidFileType('INVALID_FILE_TYPE'),
  fileSizeExceeded('FILE_SIZE_EXCEEDED'),
  documentAlreadyBookmarked('DOCUMENT_ALREADY_BOOKMARKED'),
  bookmarkNotFound('BOOKMARK_NOT_FOUND'),

  // Review & Comments
  reviewNotFound('REVIEW_NOT_FOUND'),
  invalidRatingValue('INVALID_RATING_VALUE'),
  commentEmpty('COMMENT_EMPTY'),
  reviewAlreadyExists('REVIEW_ALREADY_EXISTS'),
  reviewAccessDenied('REVIEW_ACCESS_DENIED'),

  // Follow
  cannotFollowSelf('CANNOT_FOLLOW_SELF'),
  alreadyFollowed('ALREADY_FOLLOWED'),
  followNotFound('FOLLOW_NOT_FOUND'),

  // Notification
  notificationNotFound('NOTIFICATION_NOT_FOUND'),
  notificationAlreadyRead('NOTIFICATION_ALREADY_READ'),

  // Network / Client
  networkError('NETWORK_ERROR'),
  requestCancelled('REQUEST_CANCELLED'),
  unknown('UNKNOWN');

  final String code;
  const AppErrorCode(this.code);
}

/// Tiện ích chuyển đổi (mapper) mã lỗi (errorCode) từ Backend hoặc hệ thống
/// thành thông báo tiếng Việt thân thiện, rõ ràng cho người dùng.
class ErrorMapper {
  static const Map<String, String> _errorMessages = {
    // Generic Errors
    'SUCCESS': 'Thao tác thành công.',
    'UNCATEGORIZED_EXCEPTION': 'Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.',
    'INVALID_KEY': 'Khóa yêu cầu không hợp lệ.',
    'INVALID_REQUEST': 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin.',
    'RESOURCE_NOT_FOUND': 'Không tìm thấy dữ liệu hoặc tài nguyên yêu cầu.',
    'UNAUTHORIZED': 'Phiên làm việc đã hết hạn hoặc bạn chưa đăng nhập.',
    'FORBIDDEN': 'Bạn không có quyền thực hiện thao tác này.',
    'METHOD_NOT_ALLOWED': 'Phương thức giao tiếp không được hỗ trợ.',

    // User & Auth Errors
    'USER_EXISTED': 'Tài khoản hoặc email này đã tồn tại trong hệ thống.',
    'USER_NOT_EXISTED': 'Không tìm thấy thông tin người dùng.',
    'INVALID_CREDENTIALS': 'Tên đăng nhập hoặc mật khẩu không chính xác.',
    'INVALID_TOKEN': 'Phiên đăng nhập không hợp lệ hoặc đã hết hạn. Vui lòng đăng nhập lại.',
    'REFRESH_TOKEN_EXPIRED': 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.',
    'PASSWORD_NOT_MATCH': 'Mật khẩu không trùng khớp.',
    'WEAK_PASSWORD': 'Mật khẩu quá yếu. Vui lòng nhập tối thiểu 8 ký tự bao gồm chữ và số.',
    'ACCOUNT_LOCKED': 'Tài khoản của bạn đã bị tạm khóa.',
    'ACCOUNT_DISABLED': 'Tài khoản chưa được kích hoạt.',
    'EMAIL_NOT_VERIFIED': 'Email của bạn chưa được xác thực.',

    // Academic Errors
    'ACADEMIC_NOT_FOUND': 'Không tìm thấy thông tin đơn vị đào tạo.',
    'UNIVERSITY_NOT_FOUND': 'Không tìm thấy thông tin trường đại học.',
    'FACULTY_NOT_FOUND': 'Không tìm thấy thông tin khoa.',
    'DEPARTMENT_NOT_FOUND': 'Không tìm thấy thông tin bộ môn.',
    'SUBJECT_NOT_FOUND': 'Không tìm thấy môn học yêu cầu.',
    'DUPLICATE_ACADEMIC_CODE': 'Mã trường hoặc mã môn học này đã tồn tại.',

    // Document & Storage Errors
    'DOCUMENT_NOT_FOUND': 'Không tìm thấy tài liệu yêu cầu.',
    'DOCUMENT_ACCESS_DENIED': 'Tài liệu này ở chế độ riêng tư và bạn không có quyền xem.',
    'FILE_EMPTY': 'Tệp tin tải lên rỗng.',
    'FILE_UPLOAD_FAILED': 'Tải tệp lên thất bại. Vui lòng thử lại.',
    'INVALID_FILE_TYPE': 'Định dạng tệp không hợp lệ (Chỉ hỗ trợ PDF, DOCX, PPTX, JPG, PNG).',
    'FILE_SIZE_EXCEEDED': 'Kích thước tệp vượt quá giới hạn tối đa cho phép.',
    'DOCUMENT_ALREADY_BOOKMARKED': 'Tài liệu này đã có trong danh sách lưu trữ của bạn.',
    'BOOKMARK_NOT_FOUND': 'Không tìm thấy tài liệu trong danh sách lưu trữ.',

    // Review & Rating Errors
    'REVIEW_NOT_FOUND': 'Không tìm thấy bài đánh giá hoặc bình luận này.',
    'INVALID_RATING_VALUE': 'Điểm đánh giá phải nằm trong khoảng từ 1 đến 5 sao.',
    'COMMENT_EMPTY': 'Nội dung bình luận không được để trống.',
    'REVIEW_ALREADY_EXISTS': 'Bạn đã gửi đánh giá cho tài liệu này rồi.',
    'REVIEW_ACCESS_DENIED': 'Bạn không có quyền chỉnh sửa hoặc xóa đánh giá này.',

    // Follow Errors
    'CANNOT_FOLLOW_SELF': 'Bạn không thể tự theo dõi chính mình.',
    'ALREADY_FOLLOWED': 'Bạn đã theo dõi người dùng này rồi.',
    'FOLLOW_NOT_FOUND': 'Không tìm thấy thông tin theo dõi.',

    // Notification Errors
    'NOTIFICATION_NOT_FOUND': 'Không tìm thấy thông báo yêu cầu.',
    'NOTIFICATION_ALREADY_READ': 'Thông báo này đã được đánh dấu là đã đọc.',

    // Network Errors
    'NETWORK_ERROR': 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
    'REQUEST_CANCELLED': 'Yêu cầu đã bị hủy.',
    'UNKNOWN': 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.',

    // Legacy Numeric Codes Mapping (for backward compatibility)
    '1': 'Sai tên đăng nhập hoặc mật khẩu.',
    '2': 'Tên đăng nhập đã tồn tại.',
    '3': 'Email đã tồn tại.',
    '4': 'Không tìm thấy thông tin người dùng.',
    '10': 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.',
    '50': 'Dữ liệu gửi lên không đúng định dạng.',
    '101': 'Yêu cầu không hợp lệ. Thiếu hoặc sai thông tin đầu vào.',
    '102': 'Chưa được xác thực. Vui lòng đăng nhập lại.',
    '103': 'Bạn không có quyền thực hiện hành động này.',
    '104': 'Không tìm thấy dữ liệu yêu cầu.',
    '110': 'Không tìm thấy người dùng.',
    '111': 'Người dùng hoặc email đã tồn tại.',
    '120': 'Token đã hết hạn. Vui lòng đăng nhập lại.',
    '201': 'Không tìm thấy trường đại học.',
    '300': 'Không tìm thấy file.',
    '304': 'Kích thước file vượt quá giới hạn.',
    '309': 'Upload file thất bại.',
    '401': 'Không tìm thấy tài liệu.',
    '500': 'Lỗi hệ thống, máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
  };

  /// Chuyển đổi errorCode (String hoặc int) thành thông báo tiếng Việt
  static String map(dynamic errorCode, {String? defaultMessage}) {
    if (errorCode == null) {
      if (defaultMessage != null && defaultMessage.isNotEmpty) {
        return defaultMessage;
      }
      return _errorMessages['UNCATEGORIZED_EXCEPTION']!;
    }

    final codeStr = errorCode.toString().trim();
    if (codeStr.isEmpty) {
      return defaultMessage ?? _errorMessages['UNCATEGORIZED_EXCEPTION']!;
    }

    if (_errorMessages.containsKey(codeStr)) {
      return _errorMessages[codeStr]!;
    }

    if (defaultMessage != null &&
        defaultMessage.isNotEmpty &&
        defaultMessage != 'Có lỗi xảy ra từ server') {
      return defaultMessage;
    }

    return _errorMessages['UNCATEGORIZED_EXCEPTION']!;
  }

  /// Helper nhanh để lấy message từ errorCode
  static String fromErrorCode(dynamic errorCode) => map(errorCode);
}
