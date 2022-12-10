import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter_info.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class ChapterInfo {
  @JsonKey(name: "originalId")
  @HiveField(0)
  String preChapterId;
  @HiveField(1)
  @JsonKey(name: "title")
  String? name;
  @JsonKey(name: "sourceUrl")
  @HiveField(2)
  String? url;

  ChapterInfo({required this.preChapterId, this.name, this.url});

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterInfoToJson(this);
}
