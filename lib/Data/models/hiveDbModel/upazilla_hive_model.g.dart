// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upazilla_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpazillaHiveModelAdapter extends TypeAdapter<UpazillaHiveModel> {
  @override
  final int typeId = 2;

  @override
  UpazillaHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpazillaHiveModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      districtID: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UpazillaHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.districtID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpazillaHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
