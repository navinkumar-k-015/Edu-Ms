// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentinfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentinfoAdapter extends TypeAdapter<Studentinfo> {
  @override
  final int typeId = 1;

  @override
  Studentinfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Studentinfo(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Studentinfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone_no);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentinfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
