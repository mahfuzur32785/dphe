// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_form_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityFormModelAdapter extends TypeAdapter<ActivityFormModel> {
  @override
  final int typeId = 3;

  @override
  ActivityFormModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityFormModel(
      unioniD: fields[0] as int?,
      activityID: fields[1] as int?,
      districtID: fields[2] as int?,
      activityType: fields[3] as String?,
      targetParticipant: fields[4] as int?,
      attended: fields[5] as int?,
      date: fields[6] as String?,
      stkHolder: fields[7] as String?,
      completedBatch: fields[8] as int?,
      limitation: fields[9] as String?,
      recmmended: fields[10] as String?,
      rmrk: fields[11] as String?,
      actStatus: fields[12] as String?,
      upaID: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityFormModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.unioniD)
      ..writeByte(1)
      ..write(obj.activityID)
      ..writeByte(2)
      ..write(obj.districtID)
      ..writeByte(3)
      ..write(obj.activityType)
      ..writeByte(4)
      ..write(obj.targetParticipant)
      ..writeByte(5)
      ..write(obj.attended)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.stkHolder)
      ..writeByte(8)
      ..write(obj.completedBatch)
      ..writeByte(9)
      ..write(obj.limitation)
      ..writeByte(10)
      ..write(obj.recmmended)
      ..writeByte(11)
      ..write(obj.rmrk)
      ..writeByte(12)
      ..write(obj.actStatus)
      ..writeByte(13)
      ..write(obj.upaID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityFormModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
