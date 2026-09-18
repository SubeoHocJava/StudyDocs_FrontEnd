import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import 'update_email_state.dart';

class UpdateEmailCubit extends Cubit<UpdateEmailState> {
  final UserRemoteDataSource _userDataSource;

  UpdateEmailCubit({UserRemoteDataSource? userDataSource})
      : _userDataSource = userDataSource ?? UserRemoteDataSourceImpl(),
        super(UpdateEmailInitial());

  Future<void> requestUpdateEmail(String email) async {
    emit(UpdateEmailLoading());
    try {
      await _userDataSource.requestUpdateEmail(email.trim());
      emit(UpdateEmailRequestSuccess(email.trim()));
    } catch (e) {
      emit(UpdateEmailFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> verifyAndUpdateEmail(String token) async {
    emit(UpdateEmailLoading());
    try {
      await _userDataSource.verifyAndUpdateEmail(token.trim());
      emit(UpdateEmailVerifySuccess());
    } catch (e) {
      emit(UpdateEmailFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
