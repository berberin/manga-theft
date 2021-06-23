// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaMetaAdapter extends TypeAdapter<MangaMeta> {
  @override
  final int typeId = 0;

  @override
  MangaMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaMeta(
      alias: (fields[0] as List)?.cast<String>(),
      author: fields[1] as String,
      description: fields[2] as String,
      preId: fields[3] as String,
      imgUrl: fields[4] as String,
      status: fields[5] as String,
      tags: (fields[6] as List)?.cast<String>(),
      title: fields[7] as String,
      url: fields[8] as String,
      lang: fields[9] as String,
      repoSlug: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MangaMeta obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.alias)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.preId)
      ..writeByte(4)
      ..write(obj.imgUrl)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.url)
      ..writeByte(9)
      ..write(obj.lang)
      ..writeByte(10)
      ..write(obj.repoSlug);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MangaMetaAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
