// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DistrictAdapter extends TypeAdapter<District> {
  @override
  final int typeId = 0;

  @override
  District read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return District(
      id: fields[0] as int?,
      divisionId: fields[1] as int?,
      name: fields[2] as String?,
      bnName: fields[3] as String?,
      lat: fields[4] as String?,
      lon: fields[5] as String?,
      url: fields[6] as String?,
      createdAt: fields[7] as dynamic,
      updatedAt: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, District obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.divisionId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.bnName)
      ..writeByte(4)
      ..write(obj.lat)
      ..writeByte(5)
      ..write(obj.lon)
      ..writeByte(6)
      ..write(obj.url)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
