import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/web_services/media_service.dart';
import 'media_event.dart';
import 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaService _mediaService;

  MediaBloc({required MediaService mediaService})
      : _mediaService = mediaService,
        super(MediaInitial()) {
    on<UploadMedia>(_onUploadMedia);
    on<MediaSharedUrlReceived>((event, emit) async {
      emit(MediaLoading());
      try {
        final response = await _mediaService.uploadUrl(event.url);
        emit(MediaSuccess(response));
      } catch (e) {
        emit(MediaError(e.toString()));
      }
    });
  }

  Future<void> _onUploadMedia(
    UploadMedia event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    try {
      final response = await _mediaService.uploadMedia(
        file: event.file,
        title: event.title,
        description: event.description,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        emit(MediaSuccess(responseData));
      } else {
        emit(MediaError('Failed to upload media: ${response.statusCode}'));
      }
    } catch (e) {
      emit(MediaError(e.toString()));
    }
  }
} 