import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/cache_service.dart';
import 'package:manga_theft/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:manga_theft/app/modules/reader/reader_screen.dart';
import 'package:manga_theft/app/modules/reader/reader_screen_args.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReaderController extends GetxController {
  List<ChapterInfo> chaptersInfo;
  int index = 0;
  MangaMetaCombine metaCombine;

  late List<String> preloadUrl;
  late List<String> imgUrls;
  late Rx<bool> hasError;
  late Rx<bool> loading;

  ReaderController(
      {required this.chaptersInfo,
      required this.index,
      required this.metaCombine,
      required this.preloadUrl}) {
    imgUrls = <String>[].obs;
    hasError = false.obs;
    loading = false.obs;
  }

  late RefreshController refreshController;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    if (preloadUrl.isNotEmpty) {
      imgUrls.assignAll(preloadUrl);
    } else {
      getPages();
    }
    getPreloadPages();
    MangaDetailController mangaDetailController =
        Get.find(tag: metaCombine.mangaMeta.preId);
    mangaDetailController.setIsRead(index);
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void getPages() async {
    //await Future.delayed(Duration(seconds: 2));
    loading.value = true;
    try {
      imgUrls.assignAll(
          await metaCombine.repo.getPages(chaptersInfo[index].url ?? ''));
      hasError.value = false;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }

      hasError.value = true;
    }
    loading.value = false;
  }

  void getPreloadPages() async {
    if (index - 1 < 0) {
      return;
    }
    await Future.delayed(const Duration(seconds: 5));
    metaCombine.repo.getPages(chaptersInfo[index - 1].url ?? '').then((value) {
      preloadUrl.assignAll(value);
      for (var url in preloadUrl) {
        CacheService.getImage(url, metaCombine.repo);
      }
    });
  }

  void toNextChapter() async {
    if (index - 1 >= 0) {
      Get.off(
        () => ReaderScreen(
          readerScreenArgs: ReaderScreenArgs(
            chaptersInfo: chaptersInfo,
            index: index - 1,
            metaCombine: metaCombine,
            preloadUrl: preloadUrl,
          ),
        ),
        // Getx prevent duplicate routes by default
        preventDuplicates: false,
      );
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
  }

  void toPrevChapter() async {
    if (index + 1 < chaptersInfo.length) {
      // tối ưu preload url
      index = index + 1;
      update();
      if (imgUrls.isNotEmpty) {
        preloadUrl.assignAll(imgUrls);
        imgUrls.clear();
        getPages();
      } else {
        getPages();
        getPreloadPages();
      }
      refreshController.refreshCompleted();
      MangaDetailController mangaDetailController =
          Get.find(tag: metaCombine.mangaMeta.preId);
      mangaDetailController.setIsRead(index);
    } else {
      refreshController.refreshFailed();
    }
  }
}
