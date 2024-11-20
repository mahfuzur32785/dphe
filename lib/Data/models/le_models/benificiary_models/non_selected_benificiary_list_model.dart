// // import 'dart:convert';
// //
// // class NonSelectedBeneficiaryListModel {
// //   final List<NonSelectedBeneficiaryListData>? data;
// //   final Links? links;
// //   final Meta? meta;
// //
// //   NonSelectedBeneficiaryListModel({
// //     this.data,
// //     this.links,
// //     this.meta,
// //   });
// //
// //   factory NonSelectedBeneficiaryListModel.fromRawJson(String str) => NonSelectedBeneficiaryListModel.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory NonSelectedBeneficiaryListModel.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListModel(
// //     data: json["data"] == null ? [] : List<NonSelectedBeneficiaryListData>.from(json["data"]!.map((x) => NonSelectedBeneficiaryListData.fromJson(x))),
// //     links: json["links"] == null ? null : Links.fromJson(json["links"]),
// //     meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
// //     "links": links?.toJson(),
// //     "meta": meta?.toJson(),
// //   };
// // }
// //
// // class NonSelectedBeneficiaryListData{
// //   final int? id;
// //   final String? name;
// //   final String? phone;
// //   final String? type;
// //   final String? password;
// //   final dynamic address;
// //   final int? nid;
// //   final dynamic photo;
// //   final int? status;
// //   final String? religion;
// //   final String? gender;
// //   final int? latitude;
// //   final int? longitude;
// //   final int? divisionId;
// //   final int? districtId;
// //   final int? upazilaId;
// //   final int? unionId;
// //   final dynamic wardId;
// //   final int? isSelected;
// //   final dynamic createdBy;
// //   final dynamic updatedBy;
// //   final dynamic deletedBy;
// //   final DateTime? createdAt;
// //   final DateTime? updatedAt;
// //   final dynamic deletedAt;
// //   final Division? division;
// //   final District? district;
// //   final Division? upazila;
// //   final Division? union;
// //
// //   NonSelectedBeneficiaryListData({
// //     this.id,
// //     this.name,
// //     this.phone,
// //     this.type,
// //     this.password,
// //     this.address,
// //     this.nid,
// //     this.photo,
// //     this.status,
// //     this.religion,
// //     this.gender,
// //     this.latitude,
// //     this.longitude,
// //     this.divisionId,
// //     this.districtId,
// //     this.upazilaId,
// //     this.unionId,
// //     this.wardId,
// //     this.isSelected,
// //     this.createdBy,
// //     this.updatedBy,
// //     this.deletedBy,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.deletedAt,
// //     this.division,
// //     this.district,
// //     this.upazila,
// //     this.union,
// //   });
// //
// //   factory NonSelectedBeneficiaryListData.fromRawJson(String str) => NonSelectedBeneficiaryListData.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory NonSelectedBeneficiaryListData.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListData(
// //     id: json["id"],
// //     name: json["name"],
// //     phone: json["phone"],
// //     type: json["type"],
// //     password: json["password"],
// //     address: json["address"],
// //     nid: json["nid"],
// //     photo: json["photo"],
// //     status: json["status"],
// //     religion: json["religion"],
// //     gender: json["gender"],
// //     latitude: json["latitude"],
// //     longitude: json["longitude"],
// //     divisionId: json["division_id"],
// //     districtId: json["district_id"],
// //     upazilaId: json["upazila_id"],
// //     unionId: json["union_id"],
// //     wardId: json["ward_id"],
// //     isSelected: json["is_selected"],
// //     createdBy: json["created_by"],
// //     updatedBy: json["updated_by"],
// //     deletedBy: json["deleted_by"],
// //     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
// //     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
// //     deletedAt: json["deleted_at"],
// //     division: json["division"] == null ? null : Division.fromJson(json["division"]),
// //     district: json["district"] == null ? null : District.fromJson(json["district"]),
// //     upazila: json["upazila"] == null ? null : Division.fromJson(json["upazila"]),
// //     union: json["union"] == null ? null : Division.fromJson(json["union"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "name": name,
// //     "phone": phone,
// //     "type": type,
// //     "password": password,
// //     "address": address,
// //     "nid": nid,
// //     "photo": photo,
// //     "status": status,
// //     "religion": religion,
// //     "gender": gender,
// //     "latitude": latitude,
// //     "longitude": longitude,
// //     "division_id": divisionId,
// //     "district_id": districtId,
// //     "upazila_id": upazilaId,
// //     "union_id": unionId,
// //     "ward_id": wardId,
// //     "is_selected": isSelected,
// //     "created_by": createdBy,
// //     "updated_by": updatedBy,
// //     "deleted_by": deletedBy,
// //     "created_at": createdAt?.toIso8601String(),
// //     "updated_at": updatedAt?.toIso8601String(),
// //     "deleted_at": deletedAt,
// //     "division": division?.toJson(),
// //     "district": district?.toJson(),
// //     "upazila": upazila?.toJson(),
// //     "union": union?.toJson(),
// //   };
// // }
// //
// // class District {
// //   final int? id;
// //   final int? divisionId;
// //   final String? name;
// //   final String? bnName;
// //   final String? lat;
// //   final String? lon;
// //   final String? url;
// //   final dynamic createdAt;
// //   final dynamic updatedAt;
// //
// //   District({
// //     this.id,
// //     this.divisionId,
// //     this.name,
// //     this.bnName,
// //     this.lat,
// //     this.lon,
// //     this.url,
// //     this.createdAt,
// //     this.updatedAt,
// //   });
// //
// //   factory District.fromRawJson(String str) => District.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory District.fromJson(Map<String, dynamic> json) => District(
// //     id: json["id"],
// //     divisionId: json["division_id"],
// //     name: json["name"],
// //     bnName: json["bn_name"],
// //     lat: json["lat"],
// //     lon: json["lon"],
// //     url: json["url"],
// //     createdAt: json["created_at"],
// //     updatedAt: json["updated_at"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "division_id": divisionId,
// //     "name": name,
// //     "bn_name": bnName,
// //     "lat": lat,
// //     "lon": lon,
// //     "url": url,
// //     "created_at": createdAt,
// //     "updated_at": updatedAt,
// //   };
// // }
// //
// // class Division {
// //   final int? id;
// //   final String? name;
// //   final String? bnName;
// //   final String? url;
// //   final dynamic createdAt;
// //   final dynamic updatedAt;
// //   final int? upazilaId;
// //   final int? districtId;
// //
// //   Division({
// //     this.id,
// //     this.name,
// //     this.bnName,
// //     this.url,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.upazilaId,
// //     this.districtId,
// //   });
// //
// //   factory Division.fromRawJson(String str) => Division.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory Division.fromJson(Map<String, dynamic> json) => Division(
// //     id: json["id"],
// //     name: json["name"],
// //     bnName: json["bn_name"],
// //     url: json["url"],
// //     createdAt: json["created_at"],
// //     updatedAt: json["updated_at"],
// //     upazilaId: json["upazila_id"],
// //     districtId: json["district_id"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "name": name,
// //     "bn_name": bnName,
// //     "url": url,
// //     "created_at": createdAt,
// //     "updated_at": updatedAt,
// //     "upazila_id": upazilaId,
// //     "district_id": districtId,
// //   };
// // }
// //
// // class Links {
// //   final String? first;
// //   final String? last;
// //   final dynamic prev;
// //   final dynamic next;
// //
// //   Links({
// //     this.first,
// //     this.last,
// //     this.prev,
// //     this.next,
// //   });
// //
// //   factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory Links.fromJson(Map<String, dynamic> json) => Links(
// //     first: json["first"],
// //     last: json["last"],
// //     prev: json["prev"],
// //     next: json["next"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "first": first,
// //     "last": last,
// //     "prev": prev,
// //     "next": next,
// //   };
// // }
// //
// // class Meta {
// //   final int? currentPage;
// //   final int? from;
// //   final int? lastPage;
// //   final List<Link>? links;
// //   final String? path;
// //   final int? perPage;
// //   final int? to;
// //   final int? total;
// //
// //   Meta({
// //     this.currentPage,
// //     this.from,
// //     this.lastPage,
// //     this.links,
// //     this.path,
// //     this.perPage,
// //     this.to,
// //     this.total,
// //   });
// //
// //   factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
// //     currentPage: json["current_page"],
// //     from: json["from"],
// //     lastPage: json["last_page"],
// //     links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
// //     path: json["path"],
// //     perPage: json["per_page"],
// //     to: json["to"],
// //     total: json["total"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "current_page": currentPage,
// //     "from": from,
// //     "last_page": lastPage,
// //     "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
// //     "path": path,
// //     "per_page": perPage,
// //     "to": to,
// //     "total": total,
// //   };
// // }
// //
// // class Link {
// //   final String? url;
// //   final String? label;
// //   final bool? active;
// //
// //   Link({
// //     this.url,
// //     this.label,
// //     this.active,
// //   });
// //
// //   factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));
// //
// //   String toRawJson() => json.encode(toJson());
// //
// //   factory Link.fromJson(Map<String, dynamic> json) => Link(
// //     url: json["url"],
// //     label: json["label"],
// //     active: json["active"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "url": url,
// //     "label": label,
// //     "active": active,
// //   };
// // }
//
//
//
//
// /// new model
// ///
// import 'dart:convert';
//
// class NonSelectedBeneficiaryListModel {
//   final List<NonSelectedBeneficiaryListData>? data;
//   final Links? links;
//   final Meta? meta;
//
//   NonSelectedBeneficiaryListModel({
//     this.data,
//     this.links,
//     this.meta,
//   });
//
//   factory NonSelectedBeneficiaryListModel.fromRawJson(String str) => NonSelectedBeneficiaryListModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory NonSelectedBeneficiaryListModel.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListModel(
//     data: json["data"] == null ? [] : List<NonSelectedBeneficiaryListData>.from(json["data"]!.map((x) => NonSelectedBeneficiaryListData.fromJson(x))),
//     links: json["links"] == null ? null : Links.fromJson(json["links"]),
//     meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//     "links": links?.toJson(),
//     "meta": meta?.toJson(),
//   };
// }
//
// class NonSelectedBeneficiaryListData {
//   final int? id;
//   final String? name;
//   final String? phone;
//   final String? type;
//   final dynamic address;
//   final dynamic nid;
//   final dynamic photo;
//   final dynamic status;
//   final String? religion;
//   final String? gender;
//   final dynamic latitude;
//   final dynamic longitude;
//   final int? divisionId;
//   final int? districtId;
//   final int? upazilaId;
//   final int? unionId;
//   final dynamic wardId;
//   final dynamic userId;
//   final dynamic statusId;
//   final int? otpVerified;
//   final int? isSelected;
//   final int? isApproved;
//   final dynamic createdBy;
//   final dynamic updatedBy;
//   final dynamic deletedBy;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final dynamic deletedAt;
//   final Division? division;
//   final District? district;
//   final Division? upazila;
//   final Division? union;
//   final dynamic user;
//
//   NonSelectedBeneficiaryListData({
//     this.id,
//     this.name,
//     this.phone,
//     this.type,
//     this.address,
//     this.nid,
//     this.photo,
//     this.status,
//     this.religion,
//     this.gender,
//     this.latitude,
//     this.longitude,
//     this.divisionId,
//     this.districtId,
//     this.upazilaId,
//     this.unionId,
//     this.wardId,
//     this.userId,
//     this.statusId,
//     this.otpVerified,
//     this.isSelected,
//     this.isApproved,
//     this.createdBy,
//     this.updatedBy,
//     this.deletedBy,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.division,
//     this.district,
//     this.upazila,
//     this.union,
//     this.user,
//   });
//
//   factory NonSelectedBeneficiaryListData.fromRawJson(String str) => NonSelectedBeneficiaryListData.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory NonSelectedBeneficiaryListData.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListData(
//     id: json["id"],
//     name: json["name"],
//     phone: json["phone"],
//     type: json["type"],
//     address: json["address"],
//     nid: json["nid"],
//     photo: json["photo"],
//     status: json["status"],
//     religion: json["religion"],
//     gender: json["gender"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     divisionId: json["division_id"],
//     districtId: json["district_id"],
//     upazilaId: json["upazila_id"],
//     unionId: json["union_id"],
//     wardId: json["ward_id"],
//     userId: json["user_id"],
//     statusId: json["status_id"],
//     otpVerified: json["otp_verified"],
//     isSelected: json["is_selected"],
//     isApproved: json["is_approved"],
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     deletedBy: json["deleted_by"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     deletedAt: json["deleted_at"],
//     division: json["division"] == null ? null : Division.fromJson(json["division"]),
//     district: json["district"] == null ? null : District.fromJson(json["district"]),
//     upazila: json["upazila"] == null ? null : Division.fromJson(json["upazila"]),
//     union: json["union"] == null ? null : Division.fromJson(json["union"]),
//     user: json["user"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "phone": phone,
//     "type": type,
//     "address": address,
//     "nid": nid,
//     "photo": photo,
//     "status": status,
//     "religion": religion,
//     "gender": gender,
//     "latitude": latitude,
//     "longitude": longitude,
//     "division_id": divisionId,
//     "district_id": districtId,
//     "upazila_id": upazilaId,
//     "union_id": unionId,
//     "ward_id": wardId,
//     "user_id": userId,
//     "status_id": statusId,
//     "otp_verified": otpVerified,
//     "is_selected": isSelected,
//     "is_approved": isApproved,
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "deleted_by": deletedBy,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//     "deleted_at": deletedAt,
//     "division": division?.toJson(),
//     "district": district?.toJson(),
//     "upazila": upazila?.toJson(),
//     "union": union?.toJson(),
//     "user": user,
//   };
// }
//
// class District {
//   final int? id;
//   final int? divisionId;
//   final String? name;
//   final String? bnName;
//   final dynamic lat;
//   final dynamic lon;
//   final String? url;
//   final dynamic createdAt;
//   final dynamic updatedAt;
//
//   District({
//     this.id,
//     this.divisionId,
//     this.name,
//     this.bnName,
//     this.lat,
//     this.lon,
//     this.url,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory District.fromRawJson(String str) => District.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory District.fromJson(Map<String, dynamic> json) => District(
//     id: json["id"],
//     divisionId: json["division_id"],
//     name: json["name"],
//     bnName: json["bn_name"],
//     lat: json["lat"],
//     lon: json["lon"],
//     url: json["url"],
//     createdAt: json["created_at"],
//     updatedAt: json["updated_at"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "division_id": divisionId,
//     "name": name,
//     "bn_name": bnName,
//     "lat": lat,
//     "lon": lon,
//     "url": url,
//     "created_at": createdAt,
//     "updated_at": updatedAt,
//   };
// }
//
// class Division {
//   final int? id;
//   final String? name;
//   final String? bnName;
//   final String? url;
//   final dynamic createdAt;
//   final dynamic updatedAt;
//   final int? upazilaId;
//   final int? districtId;
//
//   Division({
//     this.id,
//     this.name,
//     this.bnName,
//     this.url,
//     this.createdAt,
//     this.updatedAt,
//     this.upazilaId,
//     this.districtId,
//   });
//
//   factory Division.fromRawJson(String str) => Division.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Division.fromJson(Map<String, dynamic> json) => Division(
//     id: json["id"],
//     name: json["name"],
//     bnName: json["bn_name"],
//     url: json["url"],
//     createdAt: json["created_at"],
//     updatedAt: json["updated_at"],
//     upazilaId: json["upazila_id"],
//     districtId: json["district_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "bn_name": bnName,
//     "url": url,
//     "created_at": createdAt,
//     "updated_at": updatedAt,
//     "upazila_id": upazilaId,
//     "district_id": districtId,
//   };
// }
//
// class Links {
//   final String? first;
//   final String? last;
//   final dynamic prev;
//   final dynamic next;
//
//   Links({
//     this.first,
//     this.last,
//     this.prev,
//     this.next,
//   });
//
//   factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Links.fromJson(Map<String, dynamic> json) => Links(
//     first: json["first"],
//     last: json["last"],
//     prev: json["prev"],
//     next: json["next"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "first": first,
//     "last": last,
//     "prev": prev,
//     "next": next,
//   };
// }
//
// class Meta {
//   final int? currentPage;
//   final int? from;
//   final int? lastPage;
//   final List<Link>? links;
//   final String? path;
//   final int? perPage;
//   final int? to;
//   final int? total;
//
//   Meta({
//     this.currentPage,
//     this.from,
//     this.lastPage,
//     this.links,
//     this.path,
//     this.perPage,
//     this.to,
//     this.total,
//   });
//
//   factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
//     currentPage: json["current_page"],
//     from: json["from"],
//     lastPage: json["last_page"],
//     links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
//     path: json["path"],
//     perPage: json["per_page"],
//     to: json["to"],
//     total: json["total"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "current_page": currentPage,
//     "from": from,
//     "last_page": lastPage,
//     "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
//     "path": path,
//     "per_page": perPage,
//     "to": to,
//     "total": total,
//   };
// }
//
// class Link {
//   final String? url;
//   final String? label;
//   final bool? active;
//
//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });
//
//   factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//     url: json["url"],
//     label: json["label"],
//     active: json["active"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "url": url,
//     "label": label,
//     "active": active,
//   };
// }




import 'dart:convert';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';

class NonSelectedBeneficiaryListModel {
  final List<BeneficiaryDetailsData>? data;
  //final List<NonSelectedBeneficiaryListData>? data;
  final Links? links;
  final Meta? meta;

  NonSelectedBeneficiaryListModel({
    this.data,
    this.links,
    this.meta,
  });

  factory NonSelectedBeneficiaryListModel.fromRawJson(String str) => NonSelectedBeneficiaryListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NonSelectedBeneficiaryListModel.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListModel(
      data: json["data"] == null ? [] : List<BeneficiaryDetailsData>.from(json["data"]!.map((x) => BeneficiaryDetailsData.fromJson(x))),
    // data: json["data"] == null ? [] : List<NonSelectedBeneficiaryListData>.from(json["data"]!.map((x) => NonSelectedBeneficiaryListData.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class NonSelectedBeneficiaryListData {
  final int? id;
  final String? name;
  final String? phone;
  final String? type;
  final dynamic address;
  final int? nid;
  final dynamic photo;
  final dynamic status;
  final String? religion;
  final String? gender;
  final dynamic latitude;
  final dynamic longitude;
  final int? divisionId;
  final int? districtId;
  final int? upazilaId;
  final int? unionId;
  final dynamic wardId;
  final dynamic userId;
  final int? statusId;
  final int? otpVerified;
  final int? isQuestionAnswer;
  final int? isLocationMatch;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final Division? division;
  final District? district;
  final Division? upazila;
  final Division? union;
  final String? divisionName;
  final String? districtName;
  final String? upazilaName;
  final String? unionName;
  final dynamic user;

  NonSelectedBeneficiaryListData({
    this.id,
    this.name,
    this.phone,
    this.type,
    this.address,
    this.nid,
    this.photo,
    this.status,
    this.religion,
    this.gender,
    this.latitude,
    this.longitude,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.wardId,
    this.userId,
    this.statusId,
    this.otpVerified,
    this.isQuestionAnswer,
    this.isLocationMatch,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.division,
    this.district,
    this.upazila,
    this.union,
    this.divisionName,
    this.districtName,
    this.upazilaName,
    this.unionName,
    this.user,
  });

  factory NonSelectedBeneficiaryListData.fromRawJson(String str) => NonSelectedBeneficiaryListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NonSelectedBeneficiaryListData.fromJson(Map<String, dynamic> json) => NonSelectedBeneficiaryListData(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    type: json["type"],
    address: json["address"],
    nid: json["nid"],
    photo: json["photo"],
    status: json["status"],
    religion: json["religion"],
    gender: json["gender"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    divisionId: json["division_id"],
    districtId: json["district_id"],
    upazilaId: json["upazila_id"],
    unionId: json["union_id"],
    wardId: json["ward_id"],
    userId: json["user_id"],
    statusId: json["status_id"],
    otpVerified: json["otp_verified"],
    isQuestionAnswer: json["is_question_answer"],
    isLocationMatch: json["is_location_match"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
    division: json["division"] == null ? null : Division.fromJson(json["division"]),
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    upazila: json["upazila"] == null ? null : Division.fromJson(json["upazila"]),
    union: json["union"] == null ? null : Division.fromJson(json["union"]),
    divisionName: json["division_name"],
    districtName: json["district_name"],
    unionName: json["union_name"],
    upazilaName: json["upazila_name"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "type": type,
    "address": address,
    "nid": nid,
    "photo": photo,
    "status": status,
    "religion": religion,
    "gender": gender,
    "latitude": latitude,
    "longitude": longitude,
    "division_id": divisionId,
    "district_id": districtId,
    "upazila_id": upazilaId,
    "union_id": unionId,
    "ward_id": wardId,
    "user_id": userId,
    "status_id": statusId,
    "otp_verified": otpVerified,
    "is_question_answer": isQuestionAnswer,
    "is_location_match": isLocationMatch,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "division": division?.toJson(),
    "district": district?.toJson(),
    "upazila": upazila?.toJson(),
    "union": union?.toJson(),
    "division_name": divisionName,
    "district_name": districtName,
    "upazila_name": upazilaName,
    "union_name": unionName,
    "user": user,
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
  final int? upazilaId;
  final int? districtId;

  Division({
    this.id,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.upazilaId,
    this.districtId,
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
    upazilaId: json["upazila_id"],
    districtId: json["district_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "upazila_id": upazilaId,
    "district_id": districtId,
  };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
