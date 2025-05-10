import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum MediaType {
  image,
  video,
}

class ResultsScreen extends StatefulWidget {
  final String mediaPath;
  final MediaType mediaType;

  const ResultsScreen({
    super.key,
    required this.mediaPath,
    required this.mediaType,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _initializeVideoController();
    }
  }

  Future<void> _initializeVideoController() async {
    if (kIsWeb) {
      // For web platform
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaPath),
      );
    } else {
      // For mobile platforms
      _controller = VideoPlayerController.file(
        File(widget.mediaPath),
      );
    }

    try {
      await _controller?.initialize();
      if (mounted) {
        setState(() {});
        _controller?.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildMediaContent() {
    if (widget.mediaType == MediaType.image) {
      if (kIsWeb) {
        // For web platform
        return Image.network(
          widget.mediaPath,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Error loading image'),
            );
          },
        );
      } else {
        // For mobile platforms
        return Image.file(
          File(widget.mediaPath),
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Error loading image'),
            );
          },
        );
      }
    } else {
      // Video content
      if (_controller?.value.isInitialized == true) {
        return AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: _buildMediaContent(),
      ),
    );
  }
}