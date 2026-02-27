# Hướng Dẫn Phát Triển Tính Năng & Gọi API

Tài liệu này hướng dẫn quy trình tiêu chuẩn để thêm một tính năng mới trong dự án, đảm bảo dữ liệu được gọi từ API và hiển thị lên Page đúng cách.

---

## 🏗 Quy Trình Triển Khai (6 Bước)

### Bước 1: Tạo Data Model
Xác định cấu trúc JSON từ backend và tạo Model tương ứng.
- **Vị trí**: `lib/data/model/[feature]/response/`
- **Công cụ**: Sử dụng `factory .fromJson` để map dữ liệu.

```dart
class SubjectResponse {
  final String id;
  final String title;

  SubjectResponse({required this.id, required this.title});

  factory SubjectResponse.fromJson(Map<String, dynamic> json) {
    return SubjectResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
```

### Bước 2: Tạo DataSource
Định nghĩa Interface và Implement việc gọi API bằng `DioClient`.
- **Vị trí**: `lib/data/datasource/`
- **Nhiệm vụ**: Trích xuất trường `data` từ `ApiResponse` và map sang Model.

```dart
// lib/data/datasource/subject_remote_datasource.dart
abstract class SubjectRemoteDataSource {
  Future<List<SubjectResponse>> getSubjects();
}

// lib/data/datasource/subject_remote_datasource_impl.dart
@override
Future<List<SubjectResponse>> getSubjects() async {
  final response = await dioClient.get('/api/subjects');
  final apiResponse = response as ApiResponse<dynamic>;

  if (!apiResponse.isSuccess) {
    throw Exception(apiResponse.errorCode); // Throw errorCode để ErrorMapper xử lý
  }

  final List list = apiResponse.data ?? [];
  return list.map((e) => SubjectResponse.fromJson(e)).toList();
}
```

### Bước 3: Tạo Repository
Điều phối dữ liệu giữa Local và Remote.
- **Vị trí**: `lib/features/[feature]/domain/repositories/`
- **Nhiệm vụ**: Gọi DataSource, xử lý logic dọn dẹp (cleanup) nếu cần.

### Bước 4: Tạo UseCase
Mỗi UseCase đại diện cho một hành động của người dùng.
- **Vị trí**: `lib/features/[feature]/domain/usecases/`

```dart
class GetSubjectsUseCase {
  final SubjectRepository repository;
  GetSubjectsUseCase(this.repository);

  Future<List<SubjectResponse>> call() => repository.getSubjects();
}
```

### Bước 5: Viết BLoC / Cubit
Xử lý trạng thái (State) và sự kiện (Event).
- **Vị trí**: `lib/features/[feature]/presentation/bloc/`
- **Mapping Lỗi**: Sử dụng `ErrorMapper` trong khối `catch`.

```dart
try {
  final data = await getSubjectsUseCase();
  emit(LoadSuccess(data));
} catch (e) {
  final msg = ErrorMapper.fromErrorCode(extractCode(e));
  emit(LoadFailure(msg));
}
```

### Bước 6: Tích hợp vào Page (UI)
Sử dụng `BlocBuilder` hoặc `BlocListener` để hiển thị dữ liệu.

---

## 💡 Lưu Ý Quan Trọng

### 1. Cách Map dữ liệu "Sạch"
Luôn bọc lời gọi `.fromJson()` trong kiểm tra `apiResponse.isSuccess` và `apiResponse.data != null`.

### 2. Xử lý Lỗi (Error Handling)
- **Backend Lỗi**: Trả về `errorCode` dạng số/chuỗi. DataSource throw mã này.
- **Frontend Hiển Thị**: BLoC nhận mã này -> Gọi `ErrorMapper.map(code)` -> Trả về câu thông báo tiếng Việt cho UI.

### 3. Header & Token
- Không cần thủ công thêm Token vào Header cho các API Private. `ApiInterceptor` đã tự động làm việc này.
- Đối với API Public (Login/Register), hãy đảm bảo đã liệt kê path vào `publicPaths` trong `ApiInterceptor`.

### 4. Dữ liệu rỗng (Null Safety)
Sử dụng toán tử `??` trong hàm `fromJson` để tránh lỗi `Null check operator used on a null value`.
- Đúng: `json['name'] ?? ''`
- Sai: `json['name']!`

---
Tài liệu này áp dụng cho kiến trúc Feature-based + BLoC hiện tại của dự án.
# Hướng Dẫn Phát Triển Tính Năng & Gọi API

