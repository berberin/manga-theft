import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BoardController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getLatestList(page);
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // observe
  List<MangaMeta> mangaBoard = <MangaMeta>[].obs;

  // todo: favorite update
  List<MangaMeta> favoriteUpdate = <MangaMeta>[].obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  int page = 1;
  var hasError = false.obs;

  onRefresh() async {
    page = 1;
    try {
      var tmp = await SourceService.sourceRepositories[0].getLatestManga(page: page);
      mangaBoard.assignAll(tmp);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    for (int i = 1; i < SourceService.sourceRepositories.length; i++) {
      var tmp = await SourceService.sourceRepositories[i].getLatestManga(page: page);
      mangaBoard.addAll(tmp);
    }
    refreshController.refreshCompleted();
  }

  onLoading() async {
    page++;
    getLatestList(page);
    refreshController.loadComplete();
  }

  getLatestList(int page) async {
    for (var repo in SourceService.sourceRepositories) {
      try {
        var tmp = await repo.getLatestManga(page: page);
        mangaBoard.addAll(tmp);
        hasError.value = false;
      } catch (e, stacktrace) {
        hasError.value = true;
        print(e);
        print(stacktrace);
      }
    }
  }

  getUpdateFavorite() async {
    List<String> favoriteKeys = HiveService.favoriteBox.keys.toList();
    for (var key in favoriteKeys) {
      MangaMeta mangaMeta = HiveService.getMangaMetaFavorite(key);
      for (var repo in SourceService.allSourceRepositories) {
        if (key.startsWith(repo.getSlug())) {
          repo.updateLastReadInfo(
            preId: mangaMeta.preId,
            updateStatus: true,
          );
        }
      }
    }
  }
}
