import 'dart:convert';

class CitizenBeneficiaryModel {
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
  dynamic latitude;
  dynamic longitude;
  dynamic divisionId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  String? wardNo;
  int? statusId;
  int? otpVerified;
  int? isQuestionAnswer;
  int? isScreeningIssueFind;
  int? isScreeningIssueRed;
  int? isScreeningIssueYellow;
  int? isLocationMatch;
  int? isSendBack;
  int? latrineConstructionOnSiteVerification;
  dynamic latrineConstructionVerificationImage;
  dynamic remarks;
  dynamic comments;
  dynamic sendBackFrom;
  dynamic sendBackReason;
  dynamic rejectReason;
  dynamic uploadRemark;
  dynamic junction;
  int? createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime? statusDate;
  int? isTwinPit;
  int? isSmallPiped;
  int? isLargePiped;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic billId;
  dynamic schemeId;
  String? billAmount;
  String? displayName;
  dynamic verifiedBy;
  dynamic rejectedBy;
  dynamic pitLatitude;
  dynamic pitLongitude;
  District? district;
  Union? upazila;
  Union? union;

  CitizenBeneficiaryModel({
    this.id,
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
    this.isScreeningIssueFind,
    this.isScreeningIssueRed,
    this.isScreeningIssueYellow,
    this.isLocationMatch,
    this.isSendBack,
    this.latrineConstructionOnSiteVerification,
    this.latrineConstructionVerificationImage,
    this.remarks,
    this.comments,
    this.sendBackFrom,
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
    this.billAmount,
    this.displayName,
    this.verifiedBy,
    this.rejectedBy,
    this.pitLatitude,
    this.pitLongitude,
    this.district,
    this.upazila,
    this.union,
  });

