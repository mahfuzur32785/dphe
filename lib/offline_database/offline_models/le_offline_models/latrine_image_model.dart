// class LatrineImageModel{
//   final int id;
//   final int beneficiaryId;
//   final int leId;
//   final int isCompleted;
//   final String photoStep1;
//   final String photoStep2;
//   final String photoStep3;
//   final String photoStep4;
//   final String photoStep5;
//   final dynamic latitude;
//   final dynamic longitude;
//   final dynamic createdAt;
//   final dynamic updatedAt;
//
//   LatrineImageModel({
//     required this.id,
//     required this.beneficiaryId,
//     required this.leId,
//     required this.isCompleted,
//     required this.photoStep1,
//     required this.photoStep2,
//     required this.photoStep3,
//     required this.photoStep4,
//     required this.photoStep5,
//     required this.latitude,
//     required this.longitude,
//     required this.createdAt,
//     required this.updatedAt
// });
//
//
// }

import 'dart:convert';

class LatrineImageModel {
  final int? id;
  final int? beneficiaryId;
  //final int? leId;
  final int? isCompleted;
  final dynamic photoStep1;
  final dynamic photoStep2;
  final dynamic photoStep3;
  final dynamic photoStep4;
  final dynamic photoStep5;
  final dynamic photoStep1sts;
  final dynamic photoStep2sts;
  final dynamic photoStep3sts;
  final dynamic photoStep4sts;
  final dynamic photoStep5sts;
  final String? latitude;
  final String? longitude;
  final String? latitude2;
  final String? longitude2;
  final dynamic createdAt;
  final dynamic updatedAt;

  LatrineImageModel({
    this.id,
    this.beneficiaryId,
    //this.leId,
    this.isCompleted,
    this.photoStep1,
    this.photoStep1sts,
    this.photoStep2,
    this.photoStep2sts,
    this.photoStep3,
    this.photoStep3sts,
    this.photoStep4,
    this.photoStep4sts,
    this.photoStep5,
    this.photoStep5sts,
    this.latitude,
    this.longitude,
    this.latitude2,
    this.longitude2,
    this.createdAt,
    this.updatedAt,
  });

  factory LatrineImageModel.fromRawJson(String str) => LatrineImageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatrineImageModel.fromJson(Map<String, dynamic> json) => LatrineImageModel(
        id: json["id"],
        beneficiaryId: json["beneficiary_id"],
        //leId: json["le_id"],
        isCompleted: json["is_completed"],
        photoStep1: json["photo_step_1"],
        photoStep1sts: json["step_1_sts"],
        photoStep2: json["photo_step_2"],
        photoStep2sts: json["step_2_sts"],
        photoStep3: json["photo_step_3"],
        photoStep3sts: json["step_3_sts"],
        photoStep4: json["photo_step_4"],
        photoStep4sts: json["step_4_sts"],
        photoStep5: json["photo_step_5"],
        photoStep5sts: json["step_5_sts"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        latitude2: json["latitude2"],
        longitude2: json["longitude2"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "beneficiary_id": beneficiaryId,
        //"le_id": leId,
        "is_completed": isCompleted,
        "photo_step_1": photoStep1,
        "step_1_sts": photoStep1sts,
        "photo_step_2": photoStep2,
        "step_2_sts": photoStep2sts,
        "photo_step_3": photoStep3,
        "step_3_sts": photoStep3sts,
        "photo_step_4": photoStep4,
        "step_4_sts": photoStep4sts,
        "photo_step_5": photoStep5,
        "step_5_sts": photoStep5sts,
        "latitude": latitude,
        "longitude": longitude,
        "latitude2": latitude2,
        "longitude2": longitude2,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
