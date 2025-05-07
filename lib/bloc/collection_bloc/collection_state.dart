import 'package:emotion_detection/network/models/collection_model.dart';
import 'package:emotion_detection/network/models/records_model.dart';
import 'package:equatable/equatable.dart';


abstract class CollectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<Collection> collections;

  CollectionLoaded(this.collections);

  @override
  List<Object?> get props => [collections];
}

class CollectionError extends CollectionState {
  final String message;

  CollectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecordsFetched extends CollectionState {
  final List<MyRecord> records;

  RecordsFetched(this.records);

  @override
  List<Object?> get props => [records];
}