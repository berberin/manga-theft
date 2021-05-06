import 'package:get/get.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_controller.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_controller.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_controller.dart';
import 'package:justice_mango/app/modules/home/tab/setting/setting_controller.dart';

import 'home_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BoardController());
    Get.lazyPut(() => ExploreController());
    Get.lazyPut(() => FavoriteController());
    Get.lazyPut(() => SettingController());
  }
}
