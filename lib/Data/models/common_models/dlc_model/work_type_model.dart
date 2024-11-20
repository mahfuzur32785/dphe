class WorkTypeModel {
  int? id;
  String? title;
  int? componentId;
  int? subComponentId;
  dynamic createdAt;
  dynamic updatedAt;

  WorkTypeModel(
      {this.id,
      this.title,
      this.componentId,
      this.subComponentId,
      this.createdAt,
      this.updatedAt});

  WorkTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    componentId = json['component_id'];
    subComponentId = json['sub_component_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['component_id'] = this.componentId;
    data['sub_component_id'] = this.subComponentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}