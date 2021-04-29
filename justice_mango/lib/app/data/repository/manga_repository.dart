import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/provider/manga_provider.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';

class MangaRepository {
  MangaProvider provider;

  MangaRepository(this.provider);

  Future<List<MangaMeta>> getLatestManga({page: 1}) {
    return provider.getLatestManga(page: page);
  }

  Future<List<ChapterInfo>> getChaptersInfo(String mangaId) {
    return provider.getChaptersInfo(mangaId);
  }

  Future<List<String>> getPages(String chapterUrl) {
    return provider.getPages(chapterUrl);
  }

  Future<List<MangaMeta>> search(String searchString) {
    return provider.search(searchString);
  }

  Future<List<MangaMeta>> searchTag(String searchTag) {
    return provider.searchTag(searchTag);
  }

  Future<List<MangaMeta>> getRandomManga(String tag, int amount) {
    return provider.getRandomManga(tag, amount);
  }

  MangaMeta getMangaMeta(mangaId) {
    // get id: provider.getId(mangaId)
    return HiveService.getMangaMeta(provider.getId(mangaId));
  }

  putMangaMeta(MangaMeta mangaMeta) async {
    await HiveService.putMangaMeta(provider.getId(mangaMeta.id), mangaMeta);
  }
}
