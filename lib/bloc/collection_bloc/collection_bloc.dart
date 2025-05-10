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
    print('Fetching collections...'); // Debug print
    emit(CollectionLoading());
    try {
      final collections = await apiService.fetchCollections();
      print('Fetched ${collections.length} collections'); // Debug print
      emit(CollectionLoaded(collections));
    } catch (e) {
      print('Error fetching collections: $e'); // Debug print
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onCreateCollection(CreateCollection event, Emitter<CollectionState> emit) async {
    print('CollectionBloc: Creating collection: ${event.name}'); // Debug print
    try {
      // First emit loading state
      print('CollectionBloc: Emitting loading state'); // Debug print
      emit(CollectionLoading());
      
      // Create the collection
      print('CollectionBloc: Calling API to create collection'); // Debug print
      await apiService.createCollection(event.name);
      print('CollectionBloc: Collection created successfully, refreshing list...'); // Debug print
      
      // Refresh the list of collections
      print('CollectionBloc: Fetching updated collections list'); // Debug print
      final collections = await apiService.fetchCollections();
      print('CollectionBloc: Refreshed list has ${collections.length} collections'); // Debug print
      emit(CollectionLoaded(collections));

      // Show feedback to the user
      // Future.microtask(() {
      //   ScaffoldMessenger.of(_getScaffoldContext(emit)).showSnackBar(
      //     SnackBar(content: Text('Collection "${event.name}" created successfully!')),
      //   );
      // });

    } catch (e) {
      print('CollectionBloc: Error creating collection: $e'); // Debug print
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> _onDeleteCollection(DeleteCollection event, Emitter<CollectionState> emit) async {
    print('Deleting collection with ID: ${event.id}'); // Debug print
    try {
      // First emit loading state
      emit(CollectionLoading());
      
      // Delete the collection
      await apiService.deleteCollection(event.id);
      print('Collection deleted successfully, refreshing list...'); // Debug print
      
      // Refresh the list of collections
      final collections = await apiService.fetchCollections();
      print('Refreshed list has ${collections.length} collections'); // Debug print
      emit(CollectionLoaded(collections));
      // Show SnackBar
      // ScaffoldMessenger.of(emit).showSnackBar(
      //   SnackBar(content: Text('Collection deleted successfully!')),
      // );
    } catch (e) {
      print('Error deleting collection: $e'); // Debug print
      emit(CollectionError(e.toString()));
    }
  }

}