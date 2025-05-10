import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:emotion_detection/network/repository/auth_repo.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<AutoLoginEvent>(_onAutoLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<GoogleLoginEvent>(_onGoogleLogin);
    on<ChangePasswordWithOTPEvent>(_onChangePasswordWithOTP);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.email, event.password);
      emit(AuthSuccess('Login successful'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAutoLogin(AutoLoginEvent event, Emitter<AuthState> emit) async {
    try {
      bool isLoggedIn = await _authRepository.isUserLoggedIn();
      if (isLoggedIn) {
        emit(AutoLoginSuccess());
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        event.cPassword,
        event.phone,
        event.dob,
      );
      emit(AuthSuccess('Registration successful'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.forgetPassword(event.email);
      emit(AuthSuccess('Password recovery email sent'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onGoogleLogin(GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.googleLogin(event.idToken);
      emit(AuthSuccess('Google login successful'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onChangePasswordWithOTP(ChangePasswordWithOTPEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.changePasswordWithOTP(
        event.email,
        event.otp,
        event.newPassword,
        event.cPassword,
      );
      emit(AuthSuccess('Password changed successfully'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}