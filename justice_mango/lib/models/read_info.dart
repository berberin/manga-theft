import 'package:hive/hive.dart';

part 'read_info.g.dart';

@HiveType(typeId: 2)
class ReadInfo {
  @HiveField(0)
  String mangaId;

  @HiveField(1)
  int lastReadIndex;

  ReadInfo({this.mangaId, this.lastReadIndex, this.numberOfChapters, this.newUpdate});

  @HiveField(2)
  int numberOfChapters;

  @HiveField(3)
  bool newUpdate;
}
