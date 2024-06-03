import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';
import 'package:manga_theft/app/data/service/source_service.dart';

class ExploreController extends GetxController {
  late TextEditingController textSearchController;
  var searchComplete = false.obs;
  bool searching = false;
  late List<MangaMetaCombine> mangaSearchResult;
  late List<MangaMetaCombine> randomMangaList;
  String currentSearch = '';
  int sourceSelected = 0;
  List<MangaRepository> sourceRepositories = <MangaRepository>[];

  @override
  void onInit() {
    super.onInit();
    updateSources();
    textSearchController = TextEditingController();
    mangaSearchResult = <MangaMetaCombine>[].obs;
    randomMangaList = <MangaMetaCombine>[].obs;
    getRandomManga();
  }

  search() async {
    String textSearch = textSearchController.text;
    if (textSearch.length <= 2 ||
        (textSearch == currentSearch && searchComplete.value) ||
        searching) {
      return;
    }
    clearSearch();
    searching = true;
    for (var repo in SourceService.sourceRepositories) {
      List<MangaMeta> metas = await repo.search(textSearch);
      if (metas.isNotEmpty) {
        for (var meta in metas) {
          mangaSearchResult.add(MangaMetaCombine(repo, meta));
        }
      }
    }
    searchComplete.value = true;
    searching = false;
    currentSearch = textSearch;
  }

  clearSearch() {
    mangaSearchResult.clear();
    searchComplete.value = false;
  }

  clearTextField() {
    textSearchController.text = '';
  }

  getRandomManga(
      {Duration delayedDuration = const Duration(seconds: 2)}) async {
    // note: wait hive db init first time
    await Future.delayed(delayedDuration);
    randomMangaList.clear();
    MangaRepository repo = sourceRepositories[sourceSelected];
    List<MangaMeta> mangas = repo.getRandomManga(amount: 15);
    for (var meta in mangas) {
      randomMangaList.add(MangaMetaCombine(repo, meta));
    }
  }

  changeSourceTab(int index) {
    sourceSelected = index;
    update();
    getRandomManga(delayedDuration: const Duration());
  }

  updateSources() {
    for (var repo in SourceService.sourceRepositories) {
      sourceRepositories.add(repo);
    }
    sourceSelected = 0;
  }
}
