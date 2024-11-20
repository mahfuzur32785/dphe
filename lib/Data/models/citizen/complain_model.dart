import 'dart:convert';

class ComplainModel {
  int? id;
  int? citizenId;
  int? workTypeId;
  dynamic beneficiaryId;
  String? name;
  String? mobile;
  String? address;
  String? subject;
  String? body;
  String? document;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Comment>? comments;

  ComplainModel({
    this.id,
    this.citizenId,
    this.workTypeId,
    this.beneficiaryId,
    this.name,
    this.mobile,
    this.address,
    this.subject,
    this.body,
    this.document,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.comments,
  });

  factory ComplainModel.fromRawJson(String str) => ComplainModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ComplainModel.fromJson(Map<String, dynamic> json) => ComplainModel(
    id: json["id"],
    citizenId: json["citizen_id"],
    workTypeId: json["work_type_id"],
    beneficiaryId: json["beneficiary_id"],
    name: json["name"],
    mobile: json["mobile"],
    address: json["address"],
    subject: json["subject"],
    body: json["body"],
    document: json["document"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "citizen_id": citizenId,
    "work_type_id": workTypeId,
    "beneficiary_id": beneficiaryId,
    "name": name,
    "mobile": mobile,
    "address": address,
    "subject": subject,
    "body": body,
    "document": document,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  int? id;
  int? citizenComplaintId;
  String? comment;
  String? creatorType;
  int? creatorId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    this.id,
    this.citizenComplaintId,
    this.comment,
    this.creatorType,
    this.creatorId,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    citizenComplaintId: json["citizen_complaint_id"],
    comment: json["comment"],
    creatorType: json["creator_type"],
    creatorId: json["creator_id"] is String ? int.parse(json["creator_id"]) : json["creator_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "citizen_complaint_id": citizenComplaintId,
    "comment": comment,
    "creator_type": creatorType,
    "creator_id": creatorId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
