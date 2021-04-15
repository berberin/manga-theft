import 'package:hive/hive.dart';

part 'chapter_info.g.dart';

@HiveType(typeId: 1)
class ChapterInfo {
  @HiveField(0)
  int chapterId;
  @HiveField(1)
  String name;
  @HiveField(2)
  String url;

  ChapterInfo({this.chapterId, this.name, this.url});

  factory ChapterInfo.fromJson(Map<String, dynamic> json) {
    return ChapterInfo(
      chapterId: json['chapterId'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterId'] = this.chapterId;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
