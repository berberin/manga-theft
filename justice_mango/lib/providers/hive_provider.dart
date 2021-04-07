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
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MangaMetaAdapter());
    Hive.registerAdapter(ChapterInfoAdapter());

    mangaBox = await Hive.openBox('mangaBox');
    if (mangaBox.isEmpty) {
      initDataFromJson('assets/data/manga_list.json');
    }
    readBox = await Hive.openBox('readBox');
  }

  static addToMangaBox(MangaMeta mangaMeta) async {
    await mangaBox.put(mangaMeta.id, mangaMeta);
  }

  static getMangaMeta(String id) {
    return mangaBox.get(id);
  }

  static Future initDataFromJson(String assetsStr) async {
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
}
