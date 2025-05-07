part of 'media_bloc.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaFailure extends MediaState {
  final String message;

  const MediaFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NavigateToResultsState extends MediaState {
  final String mediaPath;
  final MediaType mediaType;

  const NavigateToResultsState({
    required this.mediaPath,
    required this.mediaType,
  });

  @override
  List<Object> get props => [mediaPath, mediaType];
}

enum MediaType { image, video }