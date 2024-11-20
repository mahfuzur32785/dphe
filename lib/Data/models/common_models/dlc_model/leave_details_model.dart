class LeaveDetailsModel {
  List<LeaveData>? data;
  LeaveLinks? links;
  LeaveMeta? meta;

  LeaveDetailsModel({this.data, this.links, this.meta});

  LeaveDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LeaveData>[];
      json['data'].forEach((v) {
        data!.add( LeaveData.fromJson(v));
      });
    }
    links = json['links'] != null ? new LeaveLinks.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new LeaveMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class LeaveData {
  int? id;
  int? userId;
  int? exenId;
  String? leaveType;
  String? fromDate;
  String? toDate;
  String? description;
  int? isForwarded;
  int? isApproved;
  int? isRejected;
  dynamic forwardedBy;
  dynamic approvedBy;
  dynamic rejectedBy;
  dynamic comment;
  int? createdBy;
  dynamic updatedBy;
  String? createdAt;
  String? updatedAt;
  LeaveUser? user;
  LeaveUser? exen;

  LeaveData(
      {this.id,
      this.userId,
      this.exenId,
      this.leaveType,
      this.fromDate,
      this.toDate,
      this.description,
      this.isForwarded,
      this.isApproved,
      this.isRejected,
      this.forwardedBy,
      this.approvedBy,
      this.rejectedBy,
      this.comment,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.exen});

  LeaveData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    exenId = json['exen_id'];
    leaveType = json['leave_type'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    description = json['description'];
    isForwarded = json['is_forwarded'];
    isApproved = json['is_approved'];
    isRejected = json['is_rejected'];
    forwardedBy = json['forwarded_by'];
    approvedBy = json['approved_by'];
    rejectedBy = json['rejected_by'];
    comment = json['comment'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ?  LeaveUser.fromJson(json['user']) : null;
    exen = json['exen'] != null ? LeaveUser.fromJson(json['exen']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['exen_id'] = this.exenId;
    data['leave_type'] = this.leaveType;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['description'] = this.description;
    data['is_forwarded'] = this.isForwarded;
    data['is_approved'] = this.isApproved;
    data['is_rejected'] = this.isRejected;
    data['forwarded_by'] = this.forwardedBy;
    data['approved_by'] = this.approvedBy;
    data['rejected_by'] = this.rejectedBy;
    data['comment'] = this.comment;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.exen != null) {
      data['exen'] = this.exen!.toJson();
    }
    return data;
  }
}

class LeaveUser {
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
 dynamic designationId;
 dynamic districtId;
  dynamic upazilaId;
 dynamic unionId;
  String? createdAt;
  String? updatedAt;
 dynamic deletedAt;
  String? photoUrl;

  LeaveUser(
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

  LeaveUser.fromJson(Map<String, dynamic> json) {
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

class LeaveLinks {
  String? first;
  String? last;
  Null? prev;
  Null? next;

  LeaveLinks({this.first, this.last, this.prev, this.next});

  LeaveLinks.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class LeaveMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Links>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  LeaveMeta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.links,
      this.path,
      this.perPage,
      this.to,
      this.total});

  LeaveMeta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}

