// import 'dart:convert';
//
// class LoginResponseModel {
//   final String? status;
//   final String? message;
//   final int? statusCode;
//   final LoginResponseData? data;
//
//   LoginResponseModel({
//     this.status,
//     this.message,
//     this.statusCode,
//     this.data,
//   });
//
//   factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
//     status: json["status"],
//     message: json["message"],
//     statusCode: json["status_code"],
//     data: json["data"] == null ? null : LoginResponseData.fromJson(json["data"]),
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
// class LoginResponseData {
//   final String? status;
//   final User? user;
//   final String? token;
//
//   LoginResponseData({
//     this.status,
//     this.user,
//     this.token,
//   });
//
//   factory LoginResponseData.fromRawJson(String str) => LoginResponseData.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
//     status: json["status"],
//     user: json["user"] == null ? null : User.fromJson(json["user"]),
//     token: json["token"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "user": user?.toJson(),
//     "token": token,
//   };
// }
//
// class User {
//   final int? id;
//   final String? name;
//   final dynamic email;
//   final String? phone;
//   final String? type;
//   final dynamic nid;
//   final String? religion;
//   final String? gender;
//   final dynamic designationId;
//   final int? divisionId;
//   final int? districtId;
//   final int? upazilaId;
//   final int? unionId;
//   final dynamic wardId;
//   final bool? status;
//   final dynamic designation;
//   final List<String>? role;
//   final List<int>? roleId;
//   final List<dynamic>? permissions;
//
//   User({
//     this.id,
//     this.name,
//     this.email,
//     this.phone,
//     this.type,
//     this.nid,
//     this.religion,
//     this.gender,
//     this.designationId,
//     this.divisionId,
//     this.districtId,
//     this.upazilaId,
//     this.unionId,
//     this.wardId,
//     this.status,
//     this.designation,
//     this.role,
//     this.roleId,
//     this.permissions,
//   });
//
//   factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     name: json["name"],
//     email: json["email"],
//     phone: json["phone"],
//     type: json["type"],
//     nid: json["nid"],
//     religion: json["religion"],
//     gender: json["gender"],
//     designationId: json["designation_id"],
//     divisionId: json["division_id"],
//     districtId: json["district_id"],
//     upazilaId: json["upazila_id"],
//     unionId: json["union_id"],
//     wardId: json["ward_id"],
//     status: json["status"],
//     designation: json["designation"],
//     role: json["role"] == null ? [] : List<String>.from(json["role"]!.map((x) => x)),
//     roleId: json["role_id"] == null ? [] : List<int>.from(json["role_id"]!.map((x) => x)),
//     permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "email": email,
//     "phone": phone,
//     "type": type,
//     "nid": nid,
//     "religion": religion,
//     "gender": gender,
//     "designation_id": designationId,
//     "division_id": divisionId,
//     "district_id": districtId,
//     "upazila_id": upazilaId,
//     "union_id": unionId,
//     "ward_id": wardId,
//     "status": status,
//     "designation": designation,
//     "role": role == null ? [] : List<dynamic>.from(role!.map((x) => x)),
//     "role_id": roleId == null ? [] : List<dynamic>.from(roleId!.map((x) => x)),
//     "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
//   };
// }







/// new model
import 'dart:convert';

import 'package:dphe/Data/models/auth_models/new_user_data_model.dart';

class LoginResponseModel {
  final String? status;
  final String? message;
  final int? statusCode;
  final LoginResponseData? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : LoginResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": data?.toJson(),
  };
}

class LoginResponseData {
  final String? status;
  String? message;
  //final User? user;
  final NewUserDataModel? user;
  final String? token;

  LoginResponseData({
    this.status,
    this.message,
    this.user,
    this.token,
  });

  factory LoginResponseData.fromRawJson(String str) => LoginResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
    status: json["status"],
    message: json["message"],
   // user: json["user"] == null ? null : User.fromJson(json["user"]),
     user: json["user"] == null ? null : NewUserDataModel.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  final int? id;
  final String? name;
  final dynamic email;
  final String? phone;
  final String? type;
  final String? nid;
  final String? religion;
  final String? gender;
  final dynamic designationId;
  final int? divisionId;
  final int? districtId;
  final int? upazilaId;
  final int? unionId;
  final dynamic wardId;
  final bool? status;
  final dynamic designation;
  final Division? division;
  final District? district;
  final List<String>? role;
  final List<int>? roleId;
  final List<dynamic>? permissions;


  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.type,
    this.nid,
    this.religion,
    this.gender,
    this.designationId,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.wardId,
    this.status,
    this.designation,
    this.division,
    this.district,
    this.role,
    this.roleId,
    this.permissions,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    nid: json["nid"],
    religion: json["religion"],
    gender: json["gender"],
    designationId: json["designation_id"],
    divisionId: json["division_id"],
    districtId: json["district_id"],
    upazilaId: json["upazila_id"],
    unionId: json["union_id"],
    wardId: json["ward_id"],
    status: json["status"],
    designation: json["designation"],
    division: json["division"] == null ? null : Division.fromJson(json["division"]),
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    role: json["role"] == null ? [] : List<String>.from(json["role"]!.map((x) => x)),
    roleId: json["role_id"] == null ? [] : List<int>.from(json["role_id"]!.map((x) => x)),
    permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "type": type,
    "nid": nid,
    "religion": religion,
    "gender": gender,
    "designation_id": designationId,
    "division_id": divisionId,
    "district_id": districtId,
    "upazila_id": upazilaId,
    "union_id": unionId,
    "ward_id": wardId,
    "status": status,
    "designation": designation,
    "division": division?.toJson(),
    "district": district?.toJson(),
    "role": role == null ? [] : List<dynamic>.from(role!.map((x) => x)),
    "role_id": roleId == null ? [] : List<dynamic>.from(roleId!.map((x) => x)),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
  };
}

class District {
  final int? id;
  final int? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  District({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory District.fromRawJson(String str) => District.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    divisionId: json["division_id"],
    name: json["name"],
    bnName: json["bn_name"],
    lat: json["lat"],
    lon: json["lon"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "division_id": divisionId,
    "name": name,
    "bn_name": bnName,
    "lat": lat,
    "lon": lon,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Division {
  final int? id;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  Division({
    this.id,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory Division.fromRawJson(String str) => Division.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Division.fromJson(Map<String, dynamic> json) => Division(
    id: json["id"],
    name: json["name"],
    bnName: json["bn_name"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
