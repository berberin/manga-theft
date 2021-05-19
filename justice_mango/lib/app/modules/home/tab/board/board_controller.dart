import 'package:get/get.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardController extends GetxController {
  @override
  void onInit() {
    super.onInit();
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

  // observe
  List<MangaMetaCombine> mangaBoard = <MangaMetaCombine>[].obs;

  // todo: favorite update
  List<MangaMetaCombine> favoriteUpdate = <MangaMetaCombine>[].obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  var avatarSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64"></svg>'.obs;
  int page = 1;
  var hasError = false.obs;

  onRefresh() async {
    page = 1;
    try {
      var tmp = await SourceService.sourceRepositories[0].getLatestManga(page: page);
      mangaBoard.clear();
      for (var mangaMeta in tmp) {
        mangaBoard.add(MangaMetaCombine(SourceService.sourceRepositories[0], mangaMeta));
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    for (int i = 1; i < SourceService.sourceRepositories.length; i++) {
      var tmp = await SourceService.sourceRepositories[i].getLatestManga(page: page);
      for (var mangaMeta in tmp) {
        mangaBoard.add(MangaMetaCombine(SourceService.sourceRepositories[i], mangaMeta));
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
    for (var repo in SourceService.sourceRepositories) {
      try {
        var tmp = await repo.getLatestManga(page: page);
        for (var mangaMeta in tmp) {
          mangaBoard.add(MangaMetaCombine(repo, mangaMeta));
        }
        hasError.value = false;
      } catch (e, stacktrace) {
        hasError.value = true;
        print(e);
        print(stacktrace);
      }
    }
  }

  getUpdateFavorite() async {
    favoriteUpdate.clear();
    var favoriteMetas = HiveService.favoriteBox.values.toList();
    // get instantly
    // for (var mangaMeta in favoriteMetas) {
    //   if (HiveService.getReadInfo(mangaMeta.repoSlug + mangaMeta.preId).newUpdate ?? false) {
    //     for (var repo in SourceService.allSourceRepositories) {
    //       if (repo.slug == mangaMeta.repoSlug) {
    //         favoriteUpdate.add(MangaMetaCombine(repo, mangaMeta));
    //       }
    //     }
    //   }
    // }

    for (var mangaMeta in favoriteMetas) {
      for (var repo in SourceService.allSourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          await repo.updateLastReadInfo(
            preId: mangaMeta.preId,
            updateStatus: true,
          );
          if (HiveService.getReadInfo(repo.slug + mangaMeta.preId).newUpdate ?? false) {
            favoriteUpdate.add(MangaMetaCombine(repo, mangaMeta));
          }
          break;
        }
      }
    }
  }

  Future<String> getUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString('uid');
    if (uid == null) {
      uid = randomString(10);
      await preferences.setString('uid', uid);
    }
    return uid;
  }
}
