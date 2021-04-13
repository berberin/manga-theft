import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';

class HiveProvider {
  HiveProvider._();
  static Box<MangaMeta> mangaBox;

  static Box<ChapterInfo> readBox;

  static Box<MangaMeta> favoriteBox;

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MangaMetaAdapter());
    Hive.registerAdapter(ChapterInfoAdapter());

    mangaBox = await Hive.openBox('mangaBox');
    if (mangaBox.isEmpty) {
      _initDataFromJson('assets/data/manga_list.json');
    }
    readBox = await Hive.openBox('readBox');
    favoriteBox = await Hive.openBox('favoriteBox');
  }

  static int getLastReadIndex({String mangaId}) {
    // todo: implement
    return 0;
  }

  static addToMangaBox(MangaMeta mangaMeta) async {
    await mangaBox.put(mangaMeta.id, mangaMeta);
  }

  static MangaMeta getMangaMeta(String id) {
    return mangaBox.get(id);
  }

  static bool inMangaBox(String id) {
    return mangaBox.get(id) != null;
  }

  static Future _initDataFromJson(String assetsStr) async {
    String jsonString = await rootBundle.loadString(assetsStr);
    dynamic jsonArr = jsonDecode(jsonString);
    for (var item in jsonArr) {
      MangaMeta mangaMeta = MangaMeta.fromJson(item);
      addToMangaBox(mangaMeta);
    }
  }

  static addToReadBox(ChapterInfo chapterInfo) async {
    await readBox.put(chapterInfo.chapterId, chapterInfo);
  }

  static getReadChapter(int id) {
    return readBox.get(id);
  }

  static addToFavoriteBox(MangaMeta mangaMeta) async {
    await favoriteBox.put(mangaMeta.id, mangaMeta);
  }

  static removeFromFavoriteBox(String id) async {
    await favoriteBox.delete(id);
  }

  static List<MangaMeta> getFavoriteMangas() {
    return favoriteBox.values.toList();
  }

  static getFavoriteBoxByID(String id) {
    return favoriteBox.get(id);
  }

  static bool isFavoriteOrNot(MangaMeta mangaMeta) {
    return getFavoriteBoxByID(mangaMeta.id) == null ? false : true;
  }

  static bool isRead({int chapterId}) {
    return readBox.get(chapterId) != null;
  }
}
