import 'package:studydocs/features/notification/domain/repository/notification_repository.dart';

class RegisterFcmTokenUseCase {
  final NotificationRepository repository;

  RegisterFcmTokenUseCase(this.repository);

  Future<void> call(String token) async {
    return await repository.registerFcmToken(token);
  }
}
