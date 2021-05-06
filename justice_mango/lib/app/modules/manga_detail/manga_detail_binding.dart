import 'package:get/get.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_controller.dart';

class MangaDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MangaDetailController());
  }
}
