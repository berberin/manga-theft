import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:justice_mango/app/modules/reader/reader_screen_args.dart';
import 'package:justice_mango/app/route/routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReaderController extends GetxController {
  List<ChapterInfo> chaptersInfo;
  var index = 0.obs;
  MangaMetaCombine metaCombine;

  List<String> preloadUrl = <String>[];
  List<String> imgUrls = <String>[].obs;
  var hasError = false.obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    ReaderScreenArgs args = Get.arguments;
    chaptersInfo = args.chaptersInfo;
    index.value = args.index;
    metaCombine = args.metaCombine;
    if ((preloadUrl?.length ?? 0) > 0) {
      imgUrls.assignAll(preloadUrl);
    } else {
      getPages();
    }
    getPreloadPages();
    MangaDetailController mangaDetailController = Get.find();
    mangaDetailController.setIsRead(index.value);
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void getPages() async {
    try {
      imgUrls.assignAll(await metaCombine.repo.getPages(chaptersInfo[index.value].url));
      hasError.value = false;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      hasError.value = true;
    }
  }

  void getPreloadPages() async {
    if (index.value - 1 < 0) {
      return;
    }
    await Future.delayed(Duration(seconds: 2));
    metaCombine.repo.getPages(chaptersInfo[index.value].url).then((value) {
      preloadUrl.assignAll(value);
      // for (var url in _preloadUrl) {
      //   CacheProvider.getImage(url);
      // }
      // todo: get cache
    });
  }

  void toNextChapter() async {
    if (index.value - 1 >= 0) {
      // note: getx xử lý vụ controller route cùng tên khá tệ (thường kết thúc với việc controller bị delete mà không được tạo lại)
      // --> xử lý chuyển chương trong cùng controller:
      // index.value = index.value - 1;
      // if ((preloadUrl?.length ?? 0) > 0) {
      //   imgUrls.assignAll(preloadUrl);
      //   preloadUrl.clear();
      //   getPreloadPages();
      // } else {
      //   getPages();
      //   getPreloadPages();
      // }

      // note: preventDuplicate: false để tránh lỗi việc remove container (sẽ được tạo mới, không quan tâm cái cũ)
      Get.offNamed(
        Routes.READER,
        //preventDuplicates: false,
        arguments: ReaderScreenArgs(
          index: index.value - 1,
          chaptersInfo: chaptersInfo,
          metaCombine: metaCombine,
          preloadUrl: preloadUrl,
        ),
      );
      refreshController.loadComplete();
    } else
      refreshController.loadFailed();
  }

  void toPrevChapter() async {
    if (index.value + 1 < chaptersInfo.length) {
      // xử lý để tối ưu preload url
      index.value = index.value + 1;
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
