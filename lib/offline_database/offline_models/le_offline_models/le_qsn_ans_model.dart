import 'dart:convert';

class LeQsnAnsModel {
  final int? beneficiaryId;
  final String? jsonAns;

  final dynamic lat;
  final dynamic long;
  final dynamic image;
  final int? isSync;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  LeQsnAnsModel({
    this.beneficiaryId,
    this.jsonAns,
    
    this.lat,
    this.long,
    this.image,
    this.isSync,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory LeQsnAnsModel.fromRawJson(String str) => LeQsnAnsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeQsnAnsModel.fromJson(Map<String, dynamic> json) => LeQsnAnsModel(
    beneficiaryId: json["beneficiary_id"],
    jsonAns: json["jsonans"],
  
    lat: json["lat"],
    long: json["long"],
    image: json["image"],
    isSync: json["is_sync"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "beneficiary_id": beneficiaryId,
    "jsonans": jsonAns,
  
    "lat": lat,
    "long": long,
    "image": image,
    "is_sync": isSync,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}
