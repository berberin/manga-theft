import 'dart:math';

import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/read_info.dart';
import 'package:justice_mango/app/data/provider/manga_provider.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';

class MangaRepository {
  MangaProvider provider;

  MangaRepository(this.provider);

  Future<List<MangaMeta>> getLatestManga({page: 1}) async {
    List<MangaMeta> mangas = await provider.getLatestManga(page: page);
    checkAndPutToMangaBox(mangas);
    return mangas;
  }

  Future<List<ChapterInfo>> getChaptersInfo(MangaMeta mangaMeta) {
    return provider.getChaptersInfo(mangaMeta);
  }

  Future<List<String>> getPages(String chapterUrl) {
    return provider.getPages(chapterUrl);
  }

  Future<List<MangaMeta>> search(String searchString) async {
    List<MangaMeta> metas = await provider.search(searchString);
    checkAndPutToMangaBox(metas);
    return metas;
  }

  Future<List<MangaMeta>> searchTag(String searchTag) {
    return provider.searchTag(searchTag);
  }

  List<MangaMeta> getRandomManga(String tag, int amount) {
    var metaKeys = HiveService.mangaBox.keys.toList().where((element) => element.toString().startsWith(slug)).toList();
    Random random = Random();
    List<MangaMeta> results = <MangaMeta>[];
    for (int i = 0; i < amount; i++) {
      results.add(HiveService.getMangaMeta(metaKeys[random.nextInt(metaKeys.length)]));
    }
    return results;
  }

  String get slug => provider.slug;

  initData() async {
    int count = 0;
    if (HiveService.getMangaMeta('${provider.locale.languageCode}@${provider.nametag}') == null) {
      List<MangaMeta> mangas = await provider.initData();
      for (var meta in mangas) {
        await HiveService.putMangaMeta(provider.getId(meta.preId), meta);
        count++;
        print(count);
      }
      await HiveService.putMangaMeta(
        '${provider.locale.languageCode}@${provider.nametag}',
        MangaMeta(
          title: 'Mothers Box',
          repoSlug: slug,
        ),
      );
    }
  }

  putMangaMeta(MangaMeta mangaMeta) async {
    await HiveService.putMangaMeta(provider.getId(mangaMeta.preId), mangaMeta);
  }

  putMangaMetaFavorite(MangaMeta mangaMeta) async {
    await HiveService.putMangaMetaFavorite(provider.getId(mangaMeta.preId), mangaMeta);
  }

  MangaMeta getMangaMeta(String preId) {
    return HiveService.getMangaMeta(provider.getId(preId));
  }

  updateLastReadInfo({String preId, bool updateStatus = false}) async {
    String mangaId = provider.getId(preId);
    var currentReadInfo = HiveService.getReadInfo(mangaId);
    var mangaMeta = HiveService.getMangaMeta(mangaId);
    var chapters = await provider.getChaptersInfo(mangaMeta);
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
          // cập nhật trạng thái [newUpdate] khi thoả mãn 2 điều kiện
          // - updateStatus được set true
          // - chương cuối cùng trong phần cũ đã được đọc
          //
          // true: số chương mới lớn hơn số chương cũ, đồng thời chương mới nhất đã được đọc
          // các trường hợp còn lại giữ nguyên giá trị cũ.
          newUpdate: (updateStatus && isRead(chapters[chapters.length - currentReadInfo.numberOfChapters].preChapterId))
              ? (chapters.length > currentReadInfo.numberOfChapters)
              : currentReadInfo.newUpdate,
          lastReadIndex: currentReadInfo.lastReadIndex + (chapters.length - currentReadInfo.numberOfChapters),
        ),
      );
    }
  }

  updateLastReadIndex({String preId, int readIndex}) async {
    var currentReadInfo = HiveService.getReadInfo(provider.getId(preId));
    currentReadInfo.lastReadIndex = readIndex;
    await HiveService.putReadInfo(provider.getId(preId), currentReadInfo);
  }

  addToFavorite(String preId, MangaMeta mangaMeta) async {
    await HiveService.putMangaMetaFavorite(provider.getId(preId), mangaMeta);
  }

  removeFavorite(String preId) async {
    await HiveService.favoriteBox.delete(provider.getId(preId));
  }

  int getLastReadIndex(String preId) {
    return HiveService.getReadInfo(provider.getId(preId)).lastReadIndex;
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

  Map<String, String> imageHeader() {
    return provider.imageHeader();
  }

  int checkAndPutToMangaBox(List<MangaMeta> mangas) {
    int count = 0;
    for (var meta in mangas) {
      if (!HiveService.hasMangaMeta(provider.getId(meta.preId))) {
        HiveService.putMangaMeta(provider.getId(meta.preId), meta);
        count++;
      }
    }
    return count;
  }
}
