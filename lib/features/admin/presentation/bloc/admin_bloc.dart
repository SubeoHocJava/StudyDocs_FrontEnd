import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/admin/domain/repository/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository repository;

  AdminBloc({required this.repository}) : super(AdminInitial()) {
    on<LoadAdminStatsEvent>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadAdminStatsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final total = await repository.getTotalDocuments();
      emit(AdminStatsLoaded(totalDocuments: total));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
