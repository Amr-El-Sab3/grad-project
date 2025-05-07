class UserProfile {
  UserProfile({
    required this.message,
    required this.success,
    required this.data,
  });

  final String? message;
  final bool? success;
  final Data? data;

  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
      message: json["message"],
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.dob,
    required this.phone,
    this.role,
    this.status,
    this.emailStatus,
    this.collections,
    this.records,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? dob;
  final String? phone;
  final String? role;
  final String? status;
  final String? emailStatus;
  final List<dynamic>? collections;
  final List<dynamic>? records;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      dob: json["DOB"],
      phone: json["phone"],
      role: json["role"],
      status: json["status"],
      emailStatus: json["emailStatus"],
      collections: json["collections"] == null ? [] : List<dynamic>.from(json["collections"]!.map((x) => x)),
      records: json["records"] == null ? [] : List<dynamic>.from(json["records"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
