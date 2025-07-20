import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/cubit/recent/recent_state.dart';

import '../../../../data/model/chapter_info.dart';
import '../../../../data/model/manga_meta_combine.dart';
import '../../../../data/model/recent_read.dart';
import '../../presentation/recent/widget/recent_agrs.dart';

@injectable
class RecentCubit extends Cubit<RecentState> {
  final HiveService hiveService;
  final SourceService sourceService;

  RecentCubit(this.hiveService, this.sourceService) : super(const RecentState());

  void init() {
    try {
      emit(state.copyWith(status: BaseStatus.loading));
      renewRecent();
      emit(state.copyWith(status: BaseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.failed, error: e.toString()));
    }
  }

  void renewRecent() async {
    emit(state.copyWith(recentArgs: []));
    List<RecentRead> recentReads = hiveService.getRecentReadBox();
    List<RecentArgs> recentArgs = state.recentArgs;
    MangaMetaCombine? mangaMetaCombine;
    if (recentReads.isNotEmpty) {
      for (var recent in recentReads.reversed) {
        for (var repo in sourceService.allSourceRepositories) {
          if (recent.mangaMeta.repoSlug == repo.slug) {
            mangaMetaCombine = MangaMetaCombine(repo, recent.mangaMeta);
            break;
          }
        }
        List<ChapterInfo> chapterInfo = await mangaMetaCombine!.repo.updateLastReadInfo(
          mangaMeta: mangaMetaCombine.mangaMeta,
          updateStatus: false,
          xClientId: "",
        );

        int? readIndex = mangaMetaCombine.repo.getLastReadIndex(mangaMetaCombine.mangaMeta.preId);
        recentArgs.add(
          RecentArgs(
            mangaMetaCombine: mangaMetaCombine,
            dateTime: recent.dateTime,
            chapterName: chapterInfo[readIndex ?? 0].name ?? '',
          ),
        );
      }
    }
    emit(state.copyWith(mangaMetaCombine: mangaMetaCombine, recentArgs: recentArgs));
  }
}
