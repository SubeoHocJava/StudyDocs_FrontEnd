import 'package:studydocs/screens/user/library/presentation/library_screen.dart';
import 'package:studydocs/screens/document_detail/presentation/document_detail_screen.dart';

import '../../screens/explore/presentation/explore_screen.dart';
import '../../screens/home/presentation/home_screen.dart';
import '../../screens/notification/presentation/notification_screen.dart';
import '../../screens/profile/presentation/profile_screen.dart';
import '../../screens/user_follow/presentation/screen/user_follow_screen.dart';
import '../../screens/document_upload/presentation/document_upload_screen.dart';
import 'app_route_model.dart';

final List<AppRoute> appRoutes = [
  AppRoute(path: '/home', screen: const HomeScreen()),
  AppRoute(path: '/profile', screen: ProfileScreen()),
  AppRoute(path: '/library', screen: const LibraryScreen()),
  AppRoute(path: '/explore', screen: const ExploreScreen()),
  AppRoute(path: '/notifications', screen: const NotificationScreen()),
  AppRoute(path: '/followers', screen: const UserFollowScreen(initialTab: 0)),
  AppRoute(path: '/following', screen: const UserFollowScreen(initialTab: 1)),
  AppRoute(
    path: '/document/:id',
    screen: const DocumentDetailScreen(documentId: ''),
  ),
  AppRoute(path: '/upload', screen: const DocumentUploadScreen()),
];