  factory CitizenBeneficiaryModel.fromRawJson(String str) => CitizenBeneficiaryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CitizenBeneficiaryModel.fromJson(Map<String, dynamic> json) => CitizenBeneficiaryModel(
    id: json["id"],
    sl: json["sl"],
    name: json["name"],
    banglaName: json["bangla_name"],
    fatherOrHusbandName: json["father_or_husband_name"],
    userId: json["user_id"],
    nid: json["nid"],
    phone: json["phone"],
    password: json["password"],
    photo: json["photo"],
    address: json["address"],
    houseName: json["house_name"],
    totalLand: json["total_land"],
    occupation: json["occupation"],
    monthlyIncome: json["monthly_income"],
    familyHead: json["family_head"],
    isFamilyUnderSafetyNetScheme: json["is_family_under_safety_net_scheme"],
    safetyNetSchemeName: json["safety_net_scheme_name"],
    maleMemberInFamily: json["male_member_in_family"],
    femaleMemberInFamily: json["female_member_in_family"],
    isAnyPregnantWomen: json["is_any_pregnant_women"],
    numberOfChildBelow5Year: json["number_of_child_below_5_year"],
    presentLatrineType: json["present_latrine_type"],
    isOnlyResidence: json["is_only_residence"],
    draftExcelId: json["draft_excel_id"],
    upcExcelId: json["upc_excel_id"],
    religion: json["religion"],
    gender: json["gender"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    divisionId: json["division_id"],
    districtId: json["district_id"],
    upazilaId: json["upazila_id"],
    unionId: json["union_id"],
    wardNo: json["ward_no"],
    statusId: json["status_id"],
    otpVerified: json["otp_verified"],
    isQuestionAnswer: json["is_question_answer"],
    isScreeningIssueFind: json["is_screening_issue_find"],
    isScreeningIssueRed: json["is_screening_issue_red"],
    isScreeningIssueYellow: json["is_screening_issue_yellow"],
    isLocationMatch: json["is_location_match"],
    isSendBack: json["is_send_back"],
    latrineConstructionOnSiteVerification: json["latrine_construction_on_site_verification"],
    latrineConstructionVerificationImage: json["latrine_construction_verification_image"],
    remarks: json["remarks"],
    comments: json["comments"],
    sendBackFrom: json["send_back_from"],
    sendBackReason: json["send_back_reason"],
    rejectReason: json["reject_reason"],
    uploadRemark: json["upload_remark"],
    junction: json["junction"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    statusDate: json["status_date"] == null ? null : DateTime.parse(json["status_date"]),
    isTwinPit: json["is_twin_pit"],
    isSmallPiped: json["is_small_piped"],
    isLargePiped: json["is_large_piped"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    billId: json["bill_id"],
    schemeId: json["scheme_id"],
    billAmount: json["bill_amount"],
    displayName: json["display_name"],
    verifiedBy: json["verified_by"],
    rejectedBy: json["rejected_by"],
    pitLatitude: json["pit_latitude"],
    pitLongitude: json["pit_longitude"],
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    upazila: json["upazila"] == null ? null : Union.fromJson(json["upazila"]),
    union: json["union"] == null ? null : Union.fromJson(json["union"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sl": sl,
    "name": name,
    "bangla_name": banglaName,
    "father_or_husband_name": fatherOrHusbandName,
    "user_id": userId,
    "nid": nid,
    "phone": phone,
    "password": password,
    "photo": photo,
    "address": address,
    "house_name": houseName,
    "total_land": totalLand,
    "occupation": occupation,
    "monthly_income": monthlyIncome,
    "family_head": familyHead,
    "is_family_under_safety_net_scheme": isFamilyUnderSafetyNetScheme,
    "safety_net_scheme_name": safetyNetSchemeName,
    "male_member_in_family": maleMemberInFamily,
    "female_member_in_family": femaleMemberInFamily,
    "is_any_pregnant_women": isAnyPregnantWomen,
    "number_of_child_below_5_year": numberOfChildBelow5Year,
    "present_latrine_type": presentLatrineType,
    "is_only_residence": isOnlyResidence,
    "draft_excel_id": draftExcelId,
    "upc_excel_id": upcExcelId,
    "religion": religion,
    "gender": gender,
    "latitude": latitude,
    "longitude": longitude,
    "division_id": divisionId,
    "district_id": districtId,
    "upazila_id": upazilaId,
    "union_id": unionId,
    "ward_no": wardNo,
    "status_id": statusId,
    "otp_verified": otpVerified,
    "is_question_answer": isQuestionAnswer,
    "is_screening_issue_find": isScreeningIssueFind,
    "is_screening_issue_red": isScreeningIssueRed,
    "is_screening_issue_yellow": isScreeningIssueYellow,
    "is_location_match": isLocationMatch,
    "is_send_back": isSendBack,
    "latrine_construction_on_site_verification": latrineConstructionOnSiteVerification,
    "latrine_construction_verification_image": latrineConstructionVerificationImage,
    "remarks": remarks,
    "comments": comments,
    "send_back_from": sendBackFrom,
    "send_back_reason": sendBackReason,
    "reject_reason": rejectReason,
    "upload_remark": uploadRemark,
    "junction": junction,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "status_date": statusDate?.toIso8601String(),
    "is_twin_pit": isTwinPit,
    "is_small_piped": isSmallPiped,
    "is_large_piped": isLargePiped,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "bill_id": billId,
    "scheme_id": schemeId,
    "bill_amount": billAmount,
    "display_name": displayName,
    "verified_by": verifiedBy,
    "rejected_by": rejectedBy,
    "pit_latitude": pitLatitude,
    "pit_longitude": pitLongitude,
    "district": district?.toJson(),
    "upazila": upazila?.toJson(),
    "union": union?.toJson(),
  };
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

class Union {
  int? id;
  int? upazilaId;
  String? name;
  String? bnName;
  String? url;
  dynamic createdAt;
  dynamic updatedAt;
  int? districtId;

  Union({
    this.id,
    this.upazilaId,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.districtId,
  });

  factory Union.fromRawJson(String str) => Union.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Union.fromJson(Map<String, dynamic> json) => Union(
    id: json["id"],
    upazilaId: json["upazila_id"],
    name: json["name"],
    bnName: json["bn_name"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    districtId: json["district_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "upazila_id": upazilaId,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "district_id": districtId,
  };
}
