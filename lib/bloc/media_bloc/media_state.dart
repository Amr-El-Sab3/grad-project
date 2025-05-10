import 'package:equatable/equatable.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaSuccess extends MediaState {
  final Map<String, dynamic> response;
  const MediaSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class MediaError extends MediaState {
  final String message;
  const MediaError(this.message);

  @override
  List<Object?> get props => [message];
} 