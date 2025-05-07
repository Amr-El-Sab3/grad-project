
class MyRecord {
  final String id;
  final String name;
  final String videoUrl;
  final String graphData;

  MyRecord({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.graphData,
  });

  factory MyRecord.fromJson(Map<String, dynamic> json) {
    return MyRecord(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      videoUrl: json['video_url'] ?? '',
      graphData: json['graph_data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['video_url'] = videoUrl;
    data['graph_data'] = graphData;
    return data;
  }
}