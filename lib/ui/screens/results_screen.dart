import 'dart:io';

import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/ui/widgets/video_player.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final String mediaPath;
  final MediaType mediaType;

  const ResultsScreen({
    super.key,
    required this.mediaPath,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Media Path: $mediaPath'),
            Text('Media Type: ${mediaType.name}'),
            if (mediaType == MediaType.image)
              Image.file(File(mediaPath)),
            if (mediaType == MediaType.video)
              VideoPlayerWidget(videoFile:File(mediaPath)),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}