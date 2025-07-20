import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/model/read_info.dart';
import 'package:manga_theft/app/data/provider/manga_provider.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';

class MangaRepository implements Equatable {
  final MangaProvider provider;
  final HiveService hiveService;

  MangaRepository(this.provider, this.hiveService);

  Future<List<MangaMeta>> getLatestManga({int page = 1}) async {
    List<MangaMeta> mangas = await provider.getLatestManga(page: page);
    return mangas;
  }

  Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta) {
    return provider.getChaptersInfo(mangaMeta);
  }

  Future<List<String>> getPages(String chapterUrl) {
    return provider.getPages(chapterUrl);
  }

  Future<MangaMeta> getLatestMeta(MangaMeta mangaMeta) {
    return provider.getLatestMeta(mangaMeta);
  }

  Future<List<MangaMeta>> search(String searchString) async {
    List<MangaMeta> metas = await provider.search(searchString);
    checkAndPutToMangaBox(metas);
    return metas;
  }

  Future<List<MangaMeta>> searchTag(String searchTag) {
    return provider.searchTag(searchTag);
  }

  List<MangaMeta> getRandomManga({String tag = "", required int amount}) {
    var metaKeys = hiveService.mangaBox.keys.toList().where((element) => element.toString().startsWith(slug)).toList();
    Random random = Random();
    List<MangaMeta> results = <MangaMeta>[];
    for (int i = 0; i < amount; i++) {
      var tmp = hiveService.getMangaMeta(metaKeys[random.nextInt(metaKeys.length)]);
      if (tmp != null) {
        results.add(tmp);
      }
    }
    return results;
  }

  String get slug => provider.slug;

  Future<int> initData() async {
    int count = 0;
    if (!hiveService.repoIsAvailable(slug) || !hiveService.isUpToDate()) {
      List<MangaMeta> mangas = await provider.initData();
      for (var meta in mangas) {
        await hiveService.putMangaMeta(provider.getId(meta.preId), meta);
        count++;
      }
      for (var favoriteMeta in hiveService.favoriteBox.values.toList()) {
        try {
          if (favoriteMeta.repoSlug == slug) {
            favoriteMeta = hiveService.mangaBox.get(provider.getId(favoriteMeta.preId))!;
            putMangaMetaFavorite(favoriteMeta);
          }
        } catch (_) {}
      }
      await hiveService.setRepoIsAvailable(slug);
    }
    return count;
  }

  Future<void> putMangaMeta(MangaMeta mangaMeta) async {
    await hiveService.putMangaMeta(provider.getId(mangaMeta.preId), mangaMeta);
  }

  Future<void> putMangaMetaFavorite(MangaMeta mangaMeta) async {
    await hiveService.putMangaMetaFavorite(provider.getId(mangaMeta.preId), mangaMeta);
  }

  MangaMeta? getMangaMeta(String preId) {
    return hiveService.getMangaMeta(provider.getId(preId));
  }

  Future<List<ChapterInfo>> updateLastReadInfo(
      {required MangaMeta mangaMeta, bool updateStatus = false, String? xClientId}) async {
    String mangaId = provider.getId(mangaMeta.preId);
    var latestMeta = await provider.getLatestMeta(mangaMeta);
    if (latestMeta != mangaMeta) {
      mangaMeta = latestMeta;
      addToFavorite(mangaMeta.preId, mangaMeta);
    }
    ReadInfo? currentReadInfo = hiveService.getReadInfo(mangaId);
    //MangaMeta mangaMeta = HiveService.getMangaMeta(mangaId);
    List<ChapterInfo> chapters = await provider.getChaptersInfo(
      mangaMeta,
      xClientId: xClientId,
    );
    if (currentReadInfo == null) {
      await hiveService.putReadInfo(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,
          newUpdate: false,
          lastReadIndex: chapters.length - 1,
        ),
      );
    } else {
      await hiveService.putReadInfo(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,
          newUpdate: updateStatus
              ? (chapters.length > (currentReadInfo.numberOfChapters ?? 0) ? true : (!isRead(chapters[0].preChapterId)))
              : currentReadInfo.newUpdate,
          lastReadIndex: currentReadInfo.lastReadIndex! + (chapters.length - (currentReadInfo.numberOfChapters ?? 0)),
        ),
      );
    }

    return chapters;
  }

  Future<void> updateLastReadIndex({required String preId, required int readIndex}) async {
    var currentReadInfo = hiveService.getReadInfo(provider.getId(preId));
    currentReadInfo?.lastReadIndex = readIndex;
    await hiveService.putReadInfo(provider.getId(preId), currentReadInfo!);
  }

  Future<void> addToFavorite(String preId, MangaMeta mangaMeta) async {
    await hiveService.putMangaMetaFavorite(provider.getId(preId), mangaMeta);
  }

  Future<void> removeFavorite(String preId) async {
    await hiveService.favoriteBox.delete(provider.getId(preId));
  }

  int? getLastReadIndex(String preId) {
    return hiveService.getReadInfo(provider.getId(preId))?.lastReadIndex;
  }

  Future<void> markAsRead(String preChapterId, ChapterInfo chapterInfo) async {
    String chapterId = provider.getChapterId(preChapterId);
    await hiveService.putChapterInfo(chapterId, chapterInfo);
  }

  bool isRead(String preChapterId) {
    String chapterId = provider.getChapterId(preChapterId);
    return hiveService.hasChapterInfoInBox(chapterId);
  }

  bool isFavorite(String preId) {
    return hiveService.hasMangaMetaInFavorite(provider.getId(preId));
  }

  Future<void> markAsExceptionalFavorite(String preId) async {
    await hiveService.setExceptionalFavorite(provider.getId(preId));
  }

  Future<void> removeExceptionalFavorite(String preId) async {
    await hiveService.removeExceptionalFavorite(provider.getId(preId));
  }

  bool isExceptionalFavorite(String preId) {
    return hiveService.isExceptionalFavorite(provider.getId(preId));
  }

  Map<String, String> imageHeader() {
    return provider.imageHeader();
  }

  int checkAndPutToMangaBox(List<MangaMeta> mangas) {
    int count = 0;
    for (var meta in mangas) {
      if (hiveService.getMangaMeta(provider.getId(meta.preId)) != meta) {
        hiveService.putMangaMeta(provider.getId(meta.preId), meta);
        count++;
      }
    }
    return count;
  }

  @override
  List<Object> get props => [slug];

  @override
  bool get stringify => false;
}
