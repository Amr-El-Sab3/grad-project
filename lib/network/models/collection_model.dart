class Collection {
  final String id;
  final String name;
  final CreatedBy createdBy;
  final List<dynamic> records;
  final DateTime createdAt;
  final DateTime updatedAt;

  Collection({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.records,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to parse JSON into a Collection object
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'], // or json['id'] if you prefer using 'id' instead of '_id'
      name: json['name'],
      createdBy: CreatedBy.fromJson(json['createdBy']),
      records: json['records'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CreatedBy {
  final String id;

  CreatedBy({required this.id});

  // Factory constructor to parse JSON into a CreatedBy object
  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'], // or json['id'] if you prefer using 'id' instead of '_id'
    );
  }
}