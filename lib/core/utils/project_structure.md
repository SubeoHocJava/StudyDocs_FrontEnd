# 🧭 StudyDocs FrontEnd - Project Structure Overview
---
```
studydocs_frontend/
│
├── android/                     # Cấu hình native cho Android
├── assets/                      # Tài nguyên tĩnh (hình ảnh, icon, font,…)
│   └── icons/
│       └── logo.png
│
├── build/                       # Thư mục build tự động (không chỉnh sửa thủ công)
│
├── lib/
│   ├── core/                    # Các thành phần cốt lõi, dùng chung toàn ứng dụng
│   │   ├── constants/           # Định nghĩa hằng số (màu, icon, text style)
│   │   │   ├── app_colors.dart
│   │   │   └── app_icons.dart
│   │   │
│   │   ├── theme/               # Cấu hình theme toàn cục
│   │   │   └── app_theme.dart
│   │   │
│   │   └── widgets/             # Các widget tái sử dụng (thành phần nhỏ)
│   │       ├── app_icon_button.dart
│   │       ├── bottom_nav.dart
│   │       └── header.dart
│   │
│   ├── features/                             # Các module chức năng (feature modules)
│   │   └── home/                             # Module quản lý màn hình chính (Home)
│   │       ├── data/                         # Tầng dữ liệu: models, data sources, repositories
│   │       │   ├── models/                   # Định nghĩa model (DTO: Data Transfer Object)
│   │       │   │   └── document_model.dart
│   │       │   ├── data_sources/             # Tầng truy cập dữ liệu (API, DB,...)
│   │       │   │   └── home_data_source.dart
│   │       │   └── repositories/             # Tầng trung gian giữa Bloc và DataSource.
│   │       │       └── home_repository.dart
│   │       │
│   │       ├── domain/                       # Tầng nghiệp vụ trừu tượng
│   │       │   ├── entities/                 # Mô tả các đối tượng nghiệp vụ thuần (entity).
│   │       │   │   └── document_entity.dart
│   │       │   └── usecases/                 # Định nghĩa các hành động nghiệp vụ (ví dụ: `GetDocumentsUseCase`).
│   │       │       └── get_documents_usecase.dart
│   │       │
│   │       ├── logic/           # Tầng xử lý logic (Bloc/Cubit)
│   │       │   └── home_bloc.dart
│   │       │
│   │       └── presentation/    # Tầng giao diện (UI)
│   │           ├── component/
│   │           │   └── home_banner.dart
│   │           └── home_screen.dart
│   │
│   └── app.dart                 # File khởi tạo ứng dụng (root widget)
│
└── pubspec.yaml                 # Khai báo dependencies và assets
```

---

## ⚙Kiến trúc BLoC + Clean Architecture

Luồng dữ liệu:
```
UI → Event → Bloc → Repository → DataSource → API/DB
```
và ngược lại:
```
API/DB → DataSource → Repository → Bloc → UI (State)
```

Luồng dữ liệu chi tiết:
```
UI (Screen)
↓ dispatch event
Bloc
↓ call
UseCases (Domain)
↓ call
Repository Interface (Domain)
↓ implements
RepositoryImpl (Data)
↓ call
RemoteDataSource (Data)
↓ uses
DioClient (Core)
↓ HTTP request
API Server
↓ JSON response
DocumentModel.fromJson()
↓ convert
DocumentEntity
↓ emit state
UI updates
```

Ưu điểm:
- Dễ kiểm thử logic.
- Tách biệt rõ UI và nghiệp vụ.
- Dễ mở rộng khi thêm module mới.