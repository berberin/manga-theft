import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/cache_service.dart';
import 'package:manga_theft/app/modules/manga_detail/cubit/manga_detail_cubit.dart';
import 'package:manga_theft/app/modules/reader/cubit/reader_state.dart';
import 'package:manga_theft/app/route/app_route.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../presentation/widget/reader_screen_args.dart';

@injectable
class ReaderCubit extends Cubit<ReaderState> {
  final MangaDetailCubit mangaDetailCubit;
  final CacheService cacheService;
  final AppRoute appRoute;

  ReaderCubit(this.mangaDetailCubit, this.cacheService, this.appRoute) : super(const ReaderState());

  late RefreshController refreshController;

  void init(
    List<ChapterInfo> chaptersInfo,
    int index,
    MangaMetaCombine mangaMetaCombine,
    List<String> preloadUrl,
  ) {
    try {
      emit(state.copyWith(
        status: BaseStatus.loading,
        chaptersInfo: chaptersInfo,
        currentIndex: index,
        metaCombine: mangaMetaCombine,
        preloadUrl: preloadUrl,
      ));
      refreshController = RefreshController(initialRefresh: false);
      if (preloadUrl.isNotEmpty) {
        emit(state.copyWith(imgUrls: preloadUrl));
      } else {
        getPages();
      }
      getPreloadPages();
      mangaDetailCubit.setIsRead(index);
      emit(state.copyWith(status: BaseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.failed, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  Future<void> getPages() async {
    if (state.metaCombine == null) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    emit(state.copyWith(
      imgUrls: await metaCombine.repo.getPages(state.chaptersInfo[state.currentIndex].url ?? ''),
      metaCombine: metaCombine,
      error: null,
    ));
  }

  Future<void> getPreloadPages() async {
    if (state.metaCombine == null) {
      return;
    }
    int index = state.currentIndex;
    if (state.currentIndex - 1 < 0) {
      return;
    }
    MangaMetaCombine metaCombine = state.metaCombine!;
    await Future.delayed(const Duration(seconds: 5));
    metaCombine.repo.getPages(state.chaptersInfo[index - 1].url ?? '').then((value) {
      for (var url in value) {
        cacheService.getImage(url, metaCombine.repo);
      }
      emit(state.copyWith(preloadUrl: value, metaCombine: metaCombine, currentIndex: index));
    });
  }

  Future<void> toNextChapter() async {
    if (state.metaCombine == null) {
      return;
    }
    int index = state.currentIndex;
    if (index - 1 >= 0) {
      appRoute.replace(
        ReaderRoute(
          readerScreenArgs: ReaderScreenArgs(
            chaptersInfo: state.chaptersInfo,
            index: index - 1,
            metaCombine: state.metaCombine!,
            preloadUrl: state.preloadUrl,
          ),
        ),
      );
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
  }

  Future<void> toPrevChapter() async {
    if (state.metaCombine == null) {
      return;
    }
    int index = state.currentIndex;
    List<String> imgUrls = state.imgUrls;
    if (index + 1 < state.chaptersInfo.length) {
      // tối ưu preload url
      index = index + 1;
      if (imgUrls.isNotEmpty) {
        emit(state.copyWith(preloadUrl: imgUrls, imgUrls: []));
        getPages();
      } else {
        getPages();
        getPreloadPages();
      }
      refreshController.refreshCompleted();
      mangaDetailCubit.setIsRead(index);
    } else {
      refreshController.refreshFailed();
    }
  }
}
