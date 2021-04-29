abstract class MangaProvider{
  Future<List<MangaMeta>> getLatestManga({page:1});
  Future<List<ChapterInfo>> getChaptersInfo(String mangaId);


}