abstract class CollectionEvent {}

class FetchCollections extends CollectionEvent {}

class CreateCollection extends CollectionEvent {
  final String name;

  CreateCollection( this.name, );
}

class DeleteCollection extends CollectionEvent {
  final String id;

  DeleteCollection(this.id);
}

class FetchAllRecords extends CollectionEvent {}