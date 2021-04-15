// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadInfoAdapter extends TypeAdapter<ReadInfo> {
  @override
  final int typeId = 2;

  @override
  ReadInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadInfo()
      ..mangaId = fields[0] as String
      ..lastReadIndex = fields[1] as int
      ..numberOfChapters = fields[2] as int
      ..newUpdate = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, ReadInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.mangaId)
      ..writeByte(1)
      ..write(obj.lastReadIndex)
      ..writeByte(2)
      ..write(obj.numberOfChapters)
      ..writeByte(3)
      ..write(obj.newUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
