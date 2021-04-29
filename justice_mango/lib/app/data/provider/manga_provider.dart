import 'package:flutter/cupertino.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';

abstract class MangaProvider {
  static String nametag;
  static Locale locale;
  Future<List<MangaMeta>> getLatestManga({page: 1});
  Future<List<ChapterInfo>> getChaptersInfo(String mangaId);
  Future<List<String>> getPages(String chapterUrl);
  Future<List<MangaMeta>> search(String searchString);
  Future<List<MangaMeta>> searchTag(String searchTag);
  Future<List<MangaMeta>> getRandomManga(String tag, int amount);
  String getId(String mangaId) {
    return "${locale.languageCode}-$nametag-$mangaId";
  }
}
