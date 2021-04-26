import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/models/read_info.dart';
import 'package:justice_mango/providers/manga_provider.dart';

class HiveProvider {
  HiveProvider._();
  static Box<MangaMeta> mangaBox;

  static Box<ChapterInfo> readBox;

  static Box<MangaMeta> favoriteBox;

  static Box<ReadInfo> lastReadBox;

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MangaMetaAdapter());
    Hive.registerAdapter(ChapterInfoAdapter());
    Hive.registerAdapter(ReadInfoAdapter());

    mangaBox = await Hive.openBox('mangaBox');
    if (mangaBox.isEmpty) {
      _initDataFromJson('assets/data/manga_list.json');
    }
    readBox = await Hive.openBox('readBox');
    favoriteBox = await Hive.openBox('favoriteBox');
    lastReadBox = await Hive.openBox('lastReadBox');
  }

  static ReadInfo getLastReadInfo({String mangaId}) {
    return lastReadBox.get(mangaId);
  }

  static Future<void> updateLastReadInfo({String mangaId, bool updateStatus = false}) async {
    var currentReadInfo = lastReadBox.get(mangaId);
    var chapters = await MangaProvider.getChaptersInfo(mangaId);
    if (currentReadInfo == null) {
      await lastReadBox.put(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,
          newUpdate: false,
          lastReadIndex: chapters.length - 1,
        ),
      );
    } else {
      await lastReadBox.put(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,

          /* cập nhật trạng thái newUpdate khi thoả mãn 2 điều kiện
             - updateStatus được set true
             - chương cuối cùng trong phần cũ đã được đọc

             true: số chương mới lớn hơn số chương cũ, đồng thời chương mới nhất đã được đọc
             các trường hợp còn lại giữ nguyên giá trị cũ.
           */
          newUpdate:
              updateStatus && isRead(chapterId: chapters[chapters.length - currentReadInfo.numberOfChapters].chapterId)
                  ? (chapters.length > currentReadInfo.numberOfChapters)
                  : currentReadInfo.newUpdate,
          lastReadIndex: currentReadInfo.lastReadIndex + (chapters.length - currentReadInfo.numberOfChapters),
        ),
      );
    }
  }

  static void updateLastReadIndex({String mangaId, int readIndex}) async {
    var currentReadInfo = lastReadBox.get(mangaId);
    currentReadInfo.lastReadIndex = readIndex;
    await lastReadBox.put(mangaId, currentReadInfo);
  }

  // need guaranteed updateLastReadInfo called before
  static int getLastReadIndex({String mangaId}) {
    return lastReadBox.get(mangaId).lastReadIndex ?? 1;
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
