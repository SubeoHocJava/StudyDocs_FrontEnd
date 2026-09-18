import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../data/repositories/my_qr_repository_impl.dart';
import '../domain/usecases/get_my_qr_usecase.dart';
import '../logic/my_qr_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class MyQRWidget extends StatelessWidget {
  final String userId;

  const MyQRWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = MyQRRepositoryImpl();
        final usecase = GetMyQRUseCase(repository);
        return MyQRBloc(getMyQRUseCase: usecase)..add(MyQRStarted(userId));
      },
      child: const _MyQRView(),
    );
  }
}

class _MyQRView extends StatelessWidget {
  const _MyQRView();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Mã QR của tôi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.customColor20, // Dark blue tone based on the image
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<MyQRBloc, MyQRState>(
              builder: (context, state) {
                if (state is MyQRLoading || state is MyQRInitial) {
                  return const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is MyQRLoaded) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      data: state.qrData,
                      version: QrVersions.auto,
                      backgroundColor: AppColors.white,
                      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.customColor20),
                      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.customColor20), // Same dark blue for the QR code
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    ),
                  );
                } else if (state is MyQRError) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox(width: 200, height: 200);
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Quét mã này để truy cập hồ sơ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.customColor20,
                ),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
