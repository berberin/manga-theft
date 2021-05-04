import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/home/home_controller.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_tab.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_tab.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_tab.dart';
import 'package:justice_mango/app/modules/home/tab/setting/setting_tab.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class HomeScreen extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              BoardTab(),
              FavoriteTab(),
              ExploreTab(),
              SettingTab(),
            ],
            // BoardTab(),
            // FavoriteTab(),
            // ExploreTab(),
            // SettingTab(),
          ),
          bottomNavigationBar: SizedBox(
            height: 40,
            child: BottomNavigationBar(
              iconSize: 15,
              selectedFontSize: 10,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.airplay_rounded,
                  ),
                  label: 'board'.tr,
                  backgroundColor: mainColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.my_library_books_rounded),
                  label: 'favorite'.tr,
                  backgroundColor: mainColor,
                  //backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_rounded),
                  label: 'explore'.tr,
                  backgroundColor: mainColor,
                  //backgroundColor: Colors.purple,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_applications_rounded),
                  label: 'setting'.tr,
                  backgroundColor: mainColor,
                  //backgroundColor: Colors.pink,
                ),
              ],
              currentIndex: controller.selectedIndex.value,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
              //unselectedItemColor: Colors.blue,
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
