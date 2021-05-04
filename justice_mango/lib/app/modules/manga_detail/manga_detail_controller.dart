import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';

class MangaDetailController extends GetxController {
  MangaMeta mangaMeta;
  MangaRepository mangaRepository;
  var isFavorite = false.obs;
  var chaptersInfo = <ChapterInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      mangaMeta = Get.arguments['mangaMeta'];
      mangaRepository = Get.arguments['mangaRepository'];
      isFavorite.value = mangaRepository.isFavorite(mangaMeta.preId);
      mangaRepository.getChaptersInfo(mangaMeta.preId).then((value) {
        chaptersInfo.assignAll(value);
      });
    }
  }
}
