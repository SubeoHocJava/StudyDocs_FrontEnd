import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/features/auth/presentation/widgets/password_field.dart';
import 'package:studydocs/core/error/error_mapper.dart'; //  Import ErrorMapper

import '../../../../core/constants/app_colors.dart';
import 'email_field.dart';
import 'login_button.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({super.key, required this.onBackToLogin});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _otpController = TextEditingController(); //  Added OTP
  final _newPasswordController = TextEditingController(); //  Added Password

  // State
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isOtpSent = false; //  Track Step 2
  bool _isLoading = false;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = 100;
      _isOtpSent = true; // Chuyển sang UI nhập OTP
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  // Bước 1: Gửi yêu cầu OTP
  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        AuthEndpoints.forgotPasswordRequest,
        data: {'email': _emailController.text.trim()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _startTimer();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã gửi mã OTP tới ${_emailController.text}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } on DioException catch (e) {
      //  Sử dụng ErrorMapper để hiển thị lỗi
      int? errorCode;
      String? fallbackMessage;

      // Thử đọc chi tiết lỗi từ backend kể cả khi không có errorCode
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['errorCode'] != null) {
          errorCode = data['errorCode'];
        }
        // Nếu có field "data" chứa string lỗi (đôi khi exception ném ra string vào data)
        if (data['data'] is String) {
          fallbackMessage = data['data'];
        }
        // Hoặc field "message" chuẩn của Spring Boot Error
        if (data['message'] is String) {
          fallbackMessage = data['message'];
        }
      }

      final message = ErrorMapper.map(
        errorCode,
        defaultMessage:
            fallbackMessage ??
            'Lỗi gửi OTP (${e.response?.statusCode ?? 'Unknown'})',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi gửi OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Bước 2: Xác thực & Đổi mật khẩu
  Future<void> _confirmReset() async {
    // Validate OTP & Pass
    if (_otpController.text.isEmpty || _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        AuthEndpoints.forgotPasswordConfirm,
        data: {
          'email': _emailController.text.trim(),
          'otp': _otpController.text.trim(),
          'newPassword': _newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đổi mật khẩu thành công! Vui lòng đăng nhập lại.'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onBackToLogin(); // Quay về login
        }
      }
    } on DioException catch (e) {
      // ✅ Sử dụng ErrorMapper để hiển thị lỗi
      int? errorCode;
      if (e.response?.data is Map && e.response?.data['errorCode'] != null) {
        errorCode = e.response?.data['errorCode'];
      }

      final message = ErrorMapper.map(
        errorCode,
        defaultMessage:
            'Lỗi đổi mật khẩu (${e.response?.statusCode ?? 'Unknown'})',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đổi mật khẩu: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isOtpSent
                ? 'Nhập mã OTP và mật khẩu mới để đặt lại.'
                : 'Nhập email đã đăng ký để nhận mã OTP xác thực.',
            style: TextStyle(color: AppColors.docSmallText, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Field Email (Luôn hiện, disable khi đã gửi)
          EmailField(
            controller: _emailController,
            // enabled: !_isOtpSent // Có thể disable để tránh sửa email
          ),

          // Các field hiện ra sau khi gửi OTP
          if (_isOtpSent) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'Mã OTP',
                prefixIcon: Icon(Icons.lock_clock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: _newPasswordController,
              label: 'Mật khẩu mới',
            ),
          ],

          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_isOtpSent)
            // Nút Confirm
            Column(
              children: [
                LoginButton(
                  onPressed: _confirmReset,
                  label: 'Xác nhận đổi mật khẩu',
                ),
                const SizedBox(height: 10),
                // Send Again logic
                TextButton(
                  onPressed: _remainingSeconds > 0 ? null : _requestOtp,
                  child: Text(
                    _remainingSeconds > 0
                        ? 'Gửi lại OTP sau ${_remainingSeconds}s'
                        : 'Gửi lại mã OTP',
                    style: TextStyle(
                      color:
                          _remainingSeconds > 0
                              ? Colors.grey
                              : AppColors.primary,
                    ),
                  ),
                ),
              ],
            )
          else
            // Nút Send OTP ban đầu
            LoginButton(onPressed: _requestOtp, label: 'Gửi OTP'),

          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: widget.onBackToLogin,
              child: const Text('Quay lại đăng nhập'),
            ),
          ),
        ],
      ),
    );
  }
}
