import 'dart:convert';

class LatrineImageResponseModel {
  final List<LatrineImageResponse>? data;

  LatrineImageResponseModel({
    this.data,
  });

  factory LatrineImageResponseModel.fromRawJson(String str) => LatrineImageResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatrineImageResponseModel.fromJson(Map<String, dynamic> json) => LatrineImageResponseModel(
    data: json["data"] == null ? [] : List<LatrineImageResponse>.from(json["data"]!.map((x) => LatrineImageResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LatrineImageResponse {
  final int? id;
  final int? beneficiaryId;
  final int? stepId;
  final int? isCompleted;
  final int? outOfLocation;
  final String? photo;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? photoUrl;
  final Step? step;

  LatrineImageResponse({
    this.id,
    this.beneficiaryId,
    this.stepId,
    this.isCompleted,
    this.outOfLocation,
    this.photo,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.step,
  });

  factory LatrineImageResponse.fromRawJson(String str) => LatrineImageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatrineImageResponse.fromJson(Map<String, dynamic> json) => LatrineImageResponse(
    id: json["id"],
    beneficiaryId: json["beneficiary_id"],
    stepId: json["step_id"],
    isCompleted: json["is_completed"],
    outOfLocation: json["out_of_location"],
    photo: json["photo"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    photoUrl: json["photo_url"],
    step: json["step"] == null ? null : Step.fromJson(json["step"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "beneficiary_id": beneficiaryId,
    "step_id": stepId,
    "is_completed": isCompleted,
    "out_of_location": outOfLocation,
    "photo": photo,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "photo_url": photoUrl,
    "step": step?.toJson(),
  };
}

class Step {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Step({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Step.fromRawJson(String str) => Step.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    id: json["id"],
    title: json["title"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
