import 'package:emotion_detection/bloc/auth_bloc/auth_bloc.dart';
import 'package:emotion_detection/network/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: FlutterLogin(



          theme: LoginTheme(
            pageColorLight: Theme.of(context).colorScheme.primary,
            pageColorDark: Theme.of(context).colorScheme.secondary,
            titleStyle: TextStyle(color:Theme.of(context).colorScheme.tertiary,fontFamily: "foda"  ),
            buttonTheme: LoginButtonTheme(backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,),
            cardTheme: CardTheme(color:Theme.of(context).colorScheme.tertiary ),
          ),

          onLogin: (LoginData data) async {
            final bloc = context.read<AuthBloc>();
            bloc.add(LoginEvent(email: data.name, password: data.password));
            final state = bloc.state;
            if (state is AuthSuccess) {
              return null; // No error
            } else if (state is AuthFailure) {
              return state.error; // Return error message
            }
            return null;
          },
          onSignup: (SignupData data) async {
            final bloc = context.read<AuthBloc>();
            bloc.add(RegisterEvent(
              firstName: data.name ?? '',
              lastName: '',
              email: data.name ?? '',
              password: data.password ?? '',
              cPassword: '',
              phone: '',
              dob: '',
            ));
            final state = bloc.state;
            if (state is AuthSuccess) {
              return null; // No error
            } else if (state is AuthFailure) {
              return state.error; // Return error message
            }
            return null;
          },
          onSubmitAnimationCompleted: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
          messages: LoginMessages(
            userHint: 'Email',
            passwordHint: 'Password',
            confirmPasswordHint: 'Confirm Password',
            loginButton: 'LOG IN',
            signupButton: 'REGISTER',
            forgotPasswordButton: 'Forgot Password?',
            recoverPasswordButton: 'RECOVER',
            goBackButton: 'BACK',
          ),

          onRecoverPassword: (String email) async {
            final bloc = context.read<AuthBloc>();
            bloc.add(ForgotPasswordEvent(email: email));
            final state = bloc.state;
            if (state is AuthSuccess) {
              return null; // No error
            } else if (state is AuthFailure) {
              return state.error; // Return error message
            }
            return null;
          },

          additionalSignupFields: const [
            UserFormField(
              keyName: 'phone',
              displayName: 'Phone Number',
              icon: Icon(Icons.phone),
            ),
            UserFormField(
              keyName: 'dob',
              displayName: 'Date of Birth',
              icon: Icon(Icons.calendar_today),
            ),
          ],
          // googleLoginCallback: (String idToken) async {
          //   final bloc = context.read<AuthBloc>();
          //   bloc.add(GoogleLoginEvent(idToken: idToken));
          //   final state = bloc.state;
          //   if (state is AuthSuccess) {
          //     return null; // No error
          //   } else if (state is AuthFailure) {
          //     return state.error; // Return error message
          //   }
          //   return null;
          // },

        ),
      ),
    );
  }
}