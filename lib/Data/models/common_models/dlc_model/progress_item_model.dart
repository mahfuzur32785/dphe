class ProgressItemModel {
  List<ProgressItem>? data;

  ProgressItemModel({this.data});

  ProgressItemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new ProgressItem.fromJson(v));
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

class ProgressItem {
  int? id;
  String? title;
  String? itemPercent;
  int? schemeTypeId;
  dynamic createdAt;
  dynamic updatedAt;

  ProgressItem(
      {this.id,
      this.title,
      this.itemPercent,
      this.schemeTypeId,
      this.createdAt,
      this.updatedAt});

  ProgressItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    itemPercent = json['item_percent'];
    schemeTypeId = json['scheme_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['item_percent'] = this.itemPercent;
    data['scheme_type_id'] = this.schemeTypeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}