import 'package:emotion_detection/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _checkInitialMediaAndToken();
  }

  Future<void> _checkInitialMediaAndToken() async {
    // Check for shared media
    final initialMedia = await ReceiveSharingIntent.instance.getInitialMedia();
    // Check for token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      // If token exists, trigger auto-login
      context.read<AuthBloc>().add(AutoLoginEvent());
    } else {
      // If no token, navigate to login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AutoLoginSuccess) {
          // If auto-login succeeds, check if shared media exists
          ReceiveSharingIntent.instance.getInitialMedia().then((initialMedia) {
            if (initialMedia.isNotEmpty) {
              // If shared media exists, navigate to share_handel
              Navigator.of(context).pushReplacementNamed('/shareHandel');
            } else {
              // Otherwise, navigate to home
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        } else if (state is AuthFailure) {
          // If auto-login fails, navigate to login
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
