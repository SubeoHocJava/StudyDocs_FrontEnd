import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_my_qr_usecase.dart';

part 'my_qr_event.dart';
part 'my_qr_state.dart';

class MyQRBloc extends Bloc<MyQREvent, MyQRState> {
  final GetMyQRUseCase getMyQRUseCase;

  MyQRBloc({required this.getMyQRUseCase}) : super(MyQRInitial()) {
    on<MyQRStarted>(_onMyQRStarted);
  }

  Future<void> _onMyQRStarted(MyQRStarted event, Emitter<MyQRState> emit) async {
    emit(MyQRLoading());
    try {
      final qrData = await getMyQRUseCase.execute(event.userId);
      emit(MyQRLoaded(qrData));
    } catch (e) {
      emit(MyQRError(e.toString()));
    }
  }
}
