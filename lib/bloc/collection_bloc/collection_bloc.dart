import 'package:emotion_detection/bloc/collection_bloc/collection_event.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_state.dart';
import 'package:emotion_detection/network/web_services/collection_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionsService apiService;

  CollectionBloc({required this.apiService}) : super(CollectionInitial()) {
    on<FetchCollections>(_onFetchCollections);
    on<CreateCollection>(_onCreateCollection);
    on<DeleteCollection>(_onDeleteCollection);
  }

  Future<void> _onFetchCollections(FetchCollections event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());
    try {
      final collections = await apiService.fetchCollections();
      emit(CollectionLoaded(collections));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onCreateCollection(CreateCollection event, Emitter<CollectionState> emit) async {
    try {
      // Call the API to create the collection
      await apiService.createCollection(event.name);

      // Refresh the list of collections
      final collections = await apiService.fetchCollections();
      emit(CollectionLoaded(collections));

      // Show feedback to the user
      // Future.microtask(() {
      //   ScaffoldMessenger.of(_getScaffoldContext(emit)).showSnackBar(
      //     SnackBar(content: Text('Collection "${event.name}" created successfully!')),
      //   );
      // });

    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onDeleteCollection(
      DeleteCollection event, Emitter<CollectionState> emit) async {
    try {
      await apiService.deleteCollection(event.id);
      // Refresh the list of collections
      final collections = await apiService.fetchCollections();
      emit(CollectionLoaded(collections));
      // Show SnackBar
      // ScaffoldMessenger.of(emit).showSnackBar(
      //   SnackBar(content: Text('Collection deleted successfully!')),
      // );
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

}