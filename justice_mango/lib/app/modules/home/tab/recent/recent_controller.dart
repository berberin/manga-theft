import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/model/recent_read.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';

import 'widget/recent_agrs.dart';

class RecentController extends GetxController {
  var recentArgs = <RecentArgs>[].obs;
  late MangaMetaCombine mangaMetaCombine;

  @override
  void onInit() {
    super.onInit();
    renewRecent();
  }

  renewRecent() async {
    recentArgs.clear();
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

      recentArgs.add(
        RecentArgs(
          mangaMetaCombine: mangaMetaCombine,
          dateTime: recent.dateTime,
          chapterName: chapterInfo[readIndex ?? 0].name ?? '',
        ),
      );
    }
  }
}
