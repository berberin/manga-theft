import 'package:flutter/cupertino.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';

abstract class MangaProvider {
  late String nametag;
  late Locale locale;

  Future<List<MangaMeta>> initData();

  Map<String, String> imageHeader();

  /// Get a List MangaMeta from source
  Future<List<MangaMeta>> getLatestManga({int page = 1, String? xClientId});

  /// Get a List ChapterInfo from source
  Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta, {String? xClientId});

  /// Get a List image url from source
  Future<List<String>> getPages(String chapterUrl, {String? xClientId});

  /// Search a searchString in source
  Future<List<MangaMeta>> search(String searchString, {String? xClientId});

  /// Search a tag in source
  Future<List<MangaMeta>> searchTag(String searchTag, {String? xClientId});

  Future<MangaMeta> getLatestMeta(MangaMeta mangaMeta, {String? xClientId});

  String getId(String preId) {
    return "${locale.languageCode}>$nametag>$preId";
  }

  String getChapterId(String preChapterId) {
    return "${locale.languageCode}>$nametag>$preChapterId";
  }

  String get slug {
    return "${locale.languageCode}>$nametag>";
  }
}
