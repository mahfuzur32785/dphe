// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlc_ph_verify_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhysicalVerifyModelHiveAdapter
    extends TypeAdapter<PhysicalVerifyModelHive> {
  @override
  final int typeId = 1;

  @override
  PhysicalVerifyModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhysicalVerifyModelHive(
      id: fields[0] as int?,
      upazillaID: fields[1] as int?,
      distID: fields[2] as int?,
      benfID: fields[3] as int?,
      benfName: fields[4] as String?,
      upazillaName: fields[5] as String?,
      unionName: fields[6] as String?,
      benfMobileNo: fields[7] as String?,
      benfNID: fields[8] as String?,
      status: fields[9] as String?,
      reason: fields[10] as String?,
      latitude: fields[11] as String?,
      longitude: fields[12] as String?,
      benfPhone: fields[13] as String?,
      benfHouse: fields[14] as String?,
      isOnline: fields[15] as String?,
      districtName: fields[16] as String?,
      wardno: fields[17] as String?,
      qansjson: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PhysicalVerifyModelHive obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.upazillaID)
      ..writeByte(2)
      ..write(obj.distID)
      ..writeByte(3)
      ..write(obj.benfID)
      ..writeByte(4)
      ..write(obj.benfName)
      ..writeByte(5)
      ..write(obj.upazillaName)
      ..writeByte(6)
      ..write(obj.unionName)
      ..writeByte(7)
      ..write(obj.benfMobileNo)
      ..writeByte(8)
      ..write(obj.benfNID)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.reason)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.benfPhone)
      ..writeByte(14)
      ..write(obj.benfHouse)
      ..writeByte(15)
      ..write(obj.isOnline)
      ..writeByte(16)
      ..write(obj.districtName)
      ..writeByte(17)
      ..write(obj.wardno)
      ..writeByte(18)
      ..write(obj.qansjson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhysicalVerifyModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
