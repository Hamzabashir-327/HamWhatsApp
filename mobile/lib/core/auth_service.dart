import 'dart:async';

/// Set to false once real SMS (Firebase Phone Auth) is connected.
const bool kDemoAuth = true;

abstract class AuthService {
  Future<void> sendOtp(String phone);

  /// Returns true when the code is accepted.
  Future<bool> verifyOtp(String phone, String code);
}

/// Placeholder used until Firebase is connected. No SMS is sent.
/// Any 6-digit code is accepted.
class DemoAuthService implements AuthService {
  @override
  Future<void> sendOtp(String phone) =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<bool> verifyOtp(String phone, String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return code.length == 6;
  }
}

final AuthService authService = DemoAuthService();
