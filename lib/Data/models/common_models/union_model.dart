import 'dart:convert';

class UnionModel{
  final int id;
  final String name;

  UnionModel({required this.id, required this.name});
}

// import 'dart:convert';
//
// class UnionDropdownModel {
//   final String? status;
//   final String? message;
//   final int? statusCode;
//   final Data? data;
//
//   UnionDropdownModel({
//     this.status,
//     this.message,
//     this.statusCode,
//     this.data,
//   });
//
//   factory UnionDropdownModel.fromRawJson(String str) => UnionDropdownModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory UnionDropdownModel.fromJson(Map<String, dynamic> json) => UnionDropdownModel(
//     status: json["status"],
//     message: json["message"],
//     statusCode: json["status_code"],
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "status_code": statusCode,
//     "data": data?.toJson(),
//   };
// }
//
// class Data {
//   final String? status;
//   final List<District>? district;
//
//   Data({
//     this.status,
//     this.district,
//   });
//
//   factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     status: json["status"],
//     district: json["district"] == null ? [] : List<District>.from(json["district"]!.map((x) => District.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "district": district == null ? [] : List<dynamic>.from(district!.map((x) => x.toJson())),
//   };
// }
//
