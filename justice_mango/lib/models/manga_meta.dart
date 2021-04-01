import 'package:hive/hive.dart';

part 'manga_meta.g.dart';

@HiveType(typeId: 0)
class MangaMeta {
  @HiveField(0)
  List<String> alias;
  @HiveField(1)
  String author;
  @HiveField(2)
  String description;
  @HiveField(3)
  String id;
  @HiveField(4)
  String imgUrl;
  @HiveField(5)
  String status;
  @HiveField(6)
  List<String> tags;
  @HiveField(7)
  String title;
  @HiveField(8)
  String url;

  MangaMeta(
      {this.alias, this.author, this.description, this.id, this.imgUrl, this.status, this.tags, this.title, this.url});

  factory MangaMeta.fromJson(Map<String, dynamic> json) {
    return MangaMeta(
      alias: json['alias'] != null ? new List<String>.from(json['alias']) : null,
      author: json['author'],
      description: json['description'],
      id: json['id'],
      imgUrl: json['imgUrl'],
      status: json['status'],
      tags: json['tags'] != null ? new List<String>.from(json['tags']) : null,
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['description'] = this.description;
    data['id'] = this.id;
    data['imgUrl'] = this.imgUrl;
    data['status'] = this.status;
    data['title'] = this.title;
    data['url'] = this.url;
    if (this.alias != null) {
      data['alias'] = this.alias;
    }
    if (this.tags != null) {
      data['tags'] = this.tags;
    }
    return data;
  }
}
