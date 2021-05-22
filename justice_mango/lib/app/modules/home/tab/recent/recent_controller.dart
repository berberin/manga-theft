import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentController extends GetxController {
  var readTime = <DateTime>[];
  var recentMetaCombine = <MangaMetaCombine>[].obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    refreshRecent();
  }

  refreshRecent() {
    var recentRead = HiveService.getRecentReadBox();
    readTime.clear();
    recentMetaCombine.clear();
    for (var recent in recentRead) {
      readTime.add(recent.dateTime);
      for (var repo in SourceService.allSourceRepositories) {
        if (recent.mangaMeta.repoSlug == repo.slug) {
          recentMetaCombine.add(MangaMetaCombine(repo, recent.mangaMeta));
          break;
        }
      }
    }
  }
}
