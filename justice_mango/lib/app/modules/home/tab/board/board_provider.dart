import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';
import 'package:justice_mango/app/data/service/background_context.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class BoardStateData {
  final List<MangaMetaCombine> mangaBoard;
  final List<MangaMetaCombine> favoriteUpdate;
  final int sourceSelected;
  final List<MangaRepository> sourceRepositories;
  final String avatarSvg;
  final int page;
  final bool hasError;

  const BoardStateData({
    this.mangaBoard = const <MangaMetaCombine>[],
    this.favoriteUpdate = const <MangaMetaCombine>[],
    this.sourceSelected = 0,
    this.sourceRepositories = const <MangaRepository>[],
    this.avatarSvg =
        '<svg xmlns="https://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"></svg>',
    this.page = 1,
    this.hasError = false,
  });

  BoardStateData copyWith({
    List<MangaMetaCombine>? mangaBoard,
    List<MangaMetaCombine>? favoriteUpdate,
    int? sourceSelected,
    List<MangaRepository>? sourceRepositories,
    String? avatarSvg,
    int? page,
    bool? hasError,
  }) {
    return BoardStateData(
      mangaBoard: mangaBoard ?? this.mangaBoard,
      favoriteUpdate: favoriteUpdate ?? this.favoriteUpdate,
      sourceSelected: sourceSelected ?? this.sourceSelected,
      sourceRepositories: sourceRepositories ?? this.sourceRepositories,
      avatarSvg: avatarSvg ?? this.avatarSvg,
      page: page ?? this.page,
      hasError: hasError ?? this.hasError,
    );
  }
}

class BoardStateProvider extends StateNotifier<BoardStateData> {
  BoardStateProvider() : super(const BoardStateData()) {
    updateSources();
    getLatestList();
    getUpdateFavorite();
    getUID().then((value) {
      var avatarSvg = state.avatarSvg;
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
      state = state.copyWith(avatarSvg: avatarSvg);
    });
  }

  updateSources() {
    List<MangaRepository> sourceRepositories = [];
    for (var repo in SourceService.sourceRepositories) {
      sourceRepositories.add(repo);
    }
    state = state.copyWith(sourceRepositories: sourceRepositories);
  }

  getLatestList() async {
    MangaRepository repo = state.sourceRepositories[state.sourceSelected];
    try {
      var tmp = await BackgroundContext.getMangaList(repo, state.page);
      List<MangaMetaCombine> tmpManga = [];
      for (var mangaMeta in tmp) {
        var mangaMetaCombine = MangaMetaCombine(repo, mangaMeta);
        if (!state.mangaBoard.contains(mangaMetaCombine)) {
          tmpManga.add(mangaMetaCombine);
        }
      }
      repo.checkAndPutToMangaBox(tmp);
      state = state.copyWith(
        mangaBoard: [...state.mangaBoard, ...tmpManga],
        hasError: false,
      );
    } catch (e, stacktrace) {
      state = state.copyWith(hasError: true);
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
  }

  getUpdateFavorite() async {
    final List<MangaMetaCombine> favoriteUpdate = [];
    var favoriteMetas = HiveService.favoriteBox.values.toList();
    // get instantly
    for (var mangaMeta in favoriteMetas) {
      if (HiveService.getReadInfo(mangaMeta.repoSlug + mangaMeta.preId)
              ?.newUpdate ??
          false) {
        for (var repo in SourceService.allSourceRepositories) {
          if (repo.slug == mangaMeta.repoSlug) {
            if (repo.isExceptionalFavorite(mangaMeta.preId)) {
              break;
            }
            favoriteUpdate.add(MangaMetaCombine(repo, mangaMeta));
            break;
          }
        }
      }
    }
    state = state.copyWith(favoriteUpdate: favoriteUpdate);
  }

  Future<String> getUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uid = preferences.getString('uid');
    if (uid == null) {
      uid = randomString(10);
      await preferences.setString('uid', uid);
    }
    return uid;
  }

  changeSourceTab(int index) {
    state = state.copyWith(
      sourceSelected: index,
      page: 1,
      mangaBoard: [],
    );
    getLatestList();
  }

  refreshBoard() async {
    state = state.copyWith(page: 1, mangaBoard: []);
    try {
      var tmp = await state.sourceRepositories[state.sourceSelected]
          .getLatestManga(page: state.page);
      List<MangaMetaCombine> mangaBoard = [];
      for (var mangaMeta in tmp) {
        mangaBoard.add(
            MangaMetaCombine(SourceService.sourceRepositories[0], mangaMeta));
      }
      state = state.copyWith(mangaBoard: mangaBoard);
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
    getUpdateFavorite();
  }

  loadMoreBoard() async {
    int page = state.page;
    state = state.copyWith(page: page++);
    getLatestList();
  }
}

final boardProvider = StateNotifierProvider<BoardStateProvider, BoardStateData>(
    (ref) => BoardStateProvider());
