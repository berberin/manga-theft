import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/model/recent_read.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';

import 'widget/recent_meta_combine.dart';

class RecentController extends GetxController {
  var recentMetaCombine = <RecentMetaCombine>[].obs;
  late MangaMetaCombine mangaMetaCombine;

  @override
  void onInit() {
    super.onInit();
    renewRecent();
  }

  renewRecent() async {
    recentMetaCombine.clear();
    List<RecentRead> recentReads = HiveService.getRecentReadBox();
    for (var recent in recentReads.reversed) {
      for (var repo in SourceService.allSourceRepositories) {
        if (recent.mangaMeta.repoSlug == repo.slug) {
          mangaMetaCombine = MangaMetaCombine(repo, recent.mangaMeta);
          break;
        }
      }

      List<ChapterInfo> chapterInfo =
          await mangaMetaCombine.repo.updateLastReadInfo(
        mangaMeta: mangaMetaCombine.mangaMeta,
        updateStatus: false,
      );

      int? readIndex = mangaMetaCombine.repo
          .getLastReadIndex(mangaMetaCombine.mangaMeta.preId);

      recentMetaCombine.add(
        RecentMetaCombine(
          mangaMetaCombine: mangaMetaCombine,
          dateTime: recent.dateTime,
          chapterName: chapterInfo[readIndex ?? 0].name ?? '',
        ),
      );
    }
  }
}
