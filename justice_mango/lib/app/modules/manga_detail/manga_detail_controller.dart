import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_controller.dart';

class MangaDetailController extends GetxController {
  MangaMetaCombine metaCombine;
  var isFavorite = false.obs;
  var chaptersInfo = <ChapterInfo>[].obs;
  var readArray = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      metaCombine = Get.arguments['metaCombine'];
      isFavorite.value = metaCombine.repo.isFavorite(metaCombine.mangaMeta.preId);
      metaCombine.repo.getChaptersInfo(metaCombine.mangaMeta.preId).then((value) {
        chaptersInfo.assignAll(value);
        for (var chapter in chaptersInfo) {
          readArray.add(metaCombine.repo.isRead(chapter.preChapterId));
        }
      });
    }
  }

  goToLastReadChapter() {
    //todo: implement
  }

  setIsRead(int index) async {
    await Future.delayed(Duration(seconds: 1));
    await metaCombine.repo.markAsRead(chaptersInfo[index].preChapterId, chaptersInfo[index]);
    readArray[index] = true;
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
