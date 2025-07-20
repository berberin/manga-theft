import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/cubit/explore/explore_state.dart';

import '../../../../data/model/manga_meta.dart';
import '../../../../data/repository/manga_repository.dart';

@injectable
class ExploreCubit extends Cubit<ExploreState> {
  final SourceService sourceService;

  ExploreCubit(this.sourceService) : super(const ExploreState());

  TextEditingController textSearchController = TextEditingController();
  bool isSearching = false;
  String currentSearch = '';
  int sourceIndex = 0;

  void init() {
    try {
      emit(state.copyWith(status: BaseStatus.loading));
      updateSources();
      getRandomManga();
      emit(state.copyWith(status: BaseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.failed, error: e.toString()));
    }
  }

  void updateSources() {
    List<MangaRepository> srcRepositories = state.sourceRepositories;
    for (var repo in sourceService.sourceRepositories) {
      srcRepositories.add(repo);
    }
    sourceIndex = 0;
    emit(state.copyWith(sourceRepositories: srcRepositories));
  }

  void getRandomManga({Duration delayedDuration = const Duration(seconds: 2)}) async {
    // note: wait hive db init first time
    await Future.delayed(delayedDuration);
    emit(state.copyWith(listRandomManga: []));
    List<MangaMetaCombine> listRandomManga = [];
    MangaRepository repo = state.sourceRepositories[sourceIndex];
    List<MangaMeta> mangas = repo.getRandomManga(amount: 15);
    for (var meta in mangas) {
      listRandomManga.add(MangaMetaCombine(repo, meta));
    }
    emit(state.copyWith(listRandomManga: listRandomManga));
  }

  void search() async {
    String textSearch = textSearchController.text;
    if (textSearch.length <= 2 || (textSearch == currentSearch && state.isSearchComplete) || isSearching) {
      return;
    }
    clearSearch();
    isSearching = true;
    List<MangaMetaCombine> listSearchResultManga = [];
    for (var repo in sourceService.sourceRepositories) {
      List<MangaMeta> metas = await repo.search(textSearch);
      if (metas.isNotEmpty) {
        for (var meta in metas) {
          listSearchResultManga.add(MangaMetaCombine(repo, meta));
        }
      }
    }
    isSearching = false;
    currentSearch = textSearch;
    emit(state.copyWith(listSearchResultManga: listSearchResultManga, isSearchComplete: true));
  }

  void clearSearch() {
    emit(state.copyWith(listSearchResultManga: [], isSearchComplete: false));
  }

  void clearTextField() {
    textSearchController.text = '';
  }

  void changeSourceTab(int index) {
    sourceIndex = index;
    getRandomManga(delayedDuration: const Duration());
  }
}
