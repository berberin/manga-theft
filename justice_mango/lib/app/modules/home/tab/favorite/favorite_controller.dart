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
    var favoriteMetas = HiveService.favoriteBox.values.toList();
    favoriteMetaCombine.clear();
    for (var mangaMeta in favoriteMetas) {
      for (var repo in SourceService.allSourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          favoriteMetaCombine.add(MangaMetaCombine(repo, mangaMeta));
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
