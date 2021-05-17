import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'manga_meta.g.dart';

@HiveType(typeId: 0)
class MangaMeta extends Equatable {
  @HiveField(0)
  List<String> alias;
  @HiveField(1)
  String author;
  @HiveField(2)
  String description;
  @HiveField(3)
  String preId;
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
  @HiveField(9)
  String lang;
  @HiveField(10)
  String repoSlug;

  MangaMeta(
      {this.alias,
      this.author,
      this.description,
      this.preId,
      this.imgUrl,
      this.status,
      this.tags,
      this.title,
      this.url,
      this.lang,
      @required this.repoSlug});

  factory MangaMeta.fromJson(Map<String, dynamic> json) {
    return MangaMeta(
      alias:
          json['alias'] != null ? new List<String>.from(json['alias']) : null,
      author: json['author'],
      description: json['description'],
      preId: json['id'],
      imgUrl: json['imgUrl'],
      status: json['status'],
      tags: json['tags'] != null ? new List<String>.from(json['tags']) : null,
      title: json['title'],
      url: json['url'],
      lang: json['lang'],
      repoSlug: json['repoSlug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['description'] = this.description;
    data['id'] = this.preId;
    data['imgUrl'] = this.imgUrl;
    data['status'] = this.status;
    data['title'] = this.title;
    data['url'] = this.url;
    data['lang'] = this.lang;
    if (this.alias != null) {
      data['alias'] = this.alias;
    }
    if (this.tags != null) {
      data['tags'] = this.tags;
    }
    data['repoSlug'] = this.repoSlug;
    return data;
  }

  @override
  // TODO: implement props
  List<Object> get props => [url];
}
