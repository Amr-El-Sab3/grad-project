import 'package:emotion_detection/bloc/auth_bloc/auth_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';
import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/network/web_services/media_service.dart';
import 'package:emotion_detection/network/repository/auth_repo.dart';
import 'package:emotion_detection/network/web_services/collection_service.dart';
import 'package:emotion_detection/routing.dart';
import 'package:emotion_detection/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EmotionsApp(
      appRouter: AppRouter(),
    ),
  );
}

class EmotionsApp extends StatelessWidget {
  final AppRouter appRouter;

  const EmotionsApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository())
            ..add(AutoLoginEvent()),
        ),
        BlocProvider(create: (context) => MediaBloc(mediaService: MediaService() )),
        BlocProvider(create: (context) => CollectionBloc(apiService: CollectionsService())),
      ],
      child: MaterialApp(
        title: 'Emotion Detection',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}