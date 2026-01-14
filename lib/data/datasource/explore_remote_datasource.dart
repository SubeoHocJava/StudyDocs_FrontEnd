// import 'package:dio/dio.dart';
// import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
//
// import '../../core/constants/api_constants.dart';
// import '../../services/token_storage_service.dart';
//
// /// DataSource cho phần Khám phá.
// /// Đã chuyển sang gọi API thật (Academic Service).
// class ExploreRemoteDataSource {
//   final Dio _dio;
//
//   ExploreRemoteDataSource({Dio? dio})
//     : _dio =
//           dio ??
//           Dio(
//             BaseOptions(
//               baseUrl: ApiConstants.academicBaseUrl,
//               connectTimeout: ApiConstants.connectTimeout,
//               receiveTimeout: ApiConstants.receiveTimeout,
//             ),
//           );
//
//   Future<void> _attachAuthHeader() async {
//     final token = await TokenStorageService().getAuthorizationHeader();
//     if (token != null) {
//       _dio.options.headers['Authorization'] = token;
//     }
//   }
//
//   /// Trường hiện tại của user
//   /// Hiện tại trả về null hoặc logic mock tạm thời nếu cần
//   Future<SchoolEntity?> getCurrentUserSchool() async {
//     // TODO: Implement logic lấy trường của user từ profile hoặc local storage
//     await Future.delayed(const Duration(milliseconds: 200));
//     return null;
//   }
//
//   /// Tìm kiếm trường theo tên từ API
//   Future<List<SchoolEntity>> searchSchools(String query) async {
//     await _attachAuthHeader();
//     try {
//       // Gọi API lấy danh sách trường
//       final response = await _dio.get(ApiConstants.academicUniversitiesFilter);
//
//       if (response.statusCode == 200) {
//         final body = response.data;
//         final List data =
//             body is Map && body['data'] != null ? body['data'] as List : [];
//
//         // Parse JSON sang Entity
//         final allSchools =
//             data
//                 .map<SchoolEntity>((e) {
//                   return SchoolEntity(
//                     id: (e['id'] ?? '').toString(),
//                     name: (e['name'] ?? '').toString(),
//                     shortName: (e['slug'] ?? '').toString(),
//                   );
//                 })
//                 .where((s) => s.name.isNotEmpty)
//                 .toList();
//
//         // Client-side filtering
//         if (query.trim().isEmpty) {
//           return allSchools;
//         }
//
//         final lowerQuery = query.toLowerCase();
//         return allSchools.where((s) {
//           final matchName = s.name.toLowerCase().contains(lowerQuery);
//           final matchShort =
//               s.shortName?.toLowerCase().contains(lowerQuery) ?? false;
//           return matchName || matchShort;
//         }).toList();
//       }
//     } catch (e) {
//       // On error, return empty list
//       return [];
//     }
//     return [];
//   }
// }
