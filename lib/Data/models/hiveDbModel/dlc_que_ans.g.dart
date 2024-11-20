// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dlc_que_ans.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalDlcQuesAnsAdapter extends TypeAdapter<LocalDlcQuesAns> {
  @override
  final int typeId = 4;

  @override
  LocalDlcQuesAns read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalDlcQuesAns(
      id: fields[0] as String?,
      title: fields[1] as String?,
      type: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalDlcQuesAns obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalDlcQuesAnsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
