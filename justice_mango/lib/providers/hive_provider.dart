import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:justice_mango/models/manga_meta.dart';

class HiveProvider {
  HiveProvider._();
  static Box<MangaMeta> mangaBox;
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MangaMetaAdapter());

    mangaBox = await Hive.openBox('mangaBox');
    if (mangaBox.isEmpty) {
      initDataFromJson('assets/data/manga_list.json');
    }
  }

  static addToMangaBox(MangaMeta mangaMeta) async {
    await mangaBox.put(mangaMeta.id, mangaMeta);
  }

  static getMangaMeta(String id) async {
    return await mangaBox.get(id);
  }

  static Future initDataFromJson(String assetsStr) async {
    String jsonString = await rootBundle.loadString(assetsStr);
    dynamic jsonArr = jsonDecode(jsonString);
    for (var item in jsonArr) {
      MangaMeta mangaMeta = MangaMeta.fromJson(item);
      addToMangaBox(mangaMeta);
    }
  }
}
