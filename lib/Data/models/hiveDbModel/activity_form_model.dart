import 'package:hive/hive.dart';

part 'activity_form_model.g.dart';

@HiveType(typeId: 3)
class ActivityFormModel {
  @HiveField(0)
  int? unioniD;
  @HiveField(1)
  int? activityID;
  @HiveField(2)
  int? districtID;
  @HiveField(3)
  String? activityType;
  @HiveField(4)
  int? targetParticipant;
  @HiveField(5)
  int? attended;
  @HiveField(6)
  String? date;
  @HiveField(7)
  String? stkHolder;
  @HiveField(8)
  int? completedBatch;
  @HiveField(9)
  String? limitation;
  @HiveField(10)
  String? recmmended;
  @HiveField(11)
  String? rmrk;
  @HiveField(12)
  String? actStatus;
  @HiveField(13)
  int? upaID;

  ActivityFormModel(
      {this.unioniD,
      this.activityID,
      this.districtID,
      this.activityType,
      this.targetParticipant,
      this.attended,
      this.date,
      this.stkHolder,
      this.completedBatch,
      this.limitation,
      this.recmmended,
      this.rmrk,
      this.actStatus,
      this.upaID});
}
