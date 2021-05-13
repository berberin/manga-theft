import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';

class ExploreController extends GetxController {
  TextEditingController textSearchController;
  bool searchComplete;
  List<MangaMetaCombine> mangaSearchResult;
  List<MangaMetaCombine> randomMangaList;

  @override
  void onInit() {
    super.onInit();
    textSearchController = TextEditingController();
    searchComplete = false;
    mangaSearchResult = <MangaMetaCombine>[].obs;
    randomMangaList = <MangaMetaCombine>[].obs;
    getRandomManga();
  }

  search() async {
    String textSearch = textSearchController.text;
    if (textSearch.length <= 2) {
      return;
    }
    for (var repo in SourceService.sourceRepositories) {
      List<MangaMeta> metas = await repo.search(textSearch);
      for (var meta in metas) {
        mangaSearchResult.add(MangaMetaCombine(repo, meta));
      }
    }
    searchComplete = true;
  }

  clearSearch() {
    mangaSearchResult.clear();
    searchComplete = false;
  }

  getRandomManga() async {
    var mangaKeys = HiveService.mangaBox.keys.toList();
    mangaKeys.shuffle();
    for (int i = 0; i < 30; i++) {
      var mangaMeta = HiveService.getMangaMeta(mangaKeys[i]);
      for (var repo in SourceService.sourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          randomMangaList.add(MangaMetaCombine(repo, mangaMeta));
          break;
        }
      }
    }
  }
}
