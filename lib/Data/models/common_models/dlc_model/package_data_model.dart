import '../../auth_models/new_user_data_model.dart';


class PackageDataModel {
  List<PData>? data;

  PackageDataModel({this.data});

  PackageDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PData>[];
      json['data'].forEach((v) {
        data!.add( PData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PData {
  int? id;
 dynamic componentId;
  dynamic subComponentId;
  String? title;
  String? description;
  String? economicCode;
  String? economicSubCode;
  dynamic quantity;
  int? unitId;
  String? procurementMethod;
  String? contractApprovingAuthority;
  String? sourceOfFund;
  dynamic contractValueInLac;
  String? tenderInvitationDate;
  String? contractSigningDate;
  String? contractCompletionDate;
  int? districtId;
  int? packageTypeId;
  dynamic packageSubTypeId;
  dynamic totalProgress;
  dynamic createdBy;
  dynamic updatedBy;
 dynamic deletedBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  List<Schemes>? schemes;
  dynamic component;
  PackageType? packageType;
  District? district;
  List<Upazilas>? upazilas;

  PData(
      {this.id,
      this.componentId,
      this.subComponentId,
      this.title,
      this.description,
      this.economicCode,
      this.economicSubCode,
      this.quantity,
      this.unitId,
      this.procurementMethod,
      this.contractApprovingAuthority,
      this.sourceOfFund,
      this.contractValueInLac,
      this.tenderInvitationDate,
      this.contractSigningDate,
      this.contractCompletionDate,
      this.districtId,
      this.packageTypeId,
      this.packageSubTypeId,
      this.totalProgress,
      this.createdBy,
      this.updatedBy,
      this.deletedBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.schemes,
      this.component,
      this.packageType,
      this.district,
      this.upazilas});

  PData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    componentId = json['component_id'];
    subComponentId = json['sub_component_id'];
    title = json['title'];
    description = json['description'];
    economicCode = json['economic_code'];
    economicSubCode = json['economic_sub_code'];
    quantity = json['quantity'];
    unitId = json['unit_id'];
    procurementMethod = json['procurement_method'];
    contractApprovingAuthority = json['contract_approving_authority'];
    sourceOfFund = json['source_of_fund'];
    contractValueInLac = json['contract_value_in_lac'];
    tenderInvitationDate = json['tender_invitation_date'];
    contractSigningDate = json['contract_signing_date'];
    contractCompletionDate = json['contract_completion_date'];
    districtId = json['district_id'];
    packageTypeId = json['package_type_id'];
    packageSubTypeId = json['package_sub_type_id'];
    totalProgress = json['total_progress'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['schemes'] != null) {
      schemes = <Schemes>[];
      json['schemes'].forEach((v) {
        schemes!.add( Schemes.fromJson(v));
      });
    }
    component = json['component'];
    packageType = json['package_type'] != null
        ?  PackageType.fromJson(json['package_type'])
        : null;
    district = json['district'] != null
        ?  District.fromJson(json['district'])
        : null;
    if (json['upazilas'] != null) {
      upazilas = <Upazilas>[];
      json['upazilas'].forEach((v) {
        upazilas!.add( Upazilas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['component_id'] = this.componentId;
    data['sub_component_id'] = this.subComponentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['economic_code'] = this.economicCode;
    data['economic_sub_code'] = this.economicSubCode;
    data['quantity'] = this.quantity;
    data['unit_id'] = this.unitId;
    data['procurement_method'] = this.procurementMethod;
    data['contract_approving_authority'] = this.contractApprovingAuthority;
    data['source_of_fund'] = this.sourceOfFund;
    data['contract_value_in_lac'] = this.contractValueInLac;
    data['tender_invitation_date'] = this.tenderInvitationDate;
    data['contract_signing_date'] = this.contractSigningDate;
    data['contract_completion_date'] = this.contractCompletionDate;
    data['district_id'] = this.districtId;
    data['package_type_id'] = this.packageTypeId;
    data['package_sub_type_id'] = this.packageSubTypeId;
    data['total_progress'] = this.totalProgress;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.schemes != null) {
      data['schemes'] = this.schemes!.map((v) => v.toJson()).toList();
    }
    data['component'] = this.component;
    if (this.packageType != null) {
      data['package_type'] = this.packageType!.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    if (this.upazilas != null) {
      data['upazilas'] = this.upazilas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schemes {
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

  Schemes(
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
      this.updatedAt});

  Schemes.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class PackageType {
  int? id;
  String? title;
  dynamic createdAt;
  dynamic updatedAt;

  PackageType({this.id, this.title, this.createdAt, this.updatedAt});

  PackageType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
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
  Null? createdAt;
  Null? updatedAt;

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

class Upazilas {
  int? id;
  int? districtId;
  String? name;
  String? bnName;
  String? url;
  Null? createdAt;
  Null? updatedAt;
  Pivot? pivot;

  Upazilas(
      {this.id,
      this.districtId,
      this.name,
      this.bnName,
      this.url,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Upazilas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
    bnName = json['bn_name'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? dppPackageId;
  int? upazilaId;

  Pivot({this.dppPackageId, this.upazilaId});

  Pivot.fromJson(Map<String, dynamic> json) {
    dppPackageId = json['dpp_package_id'];
    upazilaId = json['upazila_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dpp_package_id'] = this.dppPackageId;
    data['upazila_id'] = this.upazilaId;
    return data;
  }
}