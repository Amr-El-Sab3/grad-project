import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/ui/screens/camera_screen.dart';
import 'package:emotion_detection/ui/screens/collections_screen.dart';
import 'package:emotion_detection/ui/screens/home_page.dart';
import 'package:emotion_detection/ui/screens/login_screen.dart';
import 'package:emotion_detection/ui/screens/results_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  late String mediaPath;
  late MediaType mediaType;

  Route <dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/results':
         return MaterialPageRoute(builder: (_) => ResultsScreen(mediaPath: mediaPath, mediaType: mediaType,));
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
    default:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    }

  }
}