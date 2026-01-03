
import '../../user_model.dart';

class RegisterResponse {
  final String status; // success or error
  final UserModel? user;

  RegisterResponse({
    required this.status,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        status: json['status'] ?? '',
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        if (user != null) 'user': user!.toJson(),
      };
}