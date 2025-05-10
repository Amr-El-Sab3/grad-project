import 'dart:io';
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class UploadMedia extends MediaEvent {
  final File file;
  final String? title;
  final String? description;

  const UploadMedia({
    required this.file,
    this.title,
    this.description,
  });

  @override
  List<Object?> get props => [file, title, description];
}

class UploadMediaWeb extends MediaEvent {
  final List<int> bytes;
  final String filename;

  const UploadMediaWeb({
    required this.bytes,
    required this.filename,
  });

  @override
  List<Object?> get props => [bytes, filename];
}

class MediaSharedUrlReceived extends MediaEvent {
  final String url;
  const MediaSharedUrlReceived(this.url);

  @override
  List<Object?> get props => [url];
} 