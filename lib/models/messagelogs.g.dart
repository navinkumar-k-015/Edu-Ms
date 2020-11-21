// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messagelogs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageLogAdapter extends TypeAdapter<MessageLog> {
  @override
  final int typeId = 4;

  @override
  MessageLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageLog(
      fields[1] as String,
      fields[0] as String,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.phoneNo)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.senderOrrecever);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
