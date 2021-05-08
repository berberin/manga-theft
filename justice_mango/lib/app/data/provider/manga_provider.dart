import 'package:flutter/cupertino.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';

abstract class MangaProvider {
  String nametag;
  Locale locale;

  /// Get a List<MangaMeta> from source
  Future<List<MangaMeta>> getLatestManga({page: 1});

  /// Get a List<ChapterInfo> from source
  Future<List<ChapterInfo>> getChaptersInfo(String mangaId);

  /// Get a List<image url> from source
  Future<List<String>> getPages(String chapterUrl);

  /// Search a searchString in source
  Future<List<MangaMeta>> search(String searchString);

  /// Search a tag in source
  Future<List<MangaMeta>> searchTag(String searchTag);

  /// Get random manga from tag in source
  Future<List<MangaMeta>> getRandomManga(String tag, int amount);

  Future<List<MangaMeta>> initData();

  Map<String, String> imageHeader();

  String getId(String preId) {
    return "${locale.languageCode}>$nametag>$preId";
  }

  String getChapterId(String preChapterId) {
    return "${locale.languageCode}>$nametag>$preChapterId";
  }

  String getSlug() {
    return "${locale.languageCode}>$nametag>";
  }
}
