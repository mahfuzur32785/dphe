class PackageSchemeModel {
  int? id;
  String? title;
  int? dppPackageId;
  dynamic workTypeId;
  int? districtId;
  int? upazilaId;
  dynamic unionId;
  int? schemeTypeId;
  dynamic description;
  String? localAddress;
  dynamic handoverDocument;
  String? status;
 dynamic anyPendingProgress;
  dynamic comment;
  dynamic totalProgress;
 dynamic createdBy;
 dynamic updatedBy;
 dynamic deletedBy;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? progress;
  Type? type;
  District? district;
  Upazila? upazila;

  PackageSchemeModel(
      {this.id,
      this.title,
      this.dppPackageId,
      this.workTypeId,
      this.districtId,
      this.upazilaId,
      this.unionId,
      this.schemeTypeId,
      this.description,
      this.localAddress,
      this.handoverDocument,
      this.status,
      this.anyPendingProgress,
      this.comment,
      this.totalProgress,
      this.createdBy,
      this.updatedBy,
      this.deletedBy,
      this.createdAt,
      this.updatedAt,
      this.progress,
      this.type,
      this.district,
      this.upazila});

  PackageSchemeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    dppPackageId = json['dpp_package_id'];
    workTypeId = json['work_type_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    schemeTypeId = json['scheme_type_id'];
    description = json['description'];
    localAddress = json['local_address'];
    handoverDocument = json['handover_document'];
    status = json['status'];
    anyPendingProgress = json['any_pending_progress'];
    comment = json['comment'];
    totalProgress = json['total_progress'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['progress'] != null) {
      progress = [];
      json['progress'].forEach((v) {
        progress!.add(v);
      });
    }
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    district = json['district'] != null
        ? new District.fromJson(json['district'])
        : null;
    upazila =
        json['upazila'] != null ? new Upazila.fromJson(json['upazila']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['dpp_package_id'] = this.dppPackageId;
    data['work_type_id'] = this.workTypeId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['scheme_type_id'] = this.schemeTypeId;
    data['description'] = this.description;
    data['local_address'] = this.localAddress;
    data['handover_document'] = this.handoverDocument;
    data['status'] = this.status;
    data['any_pending_progress'] = this.anyPendingProgress;
    data['comment'] = this.comment;
    data['total_progress'] = this.totalProgress;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.progress != null) {
      data['progress'] = this.progress!.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    if (this.upazila != null) {
      data['upazila'] = this.upazila!.toJson();
    }
    return data;
  }
}

class Type {
  int? id;
  String? name;
  dynamic createdAt;
 dynamic updatedAt;

  Type({this.id, this.name, this.createdAt, this.updatedAt});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class District {
  int? id;
  int? divisionId;
  String? name;
  String? bnName;
  String? lat;
  String? lon;
  String? url;
  dynamic createdAt;
  dynamic updatedAt;

  District(
      {this.id,
      this.divisionId,
      this.name,
      this.bnName,
      this.lat,
      this.lon,
      this.url,
      this.createdAt,
      this.updatedAt});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionId = json['division_id'];
    name = json['name'];
    bnName = json['bn_name'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_id'] = this.divisionId;
    data['name'] = this.name;
    data['bn_name'] = this.bnName;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Upazila {
  int? id;
  int? districtId;
  String? name;
  String? bnName;
  String? url;
  Null? createdAt;
  Null? updatedAt;

  Upazila(
      {this.id,
      this.districtId,
      this.name,
      this.bnName,
      this.url,
      this.createdAt,
      this.updatedAt});

  Upazila.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
    bnName = json['bn_name'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district_id'] = this.districtId;
    data['name'] = this.name;
    data['bn_name'] = this.bnName;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}