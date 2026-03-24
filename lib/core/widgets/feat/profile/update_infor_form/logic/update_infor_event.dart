import 'package:equatable/equatable.dart';

abstract class UpdateInforEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUpdateInfor extends UpdateInforEvent {}

class SubmitUpdateInfor extends UpdateInforEvent {
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? gender;
  final DateTime? birthDate;
  final String? school;

  SubmitUpdateInfor({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.birthDate,
    required this.school,
  });

  @override
  List<Object?> get props => [
    userName,
    fullName,
    email,
    phoneNumber,
    address,
    gender,
    birthDate,
    school
  ];
}
