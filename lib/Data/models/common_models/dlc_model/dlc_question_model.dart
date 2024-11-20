class DlcQuestionModel {
  int? id;
  String? title;
  String? type;
  dynamic createdBy;
  String? createdAt;
  String? updatedAt;

  DlcQuestionModel(
      {this.id,
      this.title,
      this.type,
      this.createdBy,
      this.createdAt,
      this.updatedAt});

  DlcQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}