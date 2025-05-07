part of 'media_bloc.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class CaptureImageEvent extends MediaEvent {}

class UploadImageEvent extends MediaEvent {}

class CaptureVideoEvent extends MediaEvent {}

class UploadVideoEvent extends MediaEvent {}