import 'dart:convert';

class UpazilaDropdownModel {
  final String? status;
  final String? message;
  final int? statusCode;
  final Data? data;

  UpazilaDropdownModel({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  factory UpazilaDropdownModel.fromRawJson(String str) => UpazilaDropdownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpazilaDropdownModel.fromJson(Map<String, dynamic> json) => UpazilaDropdownModel(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": data?.toJson(),
  };
}

class Data {
  final String? status;
  final List<DropdownUpazila>? upazila;

  Data({
    this.status,
    this.upazila,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    upazila: json["upazila"] == null ? [] : List<DropdownUpazila>.from(json["upazila"]!.map((x) => DropdownUpazila.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "upazila": upazila == null ? [] : List<dynamic>.from(upazila!.map((x) => x.toJson())),
  };
}

class DropdownUpazila {
  final int? id;
  final int? districtId;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  DropdownUpazila({
    this.id,
    this.districtId,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory DropdownUpazila.fromRawJson(String str) => DropdownUpazila.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DropdownUpazila.fromJson(Map<String, dynamic> json) => DropdownUpazila(
    id: json["id"],
    districtId: json["district_id"],
    name: json["name"],
    bnName: json["bn_name"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "district_id": districtId,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
