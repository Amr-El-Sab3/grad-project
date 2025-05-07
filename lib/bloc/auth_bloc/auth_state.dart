part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AutoLoginSuccess extends AuthState {}

class Authenticated extends AuthState{}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}