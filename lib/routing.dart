import 'package:emotion_detection/ui/screens/camera_screen.dart';
import 'package:emotion_detection/ui/screens/collections_screen.dart';
import 'package:emotion_detection/ui/screens/home_page.dart';
import 'package:emotion_detection/ui/screens/login_screen.dart';
import 'package:emotion_detection/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {


  Route <dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
       case '/camera':
         return MaterialPageRoute(builder: (_) => const CameraScreen());
       //case '/profile':
         //return MaterialPageRoute(builder: (_) => profileScreen());
       case '/collections':
         return MaterialPageRoute(builder: (_) => const CollectionsPage());
      // case '/records':
       //  return MaterialPageRoute(builder: (_) => recordsScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    default:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    }

  }
}