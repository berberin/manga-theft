import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/model/read_info.dart';
import 'package:manga_theft/app/data/provider/manga_provider.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';

class MangaRepository implements Equatable {
  final MangaProvider provider;

  MangaRepository(this.provider);

  Future<List<MangaMeta>> getLatestManga({page = 1}) async {
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
    var metaKeys = HiveService.mangaBox.keys
        .toList()
        .where((element) => element.toString().startsWith(slug))
        .toList();
    Random random = Random();
    List<MangaMeta> results = <MangaMeta>[];
    for (int i = 0; i < amount; i++) {
      var tmp =
          HiveService.getMangaMeta(metaKeys[random.nextInt(metaKeys.length)]);
      if (tmp != null) {
        results.add(tmp);
      }
    }
    return results;
  }

  String get slug => provider.slug;

  Future<int> initData() async {
    int count = 0;
    if (!HiveService.repoIsAvailable(slug) || !HiveService.isUpToDate()) {
      List<MangaMeta> mangas = await provider.initData();
      for (var meta in mangas) {
        await HiveService.putMangaMeta(provider.getId(meta.preId), meta);
        count++;
      }
      for (var favoriteMeta in HiveService.favoriteBox.values.toList()) {
        try {
          if (favoriteMeta.repoSlug == slug) {
            favoriteMeta =
                HiveService.mangaBox.get(provider.getId(favoriteMeta.preId))!;
            putMangaMetaFavorite(favoriteMeta);
          }
        } catch (_) {}
      }
      await HiveService.setRepoIsAvailable(slug);
    }
    return count;
  }

  putMangaMeta(MangaMeta mangaMeta) async {
    await HiveService.putMangaMeta(provider.getId(mangaMeta.preId), mangaMeta);
  }

  putMangaMetaFavorite(MangaMeta mangaMeta) async {
    await HiveService.putMangaMetaFavorite(
        provider.getId(mangaMeta.preId), mangaMeta);
  }

  MangaMeta? getMangaMeta(String preId) {
    return HiveService.getMangaMeta(provider.getId(preId));
  }

  Future<List<ChapterInfo>> updateLastReadInfo(
      {required MangaMeta mangaMeta, bool updateStatus = false}) async {
    String mangaId = provider.getId(mangaMeta.preId);
    var latestMeta = await provider.getLatestMeta(mangaMeta);
    if (latestMeta != mangaMeta) {
      mangaMeta = latestMeta;
      addToFavorite(mangaMeta.preId, mangaMeta);
    }
    ReadInfo? currentReadInfo = HiveService.getReadInfo(mangaId);
    //MangaMeta mangaMeta = HiveService.getMangaMeta(mangaId);
    List<ChapterInfo> chapters = await provider.getChaptersInfo(mangaMeta);
    if (currentReadInfo == null) {
      await HiveService.putReadInfo(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,
          newUpdate: false,
          lastReadIndex: chapters.length - 1,
        ),
      );
    } else {
      await HiveService.putReadInfo(
        mangaId,
        ReadInfo(
          mangaId: mangaId,
          numberOfChapters: chapters.length,
          newUpdate: updateStatus
              ? (chapters.length > (currentReadInfo.numberOfChapters ?? 0)
                  ? true
                  : (!isRead(chapters[0].preChapterId)))
              : currentReadInfo.newUpdate,
          lastReadIndex: currentReadInfo.lastReadIndex! +
              (chapters.length - (currentReadInfo.numberOfChapters ?? 0)),
        ),
      );
    }

    return chapters;
  }

  updateLastReadIndex({required String preId, required int readIndex}) async {
    var currentReadInfo = HiveService.getReadInfo(provider.getId(preId));
    currentReadInfo?.lastReadIndex = readIndex;
    await HiveService.putReadInfo(provider.getId(preId), currentReadInfo!);
  }

  addToFavorite(String preId, MangaMeta mangaMeta) async {
    await HiveService.putMangaMetaFavorite(provider.getId(preId), mangaMeta);
  }

  removeFavorite(String preId) async {
    await HiveService.favoriteBox.delete(provider.getId(preId));
  }

  int? getLastReadIndex(String preId) {
    return HiveService.getReadInfo(provider.getId(preId))?.lastReadIndex;
  }

  markAsRead(String preChapterId, ChapterInfo chapterInfo) async {
    String chapterId = provider.getChapterId(preChapterId);
    await HiveService.putChapterInfo(chapterId, chapterInfo);
  }

  bool isRead(String preChapterId) {
    String chapterId = provider.getChapterId(preChapterId);
    return HiveService.hasChapterInfoInBox(chapterId);
  }

  bool isFavorite(String preId) {
    return HiveService.hasMangaMetaInFavorite(provider.getId(preId));
  }

  markAsExceptionalFavorite(String preId) async {
    await HiveService.setExceptionalFavorite(provider.getId(preId));
  }

  removeExceptionalFavorite(String preId) async {
    await HiveService.removeExceptionalFavorite(provider.getId(preId));
  }

  bool isExceptionalFavorite(String preId) {
    return HiveService.isExceptionalFavorite(provider.getId(preId));
  }

  Map<String, String> imageHeader() {
    return provider.imageHeader();
  }

  int checkAndPutToMangaBox(List<MangaMeta> mangas) {
    int count = 0;
    for (var meta in mangas) {
      if (HiveService.getMangaMeta(provider.getId(meta.preId)) != meta) {
        HiveService.putMangaMeta(provider.getId(meta.preId), meta);
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
