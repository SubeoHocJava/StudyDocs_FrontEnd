import 'package:equatable/equatable.dart';

class ChannelEntity extends Equatable {
  final String code;
  final String name;

  const ChannelEntity({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
