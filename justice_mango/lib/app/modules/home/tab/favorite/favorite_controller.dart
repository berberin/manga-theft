import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteController extends GetxController {
  var favoriteMangas = <MangaMeta>[].obs;
  var favoriteMetaCombine = <MangaMetaCombine>[].obs;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    refreshUpdate();
  }

  refreshUpdate() async {
    var favoriteKeys = HiveService.favoriteBox.keys.toList();
    favoriteMetaCombine.clear();
    for (var key in favoriteKeys) {
      for (var repo in SourceService.allSourceRepositories) {
        if (key.toString().startsWith(repo.getSlug())) {
          favoriteMetaCombine.add(MangaMetaCombine(repo, HiveService.getMangaMetaFavorite(key)));
        }
        break;
      }
    }
    //sorting
    // for (var meta in favoriteMetaCombine) {
    //   print(meta.mangaMeta.title);
    // }
    favoriteMetaCombine.sort((a, b) => a.mangaMeta.title.compareTo(b.mangaMeta.title));
    // print("--");
    // for (var meta in favoriteMetaCombine) {
    //   print(meta.mangaMeta.title);
    // }
  }
}
