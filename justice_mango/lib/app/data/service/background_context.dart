import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';
import 'package:justice_mango/app/data/service/source_service.dart';

class BackgroundContext {
  static Future<int> initMetadata(String repositorySlug) async {
    //return await compute(_initMetadata, repositorySlug).catchError((onError) {});
    return _initMetadata(repositorySlug);
  }

  static Future<List<MangaMeta>> getMangaList(
      MangaRepository repo, int page) async {
    //  return await compute(_getMangaList, {"slug": repo.slug, "page": page});
    return _getMangaList({"slug": repo.slug, "page": page});
  }
}

Future<int> _initMetadata(String repositorySlug) async {
  MangaRepository repository = SourceService.getRepo(repositorySlug);
  return await repository.initData().catchError((onError) {
    //
    return 0;
  });
}

Future<List<MangaMeta>> _getMangaList(Map<String, dynamic> params) async {
  MangaRepository repository = SourceService.getRepo(params["slug"]);
  return await repository.getLatestManga(page: params["page"]);
}
