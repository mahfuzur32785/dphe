import 'dart:convert';

import 'package:dphe/Data/models/common_models/district_model.dart';

class BeneficiaryModel {
  List<BeneficiaryDetailsData>? data;

  BeneficiaryModel({this.data});

  BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BeneficiaryDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new BeneficiaryDetailsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BeneficiaryDetailsData {
  int? id;
  dynamic sl;
  String? name;
  dynamic banglaname;
  String? fatherOrHusbandName;
  int? userId;
  dynamic nid;
  String? phone;
  String? type;
  String? password;
  dynamic photo;
  dynamic address;
  String? houseName;
  dynamic totalLand;
  dynamic occupation;
  dynamic monthlyIncome;
  dynamic familyHeadPosition;
  dynamic isFamilyIncludedInSafetyNetScheme;
  dynamic safetyNetSchemeName;
  dynamic maleMemberInFamily;
  dynamic femaleMemberInFamily;
  dynamic isAnyPregnantWomen;
  dynamic numberOfChildBelow5Year;
  dynamic presentLatrineType;
  dynamic isThereAResidence;
  String? religion;
  String? gender;
  Status? status;
  dynamic latitude;
  dynamic longitude;
  dynamic pitLatitude;
  dynamic pitLongitude;
  dynamic divisionId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  dynamic wardId;
  dynamic wardNo;
  int? statusId;
  int? otpVerified;
  int? isQuestionAnswer;
  int? isLocationMatch;
  int? isSendBack;
  dynamic remarks;
  dynamic sendBackReason;
  dynamic rejectReason;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String? statusDate;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  District? district;
  Upazila? upazila;
  Union? union;
  Le? le;
  List<DuplicateHhsModel>? duplicateLeHHs;
  String? junction;

  BeneficiaryDetailsData({
    this.id,
    this.sl,
    this.name,
    this.banglaname,
    this.fatherOrHusbandName,
    this.userId,
    this.nid,
    this.phone,
    this.type,
    this.password,
    this.photo,
    this.address,
    this.houseName,
    this.totalLand,
    this.occupation,
    this.monthlyIncome,
    this.familyHeadPosition,
    this.isFamilyIncludedInSafetyNetScheme,
    this.safetyNetSchemeName,
    this.maleMemberInFamily,
    this.femaleMemberInFamily,
    this.isAnyPregnantWomen,
    this.numberOfChildBelow5Year,
    this.presentLatrineType,
    this.isThereAResidence,
    this.religion,
    this.gender,
    this.status,
    this.latitude,
    this.longitude,
    this.pitLatitude,
    this.pitLongitude,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.unionId,
    this.wardId,
    this.wardNo,
    this.statusId,
    this.otpVerified,
    this.isQuestionAnswer,
    this.isLocationMatch,
    this.isSendBack,
    this.remarks,
    this.sendBackReason,
    this.rejectReason,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.statusDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.district,
    this.upazila,
    this.union,
    this.le,
    this.duplicateLeHHs,
    this.junction,
  });

  BeneficiaryDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sl = json['sl'];
    name = json['name'];
    banglaname = json['bangla_name'];
    fatherOrHusbandName = json['father_or_husband_name'];
    userId = json['user_id'];
    nid = json['nid'];
    phone = json['phone'];
    type = json['type'];
    password = json['password'];
    photo = json['photo'];
    address = json['address'];
    houseName = json['house_name'];
    totalLand = json['total_land'];
    occupation = json['occupation'];
    monthlyIncome = json['monthly_income'];
    familyHeadPosition = json['family_head_position'];
    isFamilyIncludedInSafetyNetScheme = json['is_family_included_in_safety_net_scheme'];
    safetyNetSchemeName = json['safety_net_scheme_name'];
    maleMemberInFamily = json['male_member_in_family'];
    femaleMemberInFamily = json['female_member_in_family'];
    isAnyPregnantWomen = json['is_any_pregnant_women'];
    numberOfChildBelow5Year = json['number_of_child_below_5_year'];
    presentLatrineType = json['present_latrine_type'];
    isThereAResidence = json['is_there_a_residence'];
    religion = json['religion'];
    gender = json['gender'];
    status = json['status'] != null ? new Status.fromJson(json['status']) : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    pitLatitude = json['pit_latitude'];
    pitLongitude = json['pit_longitude'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    wardId = json['ward_id'];
    wardNo = json['ward_no'];
    statusId = json['status_id'];
    otpVerified = json['otp_verified'];
    
    isQuestionAnswer = json['is_question_answer'];
    isLocationMatch = json['is_location_match'];
    isSendBack = json['is_send_back'];
    remarks = json['remarks'];
    sendBackReason = json['send_back_reason'];
    rejectReason = json['reject_reason'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    statusDate = json['status_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    district = json['district'] != null
        ? json['district'] is String
            ? District.fromJson(jsonDecode(json['district']))
            : District.fromJson(json['district'])
        : null;
    upazila = json['upazila'] != null
        ? json['upazila'] is String
            ? Upazila.fromJson(jsonDecode(json['upazila']))
            : Upazila.fromJson(json['upazila'])
        : null;
    union = json['union'] != null
        ? json['union'] is String
            ? Union.fromJson(jsonDecode(json['union']))
            : Union.fromJson(json['union'])
        : null;
    le = json['le'] != null ? Le.fromJson(json['le']) : null;
     if (json['duplicates'] != null) {
      duplicateLeHHs = <DuplicateHhsModel>[];
      json['duplicates'].forEach((v) {
        duplicateLeHHs!.add( DuplicateHhsModel.fromJson(v));
      });
    }
    //duplicateLeHHs =  != null ? DuplicateHhsModel.fromJson(json['duplicate']) : null;
    junction =json['junction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['sl'] = this.sl;
    data['name'] = this.name;
    data['bangla_name'] = this.banglaname;
    data['father_or_husband_name'] = this.fatherOrHusbandName;
    data['user_id'] = this.userId;
    data['nid'] = this.nid;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['password'] = this.password;
    data['photo'] = this.photo;
    data['address'] = this.address;
    data['house_name'] = this.houseName;
    data['total_land'] = this.totalLand;
    data['occupation'] = this.occupation;
    data['monthly_income'] = this.monthlyIncome;
    data['family_head_position'] = this.familyHeadPosition;
    data['is_family_included_in_safety_net_scheme'] = this.isFamilyIncludedInSafetyNetScheme;
    data['safety_net_scheme_name'] = this.safetyNetSchemeName;
    data['male_member_in_family'] = this.maleMemberInFamily;
    data['female_member_in_family'] = this.femaleMemberInFamily;
    data['is_any_pregnant_women'] = this.isAnyPregnantWomen;
    data['number_of_child_below_5_year'] = this.numberOfChildBelow5Year;
    data['present_latrine_type'] = this.presentLatrineType;
    data['is_there_a_residence'] = this.isThereAResidence;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pit_latitude'] = this.pitLatitude;
    data['pit_longitude'] = this.pitLongitude;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['ward_id'] = this.wardId;
    data['ward_no'] = this.wardNo;
    data['status_id'] = this.statusId;
    data['otp_verified'] = this.otpVerified;
    data['is_question_answer'] = this.isQuestionAnswer;
    data['is_location_match'] = this.isLocationMatch;
    data['is_send_back'] = this.isSendBack;
    data['remarks'] = this.remarks;
    data['send_back_reason'] = this.sendBackReason;
    data['reject_reason'] = this.rejectReason;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['status_date'] = this.statusDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    if (this.upazila != null) {
      data['upazila'] = this.upazila!.toJson();
    }
    if (this.union != null) {
      data['union'] = this.union!.toJson();
    }
    if (this.le != null) {
      data['le'] = this.le!.toJson();
    }
    if (this.duplicateLeHHs != null) {
      data['duplicates'] = this.duplicateLeHHs!.map((v) => v.toJson()).toList();
    }
    data['junction']=this.junction;
    return data;
  }
}

class Upazila {
  int? id;
  int? districtId;
  String? name;
  String? bnName;
  String? url;
  dynamic createdAt;
 dynamic updatedAt;

  Upazila({this.id, this.districtId, this.name, this.bnName, this.url, this.createdAt, this.updatedAt});

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

class Union {
  int? id;
  int? upazilaId;
  String? name;
  String? bnName;
  String? url;
  dynamic createdAt;
  dynamic updatedAt;

  Union({this.id, this.upazilaId, this.name, this.bnName, this.url, this.createdAt, this.updatedAt});

  Union.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    upazilaId = json['upazila_id'];
    name = json['name'];
    bnName = json['bn_name'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['upazila_id'] = this.upazilaId;
    data['name'] = this.name;
    data['bn_name'] = this.bnName;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Status {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;

  Status({this.id, this.title, this.createdAt, this.updatedAt});

  Status.fromJson(Map<String, dynamic> json) {
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

class Le {
  int? id;
  String? email;
  String? name;
  String? nid;
  String? phone;
  dynamic tradeLicenseNo;
  dynamic emailVerifiedAt;
  int? terms;
  bool? status;
  String? religion;
  String? gender;
  dynamic photo;
  String? type;
  dynamic designationId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  dynamic wardId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? photoUrl;

  Le(
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
      this.wardId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.photoUrl});

  Le.fromJson(Map<String, dynamic> json) {
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
    wardId = json['ward_id'];
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
    data['ward_id'] = this.wardId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}

class DuplicateHhsModel {
  int? id;
  int? sl;
  String? name;
  String? banglaName;
  String? fatherOrHusbandName;
  int? userId;
  String? nid;
  String? phone;
  String? password;
  dynamic photo;
  dynamic address;
  String? houseName;
  String? totalLand;
  String? occupation;
  String? monthlyIncome;
  String? familyHead;
  String? isFamilyUnderSafetyNetScheme;
  String? safetyNetSchemeName;
  String? maleMemberInFamily;
  String? femaleMemberInFamily;
  String? isAnyPregnantWomen;
  String? numberOfChildBelow5Year;
  String? presentLatrineType;
  String? isOnlyResidence;
  int? draftExcelId;
  dynamic upcExcelId;
  dynamic religion;
  dynamic gender;
  double? latitude;
  double? longitude;
  dynamic divisionId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  String? wardNo;
  int? statusId;
  int? otpVerified;
  int? isQuestionAnswer;
  int? isQuestionAnswerRed;
  int? isQuestionAnswerYellow;
  int? isLocationMatch;
  int? duplicateLatrineId;
  int? isSendBack;
  int? latrineConstructionOnSiteVerification;
  dynamic latrineConstructionVerificationImage;
  dynamic remarks;
  dynamic comments;
  dynamic sendBackReason;
  dynamic rejectReason;
  dynamic uploadRemark;
  String? junction;
  int? createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String? statusDate;
  int? isTwinPit;
  int? isSmallPiped;
  int? isLargePiped;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  dynamic billId;
  dynamic schemeId;
  String? displayName;
  dynamic verifiedBy;
  dynamic rejectedBy;

  DuplicateHhsModel(
      {this.id,
      this.sl,
      this.name,
      this.banglaName,
      this.fatherOrHusbandName,
      this.userId,
      this.nid,
      this.phone,
      this.password,
      this.photo,
      this.address,
      this.houseName,
      this.totalLand,
      this.occupation,
      this.monthlyIncome,
      this.familyHead,
      this.isFamilyUnderSafetyNetScheme,
      this.safetyNetSchemeName,
      this.maleMemberInFamily,
      this.femaleMemberInFamily,
      this.isAnyPregnantWomen,
      this.numberOfChildBelow5Year,
      this.presentLatrineType,
      this.isOnlyResidence,
      this.draftExcelId,
      this.upcExcelId,
      this.religion,
      this.gender,
      this.latitude,
      this.longitude,
      this.divisionId,
      this.districtId,
      this.upazilaId,
      this.unionId,
      this.wardNo,
      this.statusId,
      this.otpVerified,
      this.isQuestionAnswer,
      this.isQuestionAnswerRed,
      this.isQuestionAnswerYellow,
      this.isLocationMatch,
      this.duplicateLatrineId,
      this.isSendBack,
      this.latrineConstructionOnSiteVerification,
      this.latrineConstructionVerificationImage,
      this.remarks,
      this.comments,
      this.sendBackReason,
      this.rejectReason,
      this.uploadRemark,
      this.junction,
      this.createdBy,
      this.updatedBy,
      this.deletedBy,
      this.statusDate,
      this.isTwinPit,
      this.isSmallPiped,
      this.isLargePiped,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.billId,
      this.schemeId,
      this.displayName,
      this.verifiedBy,
      this.rejectedBy});

  DuplicateHhsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sl = json['sl'];
    name = json['name'];
    banglaName = json['bangla_name'];
    fatherOrHusbandName = json['father_or_husband_name'];
    userId = json['user_id'];
    nid = json['nid'];
    phone = json['phone'];
    password = json['password'];
    photo = json['photo'];
    address = json['address'];
    houseName = json['house_name'];
    totalLand = json['total_land'];
    occupation = json['occupation'];
    monthlyIncome = json['monthly_income'];
    familyHead = json['family_head'];
    isFamilyUnderSafetyNetScheme = json['is_family_under_safety_net_scheme'];
    safetyNetSchemeName = json['safety_net_scheme_name'];
    maleMemberInFamily = json['male_member_in_family'];
    femaleMemberInFamily = json['female_member_in_family'];
    isAnyPregnantWomen = json['is_any_pregnant_women'];
    numberOfChildBelow5Year = json['number_of_child_below_5_year'];
    presentLatrineType = json['present_latrine_type'];
    isOnlyResidence = json['is_only_residence'];
    draftExcelId = json['draft_excel_id'];
    upcExcelId = json['upc_excel_id'];
    religion = json['religion'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    wardNo = json['ward_no'];
    statusId = json['status_id'];
    otpVerified = json['otp_verified'];
    isQuestionAnswer = json['is_question_answer'];
    isQuestionAnswerRed = json['is_question_answer_red'];
    isQuestionAnswerYellow = json['is_question_answer_yellow'];
    isLocationMatch = json['is_location_match'];
    duplicateLatrineId = json['duplicate_latrine_id'];
    isSendBack = json['is_send_back'];
    latrineConstructionOnSiteVerification = json['latrine_construction_on_site_verification'];
    latrineConstructionVerificationImage = json['latrine_construction_verification_image'];
    remarks = json['remarks'];
    comments = json['comments'];
    sendBackReason = json['send_back_reason'];
    rejectReason = json['reject_reason'];
    uploadRemark = json['upload_remark'];
    junction = json['junction'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    statusDate = json['status_date'];
    isTwinPit = json['is_twin_pit'];
    isSmallPiped = json['is_small_piped'];
    isLargePiped = json['is_large_piped'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    billId = json['bill_id'];
    schemeId = json['scheme_id'];
    displayName = json['display_name'];
    verifiedBy = json['verified_by'];
    rejectedBy = json['rejected_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sl'] = this.sl;
    data['name'] = this.name;
    data['bangla_name'] = this.banglaName;
    data['father_or_husband_name'] = this.fatherOrHusbandName;
    data['user_id'] = this.userId;
    data['nid'] = this.nid;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['photo'] = this.photo;
    data['address'] = this.address;
    data['house_name'] = this.houseName;
    data['total_land'] = this.totalLand;
    data['occupation'] = this.occupation;
    data['monthly_income'] = this.monthlyIncome;
    data['family_head'] = this.familyHead;
    data['is_family_under_safety_net_scheme'] = this.isFamilyUnderSafetyNetScheme;
    data['safety_net_scheme_name'] = this.safetyNetSchemeName;
    data['male_member_in_family'] = this.maleMemberInFamily;
    data['female_member_in_family'] = this.femaleMemberInFamily;
    data['is_any_pregnant_women'] = this.isAnyPregnantWomen;
    data['number_of_child_below_5_year'] = this.numberOfChildBelow5Year;
    data['present_latrine_type'] = this.presentLatrineType;
    data['is_only_residence'] = this.isOnlyResidence;
    data['draft_excel_id'] = this.draftExcelId;
    data['upc_excel_id'] = this.upcExcelId;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['ward_no'] = this.wardNo;
    data['status_id'] = this.statusId;
    data['otp_verified'] = this.otpVerified;
    data['is_question_answer'] = this.isQuestionAnswer;
    data['is_question_answer_red'] = this.isQuestionAnswerRed;
    data['is_question_answer_yellow'] = this.isQuestionAnswerYellow;
    data['is_location_match'] = this.isLocationMatch;
    data['duplicate_latrine_id'] = this.duplicateLatrineId;
    data['is_send_back'] = this.isSendBack;
    data['latrine_construction_on_site_verification'] = this.latrineConstructionOnSiteVerification;
    data['latrine_construction_verification_image'] = this.latrineConstructionVerificationImage;
    data['remarks'] = this.remarks;
    data['comments'] = this.comments;
    data['send_back_reason'] = this.sendBackReason;
    data['reject_reason'] = this.rejectReason;
    data['upload_remark'] = this.uploadRemark;
    data['junction'] = this.junction;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['status_date'] = this.statusDate;
    data['is_twin_pit'] = this.isTwinPit;
    data['is_small_piped'] = this.isSmallPiped;
    data['is_large_piped'] = this.isLargePiped;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['bill_id'] = this.billId;
    data['scheme_id'] = this.schemeId;
    data['display_name'] = this.displayName;
    data['verified_by'] = this.verifiedBy;
    data['rejected_by'] = this.rejectedBy;
    return data;
  }
}
