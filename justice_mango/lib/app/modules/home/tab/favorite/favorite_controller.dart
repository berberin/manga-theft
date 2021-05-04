import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteController extends GetxController {
  var favoriteMangas = <MangaMeta>[].obs;
  var metaCombine = <MangaMetaCombine>[];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    refreshUpdate();
  }

  refreshUpdate() async {
    metaCombine.clear();
    var favoriteKeys = HiveService.favoriteBox.keys.toList();
    for (var key in favoriteKeys) {
      metaCombine.add(MangaMetaCombine(key, HiveService.getMangaMetaFavorite(key)));
    }
    //sorting
    metaCombine.sort((a, b) => a.mangaMeta.title.compareTo(b.mangaMeta.title));

    favoriteMangas.clear();
    for (var meta in metaCombine) {
      favoriteMangas.add(meta.mangaMeta);
    }
  }
}

class MangaMetaCombine {
  final String key;
  final MangaMeta mangaMeta;

  MangaMetaCombine(this.key, this.mangaMeta);
}
