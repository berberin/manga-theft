import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/modules/home/cubit/favorite/favorite_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/recent/recent_cubit.dart';
import 'package:manga_theft/app/modules/manga_detail/cubit/manga_detail_state.dart';

import '../../../data/model/recent_read.dart';

@injectable
class MangaDetailCubit extends Cubit<MangaDetailState> {
  final FavoriteCubit favoriteCubit;
  final RecentCubit recentCubit;
  final HiveService hiveService;

  MangaDetailCubit(
    this.favoriteCubit,
    this.recentCubit,
    this.hiveService,
  ) : super(const MangaDetailState());

  void init(MangaMetaCombine mangaMetaCombine) {
    try {
      emit(state.copyWith(
        status: BaseStatus.loading,
      ));
      MangaMetaCombine metaCombine = mangaMetaCombine;
      List<ChapterInfo> chaptersInfo = [];
      List<bool> readArray = [];
      metaCombine.repo.updateLastReadInfo(mangaMeta: metaCombine.mangaMeta).then((value) {
        chaptersInfo = value;
        for (var chapter in chaptersInfo) {
          readArray.add(metaCombine.repo.isRead(chapter.preChapterId));
        }
      });
      emit(state.copyWith(
        status: BaseStatus.success,
        isFavorite: metaCombine.repo.isFavorite(metaCombine.mangaMeta.preId),
        isExceptional: metaCombine.repo.isExceptionalFavorite(metaCombine.mangaMeta.preId),
        chaptersInfo: chaptersInfo,
        readArray: readArray,
      ));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.failed, error: e.toString()));
    }
  }

  Future<void> setIsRead(int index) async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    List<bool> readArray = state.readArray;
    List<ChapterInfo> chaptersInfo = state.chaptersInfo;
    await metaCombine.repo.markAsRead(chaptersInfo[index].preChapterId, chaptersInfo[index]);
    await metaCombine.repo.updateLastReadIndex(
      preId: metaCombine.mangaMeta.preId,
      readIndex: index,
    );
    readArray[index] = true;
    if (index == 0) {
      chaptersInfo = await metaCombine.repo.updateLastReadInfo(
        mangaMeta: metaCombine.mangaMeta,
        updateStatus: true,
      );
    }
    emit(state.copyWith(
      metaCombine: metaCombine,
      readArray: readArray,
      chaptersInfo: chaptersInfo,
    ));
  }

  Future<void> addToFavoriteBox() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    await metaCombine.repo.putMangaMetaFavorite(metaCombine.mangaMeta);
    emit(state.copyWith(metaCombine: metaCombine, isFavorite: true));
    favoriteCubit.refreshUpdate();
  }

  Future<void> removeFromFavoriteBox() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    await metaCombine.repo.removeFavorite(metaCombine.mangaMeta.preId);
    emit(state.copyWith(metaCombine: metaCombine, isFavorite: false));
    favoriteCubit.refreshUpdate();
  }

  Future<void> markAsExceptionalFavorite() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    await metaCombine.repo.markAsExceptionalFavorite(metaCombine.mangaMeta.preId);
    emit(state.copyWith(metaCombine: metaCombine, isExceptional: true));
  }

  Future<void> removeAsExceptionalFavorite() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    await metaCombine.repo.removeExceptionalFavorite(metaCombine.mangaMeta.preId);
    emit(state.copyWith(metaCombine: metaCombine, isExceptional: false));
  }

  Future<void> addToRecentRead() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    List<RecentRead> recentList = hiveService.getRecentReadBox();
    RecentRead recentRead = RecentRead(metaCombine.mangaMeta, DateTime.now());
    if (recentList.length > 30) {
      recentList.removeAt(0);
    }
    if (recentList.contains(recentRead)) {
      recentList.remove(recentRead);
    }
    recentList.add(recentRead);
    await hiveService.putToRecentReadBox(recentList);
    recentCubit.renewRecent();
  }
}
