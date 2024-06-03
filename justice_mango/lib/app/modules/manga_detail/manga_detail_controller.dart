import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/model/recent_read.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/modules/home/tab/favorite/favorite_controller.dart';
import 'package:manga_theft/app/modules/home/tab/recent/recent_controller.dart';
import 'package:manga_theft/app/modules/reader/reader_screen.dart';
import 'package:manga_theft/app/modules/reader/reader_screen_args.dart';

class MangaDetailController extends GetxController {
  MangaMetaCombine metaCombine;
  late Rx<bool> isFavorite;
  late Rx<bool> isExceptional;
  late List<ChapterInfo> chaptersInfo;
  late List<bool> readArray;

  MangaDetailController({required this.metaCombine}) {
    isFavorite = false.obs;
    isExceptional = false.obs;
    chaptersInfo = <ChapterInfo>[].obs;
    readArray = <bool>[];
  }

  @override
  void onInit() {
    super.onInit();
    isFavorite.value = metaCombine.repo.isFavorite(metaCombine.mangaMeta.preId);
    isExceptional.value =
        metaCombine.repo.isExceptionalFavorite(metaCombine.mangaMeta.preId);
    metaCombine.repo
        .updateLastReadInfo(mangaMeta: metaCombine.mangaMeta)
        .then((value) {
      chaptersInfo.assignAll(value);
      for (var chapter in chaptersInfo) {
        readArray.add(metaCombine.repo.isRead(chapter.preChapterId));
      }
    });
  }

  goToLastReadChapter() {
    Get.to(
      () => ReaderScreen(
        readerScreenArgs: ReaderScreenArgs(
          chaptersInfo: chaptersInfo,
          index:
              metaCombine.repo.getLastReadIndex(metaCombine.mangaMeta.preId) ??
                  0,
          metaCombine: metaCombine,
        ),
      ),
    );
  }

  setIsRead(int index) async {
    await metaCombine.repo
        .markAsRead(chaptersInfo[index].preChapterId, chaptersInfo[index]);
    await metaCombine.repo.updateLastReadIndex(
      preId: metaCombine.mangaMeta.preId,
      readIndex: index,
    );
    readArray[index] = true;
    // mục đích delay: để hiển thị đã đọc không xuất hiện trước khi vào màn đọc [ux]
    await Future.delayed(const Duration(seconds: 1));
    update();
    if (index == 0) {
      metaCombine.repo.updateLastReadInfo(
        mangaMeta: metaCombine.mangaMeta,
        updateStatus: true,
      );
    }
  }

  addToFavoriteBox() async {
    await metaCombine.repo.putMangaMetaFavorite(metaCombine.mangaMeta);
    isFavorite.value = true;
    FavoriteController favoriteTabController = Get.find();
    favoriteTabController.refreshUpdate();
  }

  markAsExceptionalFavorite() async {
    await metaCombine.repo
        .markAsExceptionalFavorite(metaCombine.mangaMeta.preId);
    isExceptional.value = true;
  }

  removeAsExceptionalFavorite() async {
    await metaCombine.repo
        .removeExceptionalFavorite(metaCombine.mangaMeta.preId);
    isExceptional.value = false;
  }

  removeFromFavoriteBox() async {
    await metaCombine.repo.removeFavorite(metaCombine.mangaMeta.preId);
    isFavorite.value = false;
    FavoriteController favoriteTabController = Get.find();
    favoriteTabController.refreshUpdate();
  }

  addToRecentRead() async {
    List<RecentRead> recentList = HiveService.getRecentReadBox();
    RecentRead recentRead = RecentRead(metaCombine.mangaMeta, DateTime.now());
    if (recentList.length > 30) {
      recentList.removeAt(0);
    }
    if (recentList.contains(recentRead)) {
      recentList.remove(recentRead);
    }
    recentList.add(recentRead);
    await HiveService.putToRecentReadBox(recentList);
    RecentController recentController = Get.find();
    recentController.renewRecent();
  }
}
