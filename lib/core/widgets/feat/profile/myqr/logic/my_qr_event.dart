part of 'my_qr_bloc.dart';

abstract class MyQREvent {}

class MyQRStarted extends MyQREvent {
  final String userId;

  MyQRStarted(this.userId);
}
