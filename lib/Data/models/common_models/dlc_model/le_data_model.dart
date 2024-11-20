class StatusWiseLeHousehldModel {
  List<StswiseLeData>? data;

  StatusWiseLeHousehldModel({this.data});

  StatusWiseLeHousehldModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StswiseLeData>[];
      json['data'].forEach((v) {
        data!.add(new StswiseLeData.fromJson(v));
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

class StswiseLeData {
  Le? le;
  List<Statuses>? statuses;

  StswiseLeData({this.le, this.statuses});

  StswiseLeData.fromJson(Map<String, dynamic> json) {
    le = json['le'] != null ? new Le.fromJson(json['le']) : null;
    if (json['statuses'] != null) {
      statuses = <Statuses>[];
      json['statuses'].forEach((v) {
        statuses!.add(new Statuses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.le != null) {
      data['le'] = this.le!.toJson();
    }
    if (this.statuses != null) {
      data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Le {
  int? id;
  String? name;
  String? phone;
  String? nid;
  String? districtName;
  String? upazilaName;

  Le(
      {this.id,
      this.name,
      this.phone,
      this.nid,
      this.districtName,
      this.upazilaName});

  Le.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    nid = json['nid'];
    districtName = json['district_name'];
    upazilaName = json['upazila_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['nid'] = this.nid;
    data['district_name'] = this.districtName;
    data['upazila_name'] = this.upazilaName;
    return data;
  }
}

class Statuses {
  int? statusId;
  String? statusTitle;
  int? householdCount;

  Statuses({this.statusId, this.statusTitle, this.householdCount});

  Statuses.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    statusTitle = json['status_title'];
    householdCount = json['household_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_id'] = this.statusId;
    data['status_title'] = this.statusTitle;
    data['household_count'] = this.householdCount;
    return data;
  }
}