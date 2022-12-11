import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manga_meta.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class MangaMeta extends Equatable {
  @JsonKey(name: 'aliases')
  @HiveField(0)
  final List<String>? alias;

  @HiveField(1)
  final String? author;

  @HiveField(2)
  final String? description;

  @JsonKey(name: 'id')
  @HiveField(3)
  final String preId;

  @HiveField(4)
  String? imgUrl;
  @HiveField(5)
  final String? status;

  @HiveField(6)
  final List<String>? tags;

  @HiveField(7)
  final String? title;

  @JsonKey(name: 'sourceUrl')
  @HiveField(8)
  final String url;

  @JsonKey(name: 'language')
  @HiveField(9)
  final String lang;

  @JsonKey(defaultValue: "vi>storynap>")
  @HiveField(10)
  final String repoSlug;

  MangaMeta.z(
      this.alias,
      this.author,
      this.description,
      this.preId,
      this.imgUrl,
      this.status,
      this.tags,
      this.title,
      this.url,
      this.lang,
      this.repoSlug);

  MangaMeta({
    this.alias,
    this.author,
    this.description,
    required this.preId,
    this.imgUrl,
    this.status,
    this.tags,
    this.title,
    required this.url,
    required this.lang,
    required this.repoSlug,
  });

  factory MangaMeta.fromJson(Map<String, dynamic> json) =>
      _$MangaMetaFromJson(json);

  Map<String, dynamic> toJson() => _$MangaMetaToJson(this);

  @override
  List<Object> get props => [url, imgUrl ?? ""];

  MangaMeta clone() => MangaMeta.z(alias, author, description, preId, imgUrl,
      status, tags, title, url, lang, repoSlug);
}
