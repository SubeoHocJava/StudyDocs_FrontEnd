import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String code;
  final String name;

  const CategoryEntity({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}
