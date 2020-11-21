// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studentResponse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentResponseAdapter extends TypeAdapter<StudentResponse> {
  @override
  final int typeId = 3;

  @override
  StudentResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentResponse(
      fields[0] as String,
      fields[1] as String,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StudentResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.optionSelected)
      ..writeByte(2)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
