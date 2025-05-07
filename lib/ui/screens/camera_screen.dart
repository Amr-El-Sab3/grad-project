import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/network/web_services/media_service.dart';
import 'package:emotion_detection/ui/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emotion_detection/ui/widgets/my_button.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaBloc(mediaRepository: MediaRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Screen'),
        ),
        body: BlocConsumer<MediaBloc, MediaState>(
          listener: (context, state) {
            if (state is NavigateToResultsState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(
                    mediaPath: state.mediaPath,
                    mediaType: state.mediaType,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MediaLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      icon: Icons.camera_alt_outlined,
                      text: "Capture Image",
                      onTap: () {
                        context.read<MediaBloc>().add(CaptureImageEvent());
                      },
                    ),
                    MyButton(
                      icon: Icons.image,
                      text: "Upload Image",
                      onTap: () {
                        context.read<MediaBloc>().add(UploadImageEvent());
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      icon: Icons.video_camera_front_outlined,
                      text: "Capture Video",
                      onTap: () {
                        context.read<MediaBloc>().add(CaptureVideoEvent());
                      },
                    ),
                    MyButton(
                      icon: Icons.video_collection_outlined,
                      text: "Upload Video",
                      onTap: () {
                        context.read<MediaBloc>().add(UploadVideoEvent());
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}