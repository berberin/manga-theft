import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';

class ExploreController extends GetxController {
  TextEditingController textSearchController;
  var searchComplete = false.obs;
  List<MangaMetaCombine> mangaSearchResult;
  List<MangaMetaCombine> randomMangaList;
  String currentSearch;

  @override
  void onInit() {
    super.onInit();
    textSearchController = TextEditingController();
    mangaSearchResult = <MangaMetaCombine>[].obs;
    randomMangaList = <MangaMetaCombine>[].obs;
    getRandomManga();
  }

  search() async {
    String textSearch = textSearchController.text;
    if (textSearch.length <= 2 || (textSearch == currentSearch && searchComplete.value)) {
      return;
    }
    clearSearch();
    for (var repo in SourceService.sourceRepositories) {
      List<MangaMeta> metas = await repo.search(textSearch);
      for (var meta in metas) {
        mangaSearchResult.add(MangaMetaCombine(repo, meta));
      }
    }
    searchComplete.value = true;
    currentSearch = textSearch;
  }

  clearSearch() {
    mangaSearchResult.clear();
    searchComplete.value = false;
  }

  getRandomManga({Duration delayedDuration: const Duration(seconds: 2)}) async {
    // note: wait hive db init first time
    await Future.delayed(delayedDuration);
    int boxLength = HiveService.mangaBox.length;
    Random random = Random();
    randomMangaList.clear();
    for (int i = 0; i < 30; i++) {
      var index = random.nextInt(boxLength);
      var mangaMeta = HiveService.mangaBox.getAt(index);
      for (var repo in SourceService.sourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          randomMangaList.add(MangaMetaCombine(repo, mangaMeta));
          break;
        }
      }
    }
  }
}
