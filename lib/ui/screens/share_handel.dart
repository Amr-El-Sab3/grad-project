import 'dart:io';

import 'package:emotion_detection/bloc/media_bloc/media_bloc.dart';
import 'package:emotion_detection/bloc/media_bloc/media_event.dart';
import 'package:emotion_detection/bloc/media_bloc/media_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:video_player/video_player.dart';
import 'package:emotion_detection/bloc/auth_bloc/auth_bloc.dart';

class shareHandel extends StatefulWidget {
  @override
  _shareHandelState createState() => _shareHandelState();
}

class _shareHandelState extends State<shareHandel> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        print(_sharedFiles.map((f) => f.toMap()));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        print(_sharedFiles.map((f) => f.toMap()));

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared Media')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return BlocBuilder<MediaBloc, MediaState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 250,
                        child: _sharedFiles != null && _sharedFiles!.isNotEmpty
                            ? _buildMediaPreview(_sharedFiles!)
                            : Center(child: Text('No media or URL shared')),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: _buildResponseSection(state),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please log in to upload media'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login screen
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: Text('Go to Login'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMediaPreview(List<SharedMediaFile> files) {
    final file = files.first;
    if (file.type == SharedMediaType.image) {
      return Image.file(File(file.path));
    } else if (file.type == SharedMediaType.video) {
      return VideoPlayerWidget(filePath: file.path);
    }
    return Center(child: Text('Unsupported media type'));
  }

  Widget _buildUrlPreview(String url) {
    // TODO: Add logic for image/video/YouTube preview if desired
    return Center(child: Text(url, style: TextStyle(fontSize: 16)));
  }

  Widget _buildResponseSection(MediaState state) {
    if (state is MediaLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is MediaError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${state.message}', style: TextStyle(color: Colors.red)),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (_sharedFiles != null && _sharedFiles!.isNotEmpty) {
                final file = File(_sharedFiles!.first.path);
                context.read<MediaBloc>().add(UploadMedia(file: file));

              }
            },
            child: Text('Retry'),
          ),
        ],
      );
    } else if (state is MediaSuccess) {
      final record = state.response['record'];
      if (record == null) return Center(child: Text('No record data'));
      final emotions = List<String>.from(record['emotions']);
      final times = List<double>.from(record['times'].map((e) => e.toDouble()));
      return _buildLineChart(emotions, times);
    }
    return Center(child: Text('Share media or a URL to get started'));
  }

  Widget _buildLineChart(List<String> emotions, List<double> times) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < emotions.length) {
                    return Text(emotions[idx], style: TextStyle(fontSize: 10));
                  }
                  return Text('');
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                times.length,
                (i) => FlSpot(i.toDouble(), times[i]),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String filePath;
  const VideoPlayerWidget({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}