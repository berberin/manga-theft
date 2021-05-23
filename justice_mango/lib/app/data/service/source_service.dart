import 'package:justice_mango/app/data/provider/manga_provider.dart';
import 'package:justice_mango/app/data/provider/sources/manganelo/nelo_manga_provider.dart';
import 'package:justice_mango/app/data/provider/sources/nettruyen/nettruyen_manga_provider.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';

class SourceService {
  SourceService._();
  static List<MangaRepository> sourceRepositories = <MangaRepository>[];

  static List<MangaRepository> allSourceRepositories = <MangaRepository>[
    MangaRepository(NettruyenMangaProvider()),
    MangaRepository(NeloMangaProvider()),
    // sources..
  ];

  static init() async {
    for (var repo in sourceRepositories) {
      repo.initData().catchError((e, stacktrace) {
        print(e);
        print(stacktrace);
      });
    }
  }

  static addToSource(MangaRepository mangaRepository) async {
    sourceRepositories.add(mangaRepository);
    try {
      // fixme: need await?
      mangaRepository.initData();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  static removeSource(MangaProvider mangaProvider) {
    sourceRepositories.removeWhere((element) {
      return (element.provider.runtimeType == mangaProvider.runtimeType);
    });
  }
}
