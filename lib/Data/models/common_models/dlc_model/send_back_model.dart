class SendBackModel {
  int? id;
  int? beneficiaryId;
  int? statusId;
  String? comments;
  int? isResolved;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

  SendBackModel(
      {this.id,
      this.beneficiaryId,
      this.statusId,
      this.comments,
      this.isResolved,
      this.createdBy,
      this.createdAt,
      this.updatedAt});

  SendBackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beneficiaryId = json['beneficiary_id'];
    statusId = json['status_id'];
    comments = json['comments'];
    isResolved = json['is_resolved'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['beneficiary_id'] = this.beneficiaryId;
    data['status_id'] = this.statusId;
    data['comments'] = this.comments;
    data['is_resolved'] = this.isResolved;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}