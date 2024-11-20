class AttendanceDetailsModel {
  List<AttendanceData>? data;

  AttendanceDetailsModel({this.data});

  AttendanceDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AttendanceData>[];
      json['data'].forEach((v) {
        data!.add(new AttendanceData.fromJson(v));
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

class AttendanceData {
  int? id;
  int? userId;
  dynamic latitude;
  dynamic longitude;
  String? checkIn;
  dynamic checkOut;
  int? status;
  String? createdAt;
  String? updatedAt;
  AttUser? user;

  AttendanceData(
      {this.id,
      this.userId,
      this.latitude,
      this.longitude,
      this.checkIn,
      this.checkOut,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.user});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new AttUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class AttUser {
  int? id;
  String? name;
  dynamic phone;
  String? photoUrl;

  AttUser({this.id, this.name, this.phone, this.photoUrl});

  AttUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}