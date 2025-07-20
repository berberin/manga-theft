import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/data/service/background_context.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/cubit/favorite/favorite_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/home_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/model/manga_meta_combine.dart';
import '../../../../data/repository/manga_repository.dart';
import 'board_state.dart';

@injectable
class BoardCubit extends Cubit<BoardState> {
  final SourceService sourceService;
  final BackgroundContext backgroundContext;
  final HiveService hiveService;
  final FavoriteCubit favoriteCubit;
  final HomeCubit homeCubit;

  BoardCubit(
    this.sourceService,
    this.backgroundContext,
    this.hiveService,
    this.favoriteCubit,
    this.homeCubit,
  ) : super(BoardState());

  var avatarSvg = '<svg xmlns="https://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"></svg>';
  int page = 1;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  late SharedPreferences sharedPreferences;

  void init() async {
    try {
      emit(state.copyWith(status: BaseStatus.loading));
      sharedPreferences = await SharedPreferences.getInstance();
      updateSources();
      getLatestList(page);
      getUpdateFavorite();
      getUID().then((value) {
        avatarSvg = Jdenticon.toSvg(
          value,
          colorSaturation: 0.48,
          grayscaleSaturation: 0.48,
          colorLightnessMinValue: 0.84,
          colorLightnessMaxValue: 0.84,
          grayscaleLightnessMinValue: 0.84,
          grayscaleLightnessMaxValue: 0.84,
          backColor: '#2a4766ff',
          hues: [207],
        );
      });
      emit(state.copyWith(status: BaseStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.failed,
        error: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  void updateSources() {
    // clear list src repo
    emit(state.copyWith(sourceRepositories: []));
    List<MangaRepository> sourceRepositories = <MangaRepository>[];
    for (var repo in sourceService.sourceRepositories) {
      sourceRepositories.add(repo);
    }
    emit(state.copyWith(sourceRepositories: sourceRepositories));
  }

  void getLatestList(int page) async {
    MangaRepository repo = state.sourceRepositories[state.sourceIndex];
    List<MangaMetaCombine> listBoardManga = state.listBoardManga;
    var tmp = await backgroundContext.getMangaList(repo, page);
    for (var mangaMeta in tmp) {
      var mangaMetaCombine = MangaMetaCombine(repo, mangaMeta);
      if (!listBoardManga.contains(mangaMetaCombine)) {
        listBoardManga.add(mangaMetaCombine);
      }
    }
    repo.checkAndPutToMangaBox(tmp);
    emit(state.copyWith(listBoardManga: listBoardManga));
  }

  void getUpdateFavorite() async {
    //clear list favorite update
    emit(state.copyWith(listFavoriteUpdateManga: []));
    List<MangaMetaCombine> listFavoriteUpdateManga = [];
    var favoriteMetas = hiveService.favoriteBox.values.toList();
    // get instantly
    for (var mangaMeta in favoriteMetas) {
      if (hiveService.getReadInfo(mangaMeta.repoSlug + mangaMeta.preId)?.newUpdate ?? false) {
        for (var repo in sourceService.allSourceRepositories) {
          if (repo.slug == mangaMeta.repoSlug) {
            if (repo.isExceptionalFavorite(mangaMeta.preId)) {
              break;
            }
            listFavoriteUpdateManga.add(MangaMetaCombine(repo, mangaMeta));
            break;
          }
        }
      }
    }

    for (var mangaMeta in favoriteMetas) {
      for (var repo in sourceService.allSourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          var chapterList = await repo.updateLastReadInfo(
            mangaMeta: mangaMeta,
            updateStatus: true,
            xClientId: "",
          );

          // update latest chapters on favorite screen
          favoriteCubit.updateLastestChapter(mangaMeta.url, chapterList.first.name);

          if (hiveService.getReadInfo(repo.slug + mangaMeta.preId)?.newUpdate ?? false) {
            if (!listFavoriteUpdateManga.contains(MangaMetaCombine(repo, mangaMeta)) &&
                !repo.isExceptionalFavorite(mangaMeta.preId)) {
              listFavoriteUpdateManga.add(MangaMetaCombine(repo, mangaMeta));
            }
          }
          break;
        }
      }
    }

    emit(state.copyWith(listFavoriteUpdateManga: listFavoriteUpdateManga));
  }

  void onRefresh() async {
    page = 1;
    try {
      var tmp = await state.sourceRepositories[state.sourceIndex].getLatestManga(page: page);
      emit(state.copyWith(listBoardManga: []));
      List<MangaMetaCombine> listBoardManga = [];
      for (var mangaMeta in tmp) {
        listBoardManga.add(MangaMetaCombine(sourceService.sourceRepositories[0], mangaMeta));
      }
      emit(state.copyWith(listBoardManga: listBoardManga));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
    getUpdateFavorite();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    page++;
    getLatestList(page);
    refreshController.loadComplete();
  }

  void changeSourceTab(int index) {
    page = 1;
    emit(state.copyWith(sourceIndex: index, listBoardManga: []));
    getLatestList(page);
  }

  Future<String> getUID() async {
    String? uid = sharedPreferences.getString('uid');
    if (uid == null || uid.isEmpty) {
      uid = randomString(10);
      await sharedPreferences.setString('uid', uid);
    }
    return uid;
  }

  void switchHomeTabByIndex(int index) {
    homeCubit.switchToIndex(index);
  }
}
