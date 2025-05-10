import 'dart:io';
import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/bloc/media_bloc/media_event.dart';
import 'package:emotion_detection/bloc/media_bloc/media_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:emotion_detection/network/web_services/media_service.dart';
import 'package:emotion_detection/ui/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emotion_detection/ui/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  Future<void> _handleMediaSelection(BuildContext context, XFile file) async {
    // Navigate to results screen immediately
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          mediaPath: file.path,
          mediaType: file.path.toLowerCase().endsWith('.mp4')
              ? MediaType.video
              : MediaType.image,
        ),
      ),
    );

    // Start upload process
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      final tempFile = File.fromRawPath(bytes);
      final filename = file.name;
      context.read<MediaBloc>().add(
        UploadMedia(
          file: tempFile,
          title: filename,
        ),
      );
    } else {
      // For mobile platforms
      context.read<MediaBloc>().add(
            UploadMedia(
              file: File(file.path),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaBloc(mediaService: MediaService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Screen'),
        ),
        body: BlocConsumer<MediaBloc, MediaState>(
          listener: (context, state) {
            if (state is MediaSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.toString()),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is MediaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!kIsWeb) // Only show camera option on mobile
                      MyButton(
                        icon: Icons.camera_alt_outlined,
                        text: "Capture Image",
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            await _handleMediaSelection(
                              context,
                              image,
                            );
                          }
                        },
                      ),
                    MyButton(
                      icon: Icons.image,
                      text: "Upload Image",
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          await _handleMediaSelection(
                            context,
                            image,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!kIsWeb) // Only show camera option on mobile
                      MyButton(
                        icon: Icons.video_camera_front_outlined,
                        text: "Capture Video",
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? video = await picker.pickVideo(
                            source: ImageSource.camera,
                          );
                          if (video != null) {
                            await _handleMediaSelection(
                              context,
                              video,
                            );
                          }
                        },
                      ),
                    MyButton(
                      icon: Icons.video_collection_outlined,
                      text: "Upload Video",
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? video = await picker.pickVideo(
                          source: ImageSource.gallery,
                        );
                        if (video != null) {
                          await _handleMediaSelection(
                            context,
                            video,
                          );
                        }
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