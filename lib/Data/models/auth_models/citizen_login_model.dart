import 'dart:convert';

class CitizenLoginModel {
  bool? otpSend;
  bool? citizenFound;
  Data? data;

  CitizenLoginModel({
    this.otpSend,
    this.citizenFound,
    this.data,
  });

  factory CitizenLoginModel.fromRawJson(String str) => CitizenLoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CitizenLoginModel.fromJson(Map<String, dynamic> json) => CitizenLoginModel(
    otpSend: json["otp_send"],
    citizenFound: json["citizen_found"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "otp_send": otpSend,
    "citizen_found": citizenFound,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? mobile;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Device>? devices;

  Data({
    this.id,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.devices,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mobile: json["mobile"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    devices: json["devices"] == null ? [] : List<Device>.from(json["devices"]!.map((x) => Device.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile": mobile,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class Device {
  int? id;
  int? citizenId;
  String? deviceId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Device({
    this.id,
    this.citizenId,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
  });

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["id"],
    citizenId: json["citizen_id"],
    deviceId: json["device_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "citizen_id": citizenId,
    "device_id": deviceId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
