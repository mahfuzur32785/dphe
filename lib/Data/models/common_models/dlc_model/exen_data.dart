class ExenDataModel {
  String? status;
  int? statusCode;
  List<ExenData>? data;

  ExenDataModel({this.status, this.statusCode, this.data});

  ExenDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <ExenData>[];
      json['data'].forEach((v) {
        data!.add( ExenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExenData {
  int? id;
  String? email;
  String? name;
  String? nid;
 dynamic phone;
 dynamic tradeLicenseNo;
 dynamic emailVerifiedAt;
  int? terms;
  bool? status;
  dynamic religion;
 dynamic gender;
  dynamic photo;
  String? type;
  int? designationId;
 dynamic districtId;
  dynamic upazilaId;
 dynamic unionId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? photoUrl;

  ExenData(
      {this.id,
      this.email,
      this.name,
      this.nid,
      this.phone,
      this.tradeLicenseNo,
      this.emailVerifiedAt,
      this.terms,
      this.status,
      this.religion,
      this.gender,
      this.photo,
      this.type,
      this.designationId,
      this.districtId,
      this.upazilaId,
      this.unionId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.photoUrl});

  ExenData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    nid = json['nid'];
    phone = json['phone'];
    tradeLicenseNo = json['trade_license_no'];
    emailVerifiedAt = json['email_verified_at'];
    terms = json['terms'];
    status = json['status'];
    religion = json['religion'];
    gender = json['gender'];
    photo = json['photo'];
    type = json['type'];
    designationId = json['designation_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['nid'] = this.nid;
    data['phone'] = this.phone;
    data['trade_license_no'] = this.tradeLicenseNo;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['terms'] = this.terms;
    data['status'] = this.status;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    data['photo'] = this.photo;
    data['type'] = this.type;
    data['designation_id'] = this.designationId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}