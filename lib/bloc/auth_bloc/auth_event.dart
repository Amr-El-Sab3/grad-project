part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class AutoLoginEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String cPassword;
  final String phone;
  final String dob;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.cPassword,
    required this.phone,
    required this.dob,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class GoogleLoginEvent extends AuthEvent {
  final String idToken;

  GoogleLoginEvent({required this.idToken});
}

class ChangePasswordWithOTPEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  final String cPassword;

  ChangePasswordWithOTPEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.cPassword,
  });
}