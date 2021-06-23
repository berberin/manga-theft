// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_read.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentReadAdapter extends TypeAdapter<RecentRead> {
  @override
  final int typeId = 3;

  @override
  RecentRead read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentRead(
      fields[0] as MangaMeta,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentRead obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mangaMeta)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentReadAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
