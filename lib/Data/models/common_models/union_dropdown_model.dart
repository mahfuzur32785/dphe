import 'dart:convert';

class UnionDropdownModel {
  final String? status;
  final String? message;
  final int? statusCode;
  final UnionDropdownData? data;

  UnionDropdownModel({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  factory UnionDropdownModel.fromRawJson(String str) => UnionDropdownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnionDropdownModel.fromJson(Map<String, dynamic> json) => UnionDropdownModel(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : UnionDropdownData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": data?.toJson(),
  };
}

class UnionDropdownData {
  final String? status;
  final List<DropdownUnion>? union;

  UnionDropdownData({
    this.status,
    this.union,
  });

  factory UnionDropdownData.fromRawJson(String str) => UnionDropdownData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnionDropdownData.fromJson(Map<String, dynamic> json) => UnionDropdownData(
    status: json["status"],
    union: json["union"] == null ? [] : List<DropdownUnion>.from(json["union"]!.map((x) => DropdownUnion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "union": union == null ? [] : List<dynamic>.from(union!.map((x) => x.toJson())),
  };
}


class DropdownUnion {
  final int? id;
  final int? upazilaId;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  DropdownUnion({
    this.id,
    this.upazilaId,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory DropdownUnion.fromRawJson(String str) => DropdownUnion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DropdownUnion.fromJson(Map<String, dynamic> json) => DropdownUnion(
    id: json["id"],
    upazilaId: json["upazila_id"],
    name: json["name"],
    bnName: json["bn_name"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "upazila_id": upazilaId,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
