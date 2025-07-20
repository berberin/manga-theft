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
  HiveService();

  Future<void> init() async {
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

  late Box<MangaMeta> mangaBox;
  late Box<MangaMeta> favoriteBox;
  late Box<ChapterInfo> chapterReadInfo;
  late Box<ReadInfo> lastReadInfoBox;

  // recent read, init repo data, exceptional favorite
  late Box commonBox;

  Future<void> putMangaMeta(String mangaId, MangaMeta mangaMeta) async {
    await mangaBox.put(mangaId, mangaMeta);
  }

  MangaMeta? getMangaMeta(String mangaId) {
    return mangaBox.get(mangaId);
  }

  bool hasMangaMeta(String mangaId) {
    return mangaBox.containsKey(mangaId);
  }

  Future<void> putMangaMetaFavorite(String mangaId, MangaMeta mangaMeta) async {
    await favoriteBox.put(mangaId, mangaMeta);
  }

  MangaMeta? getMangaMetaFavorite(String mangaId) {
    return favoriteBox.get(mangaId);
  }

  bool hasMangaMetaInFavorite(String mangaId) {
    return favoriteBox.containsKey(mangaId);
  }

  Future<void> putChapterInfo(String chapterId, ChapterInfo chapterInfo) async {
    await chapterReadInfo.put(chapterId, chapterInfo);
  }

  ChapterInfo? getChapterInfoInBox(String chapterId) {
    return chapterReadInfo.get(chapterId);
  }

  bool hasChapterInfoInBox(String chapterId) {
    return chapterReadInfo.containsKey(chapterId);
  }

  Future<void> putReadInfo(String mangaId, ReadInfo readInfo) async {
    await lastReadInfoBox.put(mangaId, readInfo);
  }

  ReadInfo? getReadInfo(String mangaId) {
    return lastReadInfoBox.get(mangaId);
  }

  bool hasReadInfoInBox(String mangaId) {
    return lastReadInfoBox.containsKey(mangaId);
  }

  List<RecentRead> getRecentReadBox() {
    return List<RecentRead>.from(commonBox.get('recent') ?? []);
  }

  Future<void> putToRecentReadBox(List<RecentRead> list) async {
    await commonBox.put('recent', list);
  }

  bool repoIsAvailable(String repoSlug) {
    return commonBox.get(
      repoSlug,
      defaultValue: false,
    );
  }

  bool isUpToDate() {
    return (commonBox.get('appVersion') == AppVersion.version);
  }

  Future<void> setVersion() async {
    await commonBox.put('appVersion', AppVersion.version);
  }

  Future<void> setRepoIsAvailable(String repoSlug) async {
    await commonBox.put(repoSlug, true);
  }

  Future<void> setExceptionalFavorite(String mangaId) async {
    await commonBox.put('exception:$mangaId', true);
  }

  Future<void> removeExceptionalFavorite(String mangaId) async {
    await commonBox.delete('exception:$mangaId');
  }

  dynamic isExceptionalFavorite(String mangaId) {
    return commonBox.get('exception:$mangaId') ?? false;
  }
}
