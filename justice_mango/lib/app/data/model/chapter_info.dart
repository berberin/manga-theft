import 'package:hive/hive.dart';

part 'chapter_info.g.dart';

@HiveType(typeId: 1)
class ChapterInfo {
  @HiveField(0)
  String preChapterId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? url;

  ChapterInfo({required this.preChapterId, this.name, this.url});

  factory ChapterInfo.fromJson(Map<String, dynamic> json) {
    return ChapterInfo(
      preChapterId: json['chapterId'].toString(),
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterId'] = this.preChapterId;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
