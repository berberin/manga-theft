import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/cache_service.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:justice_mango/app/modules/reader/reader_screen.dart';
import 'package:justice_mango/app/modules/reader/reader_screen_args.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReaderController extends GetxController {
  List<ChapterInfo> chaptersInfo;
  int index = 0;
  MangaMetaCombine metaCombine;

  List<String> preloadUrl;
  List<String> imgUrls;
  Rx<bool> hasError;

  ReaderController({this.chaptersInfo, this.index, this.metaCombine, this.preloadUrl}) {
    preloadUrl = <String>[];
    imgUrls = <String>[].obs;
    hasError = false.obs;
  }

  RefreshController refreshController;
  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    if ((preloadUrl?.length ?? 0) > 0) {
      imgUrls.assignAll(preloadUrl);
    } else {
      getPages();
    }
    getPreloadPages();
    MangaDetailController mangaDetailController = Get.find(tag: metaCombine.mangaMeta.preId);
    mangaDetailController.setIsRead(index);
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void getPages() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      imgUrls.assignAll(await metaCombine.repo.getPages(chaptersInfo[index].url));
      hasError.value = false;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      hasError.value = true;
    }
  }

  void getPreloadPages() async {
    if (index - 1 < 0) {
      return;
    }
    await Future.delayed(Duration(seconds: 2));
    metaCombine.repo.getPages(chaptersInfo[index].url).then((value) {
      preloadUrl.assignAll(value);
      for (var url in preloadUrl) {
        CacheService.getImage(url, metaCombine.repo);
      }
    });
  }

  void toNextChapter() async {
    if (index - 1 >= 0) {
      // note: getx xử lý vụ controller route cùng tên khá tệ (thường kết thúc với việc controller bị delete mà không được tạo lại)
      // --> xử lý chuyển chương trong cùng controller:
      // index = index - 1;
      // if ((preloadUrl?.length ?? 0) > 0) {
      //   imgUrls.assignAll(preloadUrl);
      //   preloadUrl.clear();
      //   getPreloadPages();
      // } else {
      //   getPages();
      //   getPreloadPages();
      // }

      // Get.offNamed(
      //   Routes.READER,
      //   preventDuplicates: false,
      //   arguments: ReaderScreenArgs(
      //     index: index - 1,
      //     chaptersInfo: chaptersInfo,
      //     metaCombine: metaCombine,
      //     preloadUrl: preloadUrl,
      //   ),
      // );
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
    } else
      refreshController.loadFailed();
  }

  void toPrevChapter() async {
    if (index + 1 < chaptersInfo.length) {
      // tối ưu preload url
      index = index + 1;
      update();
      if ((imgUrls?.length ?? 0) > 0) {
        preloadUrl.assignAll(imgUrls);
        imgUrls.clear();
        getPages();
      } else {
        getPages();
        getPreloadPages();
      }
      refreshController.refreshCompleted();
    } else
      refreshController.refreshFailed();
  }
}
