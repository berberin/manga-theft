import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/modules/home/home_controller.dart';
import 'package:manga_theft/app/modules/home/tab/board/board_tab.dart';
import 'package:manga_theft/app/modules/home/tab/explore/explore_tab.dart';
import 'package:manga_theft/app/modules/home/tab/favorite/favorite_tab.dart';
import 'package:manga_theft/app/modules/home/tab/recent/recent_tab.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            BoardTab(),
            FavoriteTab(),
            ExploreTab(),
            RecentTab(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: SalomonBottomBar(
              items: <SalomonBottomBarItem>[
                SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.airplay_rounded,
                  ),
                  title: Text(
                    'board'.tr,
                    style: Get.textTheme.bodySmall,
                  ),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.my_library_books_rounded),
                  title: Text(
                    'favorite'.tr,
                    style: Get.textTheme.bodySmall,
                  ),
                  selectedColor: Colors.pink,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.explore_rounded),
                  title: Text(
                    'explore'.tr,
                    style: Get.textTheme.bodySmall,
                  ),
                  selectedColor: Colors.purple,
                  //backgroundColor: Colors.purple,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.alarm_rounded),
                  title: Text(
                    'recent'.tr,
                    style: Get.textTheme.bodySmall,
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

class A extends StatefulWidget {
  const A({Key? key}) : super(key: key);

  @override
  State<A> createState() => _AState();
}

class _AState extends State<A> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  dispose() {
    super.dispose();
  }
}
