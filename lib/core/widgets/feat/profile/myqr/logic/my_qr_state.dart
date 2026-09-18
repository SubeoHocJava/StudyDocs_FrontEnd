part of 'my_qr_bloc.dart';

abstract class MyQRState {}

class MyQRInitial extends MyQRState {}

class MyQRLoading extends MyQRState {}

class MyQRLoaded extends MyQRState {
  final String qrData;

  MyQRLoaded(this.qrData);
}

class MyQRError extends MyQRState {
  final String message;

  MyQRError(this.message);
}
