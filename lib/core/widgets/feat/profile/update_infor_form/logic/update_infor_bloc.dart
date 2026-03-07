import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repository/UpdateInforRepository.dart';
import '../domain/usecase/GetSchoolListUseCase.dart';
import '../domain/usecase/get_profile_usecase.dart';
import '../domain/usecase/update_profile_usecase.dart';
import 'update_infor_event.dart';
import 'update_infor_state.dart';

class UpdateInforBloc extends Bloc<UpdateInforEvent, UpdateInforState> {
  late final UpdateInforRepository _repository;

  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final GetSchoolListUseCase _getSchoolListUseCase;

  UpdateInforBloc() : super(UpdateInitial()) {

    _repository = UpdateInforRepositoryImpl();


    _getProfileUseCase = GetProfileUseCase(_repository);
    _updateProfileUseCase = UpdateProfileUseCase(_repository);
    _getSchoolListUseCase = GetSchoolListUseCase(_repository);


    on<LoadUpdateInfor>(_onLoadInfor);
    on<SubmitUpdateInfor>(_onSubmitUpdate);
  }

  Future<void> _onLoadInfor(
      LoadUpdateInfor event, Emitter<UpdateInforState> emit) async {
    emit(UpdateLoading());

    try {
      final profile = await _getProfileUseCase();
      final schoolList = await _getSchoolListUseCase();

      emit(UpdateInforLoaded(profile, schoolList));
    } catch (e) {
      emit(UpdateError(e.toString()));
    }
  }

  Future<void> _onSubmitUpdate(
      SubmitUpdateInfor event, Emitter<UpdateInforState> emit) async {
    emit(UpdateLoading());

    try {
      await _updateProfileUseCase(
        UpdateProfileParams(
          userName: event.userName,
          fullName: event.fullName,
          email: event.email,
          phoneNumber: event.phoneNumber,
          address: event.address,
          gender: event.gender,
          birthDate: event.birthDate,
          school: event.school,
        ),
      );
      emit(UpdateSuccess());
    } catch (e) {
      emit(UpdateError(e.toString()));
    }
  }
}
