import '../repository/update_infor_repository.dart';

class UpdateProfileParams {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? gender;
  final DateTime? birthDate;
  final String? school;

  UpdateProfileParams({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.birthDate,
    required this.school,
  });
}

class UpdateProfileUseCase {
  final UpdateInforRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(UpdateProfileParams params) {
    return repository.updateProfile(
      userName: params.userName,
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      address: params.address,
      gender: params.gender,
      birthDate: params.birthDate,
      school: params.school,
    );
  }
}
