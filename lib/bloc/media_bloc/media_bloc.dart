import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:emotion_detection/network/repository/media_repo.dart';
import 'package:emotion_detection/network/web_services/media_service.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository _mediaRepository;

  MediaBloc({required MediaRepository mediaRepository})
      : _mediaRepository = mediaRepository,
        super(MediaInitial()) {
    on<CaptureImageEvent>(_onCaptureImage);
    on<UploadImageEvent>(_onUploadImage);
    on<CaptureVideoEvent>(_onCaptureVideo);
    on<UploadVideoEvent>(_onUploadVideo);
  }

  Future<void> _onCaptureImage(
      CaptureImageEvent event, Emitter<MediaState> emit) async {
    emit(MediaLoading());
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await _mediaRepository.uploadFile(File(image.path), 'image');
        emit(NavigateToResultsState(
            mediaPath: image.path, mediaType: MediaType.image));
      } else {
        emit(MediaFailure('No image selected'));
      }
    } catch (e) {
      emit(MediaFailure(e.toString()));
    }
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<MediaState> emit) async {
    emit(MediaLoading());
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _mediaRepository.uploadFile(File(image.path), 'image');
        emit(NavigateToResultsState(
            mediaPath: image.path, mediaType: MediaType.image));
      } else {
        emit(MediaFailure('No image selected'));
      }
    } catch (e) {
      emit(MediaFailure(e.toString()));
    }
  }

  Future<void> _onCaptureVideo(
      CaptureVideoEvent event, Emitter<MediaState> emit) async {
    emit(MediaLoading());
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        await _mediaRepository.uploadFile(File(video.path), 'video');
        emit(NavigateToResultsState(
            mediaPath: video.path, mediaType: MediaType.video));
      } else {
        emit(MediaFailure('No video selected'));
      }
    } catch (e) {
      emit(MediaFailure(e.toString()));
    }
  }

  Future<void> _onUploadVideo(
      UploadVideoEvent event, Emitter<MediaState> emit) async {
    emit(MediaLoading());
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        await _mediaRepository.uploadFile(File(video.path), 'video');
        emit(NavigateToResultsState(
            mediaPath: video.path, mediaType: MediaType.video));
      } else {
        emit(MediaFailure('No video selected'));
      }
    } catch (e) {
      emit(MediaFailure(e.toString()));
    }
  }
}