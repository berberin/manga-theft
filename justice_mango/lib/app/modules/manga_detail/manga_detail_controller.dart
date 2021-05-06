import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_controller.dart';

class MangaDetailController extends GetxController {
  MangaMetaCombine metaCombine;
  Rx<bool> isFavorite;
  List<ChapterInfo> chaptersInfo;
  List<bool> readArray;

  MangaDetailController({this.metaCombine}) {
    isFavorite = false.obs;
    chaptersInfo = <ChapterInfo>[].obs;
    readArray = <bool>[];
  }

  @override
  void onInit() {
    super.onInit();
    isFavorite.value = metaCombine.repo.isFavorite(metaCombine.mangaMeta.preId);
    metaCombine.repo.getChaptersInfo(metaCombine.mangaMeta.preId).then((value) {
      chaptersInfo.assignAll(value);
      for (var chapter in chaptersInfo) {
        readArray.add(metaCombine.repo.isRead(chapter.preChapterId));
      }
    });
  }

  goToLastReadChapter() {
    //todo: implement
  }

  setIsRead(int index) async {
    // mục đích delay: để hiển thị đã đọc không xuất hiện trước khi vào màn đọc
    await Future.delayed(Duration(seconds: 1));
    await metaCombine.repo.markAsRead(chaptersInfo[index].preChapterId, chaptersInfo[index]);
    readArray[index] = true;
    update();
  }

  addToFavoriteBox() async {
    await metaCombine.repo.putMangaMetaFavorite(metaCombine.mangaMeta);
    isFavorite.value = true;
    FavoriteController favoriteTabController = Get.find();
    favoriteTabController.refreshUpdate();
  }

  removeFromFavoriteBox() async {
    await metaCombine.repo.removeFavorite(metaCombine.mangaMeta.preId);
    isFavorite.value = false;
    FavoriteController favoriteTabController = Get.find();
    favoriteTabController.refreshUpdate();
  }
}
