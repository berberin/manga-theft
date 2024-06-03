import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/model/read_info.dart';
import 'package:manga_theft/app/data/model/recent_read.dart';
import 'package:manga_theft/app/data/service/version.dart';

const String mangaBoxName = 'manga_box';
const String chapterReadInfoBoxName = 'read_box';
const String favoriteBoxName = 'favorite_box';
const String lastReadInfoBoxName = 'last_read_info_box';
const String recentReadBoxName = 'recent_read_box';

class HiveService {
  HiveService._();

  static init() async {
    await Hive.initFlutter();

    // register adapters
    Hive.registerAdapter(MangaMetaAdapter());
    Hive.registerAdapter(ChapterInfoAdapter());
    Hive.registerAdapter(ReadInfoAdapter());
    Hive.registerAdapter(RecentReadAdapter());

    // open boxs
    mangaBox = await Hive.openBox(mangaBoxName);
    favoriteBox = await Hive.openBox(favoriteBoxName);
    chapterReadInfo = await Hive.openBox(chapterReadInfoBoxName);
    lastReadInfoBox = await Hive.openBox(lastReadInfoBoxName);
    commonBox = await Hive.openBox(recentReadBoxName);
  }

  static late Box<MangaMeta> mangaBox;
  static late Box<MangaMeta> favoriteBox;
  static late Box<ChapterInfo> chapterReadInfo;
  static late Box<ReadInfo> lastReadInfoBox;

  // recent read, init repo data, exceptional favorite
  static late Box commonBox;

  static putMangaMeta(String mangaId, MangaMeta mangaMeta) async {
    await mangaBox.put(mangaId, mangaMeta);
  }

  static MangaMeta? getMangaMeta(String mangaId) {
    return mangaBox.get(mangaId);
  }

  static bool hasMangaMeta(String mangaId) {
    return mangaBox.containsKey(mangaId);
  }

  static putMangaMetaFavorite(String mangaId, MangaMeta mangaMeta) async {
    await favoriteBox.put(mangaId, mangaMeta);
  }

  static MangaMeta? getMangaMetaFavorite(String mangaId) {
    return favoriteBox.get(mangaId);
  }

  static bool hasMangaMetaInFavorite(String mangaId) {
    return favoriteBox.containsKey(mangaId);
  }

  static putChapterInfo(String chapterId, ChapterInfo chapterInfo) async {
    await chapterReadInfo.put(chapterId, chapterInfo);
  }

  static ChapterInfo? getChapterInfoInBox(String chapterId) {
    return chapterReadInfo.get(chapterId);
  }

  static bool hasChapterInfoInBox(String chapterId) {
    return chapterReadInfo.containsKey(chapterId);
  }

  static putReadInfo(String mangaId, ReadInfo readInfo) async {
    await lastReadInfoBox.put(mangaId, readInfo);
  }

  static ReadInfo? getReadInfo(String mangaId) {
    return lastReadInfoBox.get(mangaId);
  }

  static bool hasReadInfoInBox(String mangaId) {
    return lastReadInfoBox.containsKey(mangaId);
  }

  static List<RecentRead> getRecentReadBox() {
    return List<RecentRead>.from(commonBox.get('recent') ?? []);
  }

  static putToRecentReadBox(List<RecentRead> list) async {
    await commonBox.put('recent', list);
  }

  static repoIsAvailable(String repoSlug) {
    return commonBox.get(
      repoSlug,
      defaultValue: false,
    );
  }

  static bool isUpToDate() {
    return (commonBox.get('appVersion') == AppVersion.version);
  }

  static setVersion() async {
    await commonBox.put('appVersion', AppVersion.version);
  }

  static setRepoIsAvailable(String repoSlug) async {
    await commonBox.put(repoSlug, true);
  }

  static setExceptionalFavorite(String mangaId) async {
    await commonBox.put('exception:$mangaId', true);
  }

  static removeExceptionalFavorite(String mangaId) async {
    await commonBox.delete('exception:$mangaId');
  }

  static isExceptionalFavorite(String mangaId) {
    return commonBox.get('exception:$mangaId') ?? false;
  }
}
