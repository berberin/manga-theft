import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';
import 'package:justice_mango/app/data/service/source_service.dart';

class ExploreStateData {
  // final TextEditingController textSearchController;
  final bool searchComplete;
  final bool searching;
  final List<MangaMetaCombine> mangaSearchResult;
  final List<MangaMetaCombine> randomMangaList;
  final String currentSearch;
  final int sourceSelected;
  final List<MangaRepository> sourceRepositories;

  const ExploreStateData({
    this.searchComplete = false,
    this.searching = false,
    this.mangaSearchResult = const <MangaMetaCombine>[],
    this.randomMangaList = const <MangaMetaCombine>[],
    this.currentSearch = '',
    this.sourceSelected = 0,
    this.sourceRepositories = const <MangaRepository>[],
  });

  ExploreStateData copyWith({
    bool? searchComplete,
    bool? searching,
    List<MangaMetaCombine>? mangaSearchResult,
    List<MangaMetaCombine>? randomMangaList,
    String? currentSearch,
    int? sourceSelected,
    List<MangaRepository>? sourceRepositories,
  }) {
    return ExploreStateData(
      searchComplete: searchComplete ?? this.searchComplete,
      searching: searching ?? this.searching,
      mangaSearchResult: mangaSearchResult ?? this.mangaSearchResult,
      randomMangaList: randomMangaList ?? this.randomMangaList,
      currentSearch: currentSearch ?? this.currentSearch,
      sourceSelected: sourceSelected ?? this.sourceSelected,
      sourceRepositories: sourceRepositories ?? this.sourceRepositories,
    );
  }
}

class ExploreStateNotifier extends StateNotifier<ExploreStateData> {
  ExploreStateNotifier() : super(const ExploreStateData()) {
    updateSources();
    // textSearchController = TextEditingController();
    // mangaSearchResult = <MangaMetaCombine>[].obs;
    // randomMangaList = <MangaMetaCombine>[].obs;
    getRandomManga();
  }

  updateSources() {
    List<MangaRepository> sourceRepositories = [];
    for (var repo in SourceService.sourceRepositories) {
      sourceRepositories.add(repo);
    }
    state = state.copyWith(sourceRepositories: sourceRepositories);
  }

  getRandomManga(
      {Duration delayedDuration = const Duration(seconds: 2)}) async {
    // note: wait hive db init first time
    await Future.delayed(delayedDuration);
    List<MangaMetaCombine> randomMangaList = [];
    MangaRepository repo = state.sourceRepositories[state.sourceSelected];
    List<MangaMeta> mangas = repo.getRandomManga(amount: 15);
    for (var meta in mangas) {
      randomMangaList.add(MangaMetaCombine(repo, meta));
    }
    state = state.copyWith(randomMangaList: randomMangaList);
  }

  search(String textSearch) async {
    if (textSearch.length <= 2 ||
        (textSearch == state.currentSearch && state.searchComplete) ||
        state.searching) {
      return;
    }
    clearSearch();
    state = state.copyWith(searching: true);
    List<MangaMetaCombine> mangaSearchResult = [];
    for (var repo in SourceService.sourceRepositories) {
      List<MangaMeta> metas = await repo.search(textSearch);
      if (metas.isNotEmpty) {
        for (var meta in metas) {
          mangaSearchResult.add(MangaMetaCombine(repo, meta));
        }
      }
    }
    state = state.copyWith(
      mangaSearchResult: mangaSearchResult,
      searchComplete: true,
      searching: false,
      currentSearch: textSearch,
    );
  }

  clearSearch() {
    state = state.copyWith(
      mangaSearchResult: [],
      searchComplete: false,
    );
  }

  changeSourceTab(int index) {
    state = state.copyWith(sourceSelected: index);
    getRandomManga(delayedDuration: const Duration());
  }
}

final exploreProvider =
    StateNotifierProvider<ExploreStateNotifier, ExploreStateData>(
        (ref) => ExploreStateNotifier());
