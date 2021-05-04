import 'package:justice_mango/app/data/provider/manga_provider.dart';
import 'package:justice_mango/app/data/provider/nettruyen_manga_provider.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';

class SourceService {
  SourceService._();
  static List<MangaRepository> sourceRepositories = <MangaRepository>[];

  static List<MangaRepository> allSourceRepositories = <MangaRepository>[
    MangaRepository(NettruyenMangaProvider()),

    // sources..
  ];

  static addToSource(MangaRepository mangaRepository) {
    sourceRepositories.add(mangaRepository);
  }

  static removeSource(MangaProvider mangaProvider) {
    sourceRepositories.removeWhere((element) {
      return (element.provider.runtimeType == mangaProvider.runtimeType);
    });
  }
}
