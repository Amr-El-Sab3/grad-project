import 'package:emotion_detection/network/web_services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<String> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<bool> isUserLoggedIn() async {
    return await _authService.isUserLoggedIn();
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String cPassword,
      String phone,
      String dob) async {
    await _authService.register(firstName, lastName, email, password, cPassword, phone, dob);
  }

  Future<void> verifyAccount(String token) async {
    await _authService.verifyAccount(token);
  }


  Future<void> deleteUser() async {
    await _authService.deleteUser();
  }

  Future<void> updatePassword(String oldPassword, String newPassword, String cPassword) async {
    await _authService.updatePassword(oldPassword, newPassword, cPassword);
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    return await _authService.getUserProfile();
  }

  Future<void> forgetPassword(String email) async {
    await _authService.forgetPassword(email);
  }

  Future<void> changePasswordWithOTP(String email, String otp, String newPassword, String cPassword) async {
    await _authService.changePasswordWithOTP(email, otp, newPassword, cPassword);
  }

  Future<void> googleLogin(String idToken) async {
    await _authService.googleLogin(idToken);
  }

  Future<void> recoverPassword(String email) async {
    await _authService.recoverPassword(email);
  }
}