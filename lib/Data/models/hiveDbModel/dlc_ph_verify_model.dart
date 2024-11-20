import 'package:hive/hive.dart';

part 'dlc_ph_verify_model.g.dart';

@HiveType(typeId: 1)
class PhysicalVerifyModelHive {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? upazillaID;
  @HiveField(2)
  int? distID;
  @HiveField(3)
  int? benfID;
  @HiveField(4)
  String? benfName;
  @HiveField(5)
  String? upazillaName;
  @HiveField(6)
  String? unionName;
  @HiveField(7)
  String? benfMobileNo;
  @HiveField(8)
  String? benfNID;
  @HiveField(9)
  String? status;
  @HiveField(10)
  String? reason;
  @HiveField(11)
  String? latitude;
  @HiveField(12)
  String? longitude;
  @HiveField(13)
  String? benfPhone;
  @HiveField(14)
  String? benfHouse;
  @HiveField(15)
  String? isOnline;
  @HiveField(16)
  String? districtName;
  @HiveField(17)
  String? wardno;
  @HiveField(18)
  String? qansjson;
  
  
  
  
  

  PhysicalVerifyModelHive({
    this.id,
    this.upazillaID,
    this.distID,
    this.benfID,
    this.benfName,
    this.upazillaName,
    this.unionName,
    this.benfMobileNo,
    this.benfNID,
    this.status,
    this.reason,
    this.latitude,
    this.longitude,
    this.benfPhone,
    this.benfHouse,
    this.isOnline,
    this.districtName,
    this.wardno,
    this.qansjson
  });
}