Tài liệu này hướng dẫn quy trình tiêu chuẩn để thêm một tính năng mới trong dự án, đảm bảo dữ liệu được gọi từ API và hiển thị lên Page đúng cách.

---

## 🏗 Quy Trình Triển Khai (6 Bước)

### Bước 1: Tạo Data Model
Xác định cấu trúc JSON từ backend và tạo Model tương ứng.
- **Vị trí**: `lib/data/model/[feature]/response/`
- **Công cụ**: Sử dụng `factory .fromJson` để map dữ liệu.

```dart
class SubjectResponse {
  final String id;
  final String title;

  SubjectResponse({required this.id, required this.title});

  factory SubjectResponse.fromJson(Map<String, dynamic> json) {
    return SubjectResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
```

### Bước 2: Tạo DataSource
Định nghĩa Interface và Implement việc gọi API bằng `DioClient`.
- **Vị trí**: `lib/data/datasource/`
- **Nhiệm vụ**: Trích xuất trường `data` từ `ApiResponse` và map sang Model.

```dart
// lib/data/datasource/subject_remote_datasource.dart
abstract class SubjectRemoteDataSource {
  Future<List<SubjectResponse>> getSubjects();
}

// lib/data/datasource/subject_remote_datasource_impl.dart
@override
Future<List<SubjectResponse>> getSubjects() async {
  final response = await dioClient.get('/api/subjects');
  final apiResponse = response as ApiResponse<dynamic>;

  if (!apiResponse.isSuccess) {
    throw Exception(apiResponse.errorCode); // Throw errorCode để ErrorMapper xử lý
  }

  final List list = apiResponse.data ?? [];
  return list.map((e) => SubjectResponse.fromJson(e)).toList();
}
```

### Bước 3: Tạo Repository
Điều phối dữ liệu giữa Local và Remote.
- **Vị trí**: `lib/features/[feature]/domain/repositories/`
- **Nhiệm vụ**: Gọi DataSource, xử lý logic dọn dẹp (cleanup) nếu cần.

### Bước 4: Tạo UseCase
Mỗi UseCase đại diện cho một hành động của người dùng.
- **Vị trí**: `lib/features/[feature]/domain/usecases/`

```dart
class GetSubjectsUseCase {
  final SubjectRepository repository;
  GetSubjectsUseCase(this.repository);

  Future<List<SubjectResponse>> call() => repository.getSubjects();
}
```

### Bước 5: Viết BLoC / Cubit
Xử lý trạng thái (State) và sự kiện (Event).
- **Vị trí**: `lib/features/[feature]/presentation/bloc/`
- **Mapping Lỗi**: Sử dụng `ErrorMapper` trong khối `catch`.

```dart
try {
  final data = await getSubjectsUseCase();
  emit(LoadSuccess(data));
} catch (e) {
  final msg = ErrorMapper.fromErrorCode(extractCode(e));
  emit(LoadFailure(msg));
}
```

### Bước 6: Tích hợp vào Page (UI)
Sử dụng `BlocBuilder` hoặc `BlocListener` để hiển thị dữ liệu.

---

## 💡 Lưu Ý Quan Trọng

### 1. Cách Map dữ liệu "Sạch"
Luôn bọc lời gọi `.fromJson()` trong kiểm tra `apiResponse.isSuccess` và `apiResponse.data != null`.

### 2. Xử lý Lỗi (Error Handling)
- **Backend Lỗi**: Trả về `errorCode` dạng số/chuỗi. DataSource throw mã này.
- **Frontend Hiển Thị**: BLoC nhận mã này -> Gọi `ErrorMapper.map(code)` -> Trả về câu thông báo tiếng Việt cho UI.

### 3. Header & Token
- Không cần thủ công thêm Token vào Header cho các API Private. `ApiInterceptor` đã tự động làm việc này.
- Đối với API Public (Login/Register), hãy đảm bảo đã liệt kê path vào `publicPaths` trong `ApiInterceptor`.

### 4. Dữ liệu rỗng (Null Safety)
Sử dụng toán tử `??` trong hàm `fromJson` để tránh lỗi `Null check operator used on a null value`.
- Đúng: `json['name'] ?? ''`
- Sai: `json['name']!`

---
Tài liệu này áp dụng cho kiến trúc Feature-based + BLoC hiện tại của dự án.
