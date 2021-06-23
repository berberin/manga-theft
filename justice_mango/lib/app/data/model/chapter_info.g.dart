// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterInfoAdapter extends TypeAdapter<ChapterInfo> {
  @override
  final int typeId = 1;

  @override
  ChapterInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterInfo(
      preChapterId: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChapterInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.preChapterId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterInfoAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
