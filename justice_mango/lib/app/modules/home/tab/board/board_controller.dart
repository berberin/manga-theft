import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';
import 'package:manga_theft/app/data/service/background_context.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/tab/favorite/favorite_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardController extends GetxController {
  List<MangaMetaCombine> mangaBoard = <MangaMetaCombine>[].obs;
  List<MangaMetaCombine> favoriteUpdate = <MangaMetaCombine>[].obs;
  int sourceSelected = 0;
  List<MangaRepository> sourceRepositories = <MangaRepository>[].obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var avatarSvg =
      '<svg xmlns="https://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"></svg>'
          .obs;
  int page = 1;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateSources();
    getLatestList(page);
    getUpdateFavorite();
    getUID().then((value) {
      avatarSvg.value = Jdenticon.toSvg(
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
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  onRefresh() async {
    page = 1;
    try {
      var tmp =
          await sourceRepositories[sourceSelected].getLatestManga(page: page);
      mangaBoard.clear();
      for (var mangaMeta in tmp) {
        mangaBoard.add(
            MangaMetaCombine(SourceService.sourceRepositories[0], mangaMeta));
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
    getUpdateFavorite();
    refreshController.refreshCompleted();
  }

  onLoading() async {
    page++;
    getLatestList(page);
    refreshController.loadComplete();
  }

  getLatestList(int page) async {
    MangaRepository repo = sourceRepositories[sourceSelected];
    try {
      var tmp = await BackgroundContext.getMangaList(repo, page);
      for (var mangaMeta in tmp) {
        var mangaMetaCombine = MangaMetaCombine(repo, mangaMeta);
        if (!mangaBoard.contains(mangaMetaCombine)) {
          mangaBoard.add(mangaMetaCombine);
        }
      }
      repo.checkAndPutToMangaBox(tmp);
      hasError.value = false;
    } catch (e, stacktrace) {
      hasError.value = true;
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
  }

  getUpdateFavorite() async {
    favoriteUpdate.clear();
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

    for (var mangaMeta in favoriteMetas) {
      for (var repo in SourceService.allSourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          var chapterList = await repo.updateLastReadInfo(
            mangaMeta: mangaMeta,
            updateStatus: true,
          );

          // update latest chapters on favorite screen
          FavoriteController favoriteController = Get.find();
          favoriteController.latestChapters[mangaMeta.url] =
              chapterList.first.name ?? '';
          favoriteController.update();

          if (HiveService.getReadInfo(repo.slug + mangaMeta.preId)?.newUpdate ??
              false) {
            if (!favoriteUpdate.contains(MangaMetaCombine(repo, mangaMeta)) &&
                !repo.isExceptionalFavorite(mangaMeta.preId)) {
              favoriteUpdate.add(MangaMetaCombine(repo, mangaMeta));
            }
          }
          break;
        }
      }
    }
  }

  updateSources() {
    sourceRepositories.clear();
    for (var repo in SourceService.sourceRepositories) {
      sourceRepositories.add(repo);
    }
    sourceSelected = 0;
  }

  changeSourceTab(int index) {
    sourceSelected = index;
    page = 1;
    update();
    mangaBoard.clear();
    getLatestList(page);
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
}
