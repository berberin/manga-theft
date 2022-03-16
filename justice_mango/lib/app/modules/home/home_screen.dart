import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/home/home_controller.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_tab.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_tab.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_tab.dart';
import 'package:justice_mango/app/modules/home/tab/recent/recent_tab.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            BoardTab(),
            FavoriteTab(),
            ExploreTab(),
            RecentTab(),
          ],
          // BoardTab(),
          // FavoriteTab(),
          // ExploreTab(),
          // RecentTab(),
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: SalomonBottomBar(
              items: <SalomonBottomBarItem>[
                SalomonBottomBarItem(
                  icon: Icon(
                    Icons.airplay_rounded,
                  ),
                  title: Text(
                    'board'.tr,
                    style: Get.textTheme.caption,
                  ),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.my_library_books_rounded),
                  title: Text(
                    'favorite'.tr,
                    style: Get.textTheme.caption,
                  ),
                  selectedColor: Colors.pink,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.explore_rounded),
                  title: Text(
                    'explore'.tr,
                    style: Get.textTheme.caption,
                  ),
                  selectedColor: Colors.purple,
                  //backgroundColor: Colors.purple,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.alarm_rounded),
                  title: Text(
                    'recent'.tr,
                    style: Get.textTheme.caption,
                  ),
                  //backgroundColor: Colors.pink,
                ),
              ],
              currentIndex: controller.selectedIndex.value,
              // selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int value) {
    controller.switchToIndex(value);
  }
}
