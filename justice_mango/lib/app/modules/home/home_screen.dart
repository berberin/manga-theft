import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:justice_mango/app/modules/home/home_provider.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_tab.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_tab.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_tab.dart';
import 'package:justice_mango/app/modules/home/tab/recent/recent_tab.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(homeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
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
                  'board'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                selectedColor: Colors.green,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.my_library_books_rounded),
                title: Text(
                  'favorite'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                selectedColor: Colors.pink,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.explore_rounded),
                title: Text(
                  'explore'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                selectedColor: Colors.purple,
                //backgroundColor: Colors.purple,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.alarm_rounded),
                title: Text(
                  'recent'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                //backgroundColor: Colors.pink,
              ),
            ],
            currentIndex: selectedIndex,
            // selectedItemColor: Colors.amber[800],
            onTap: (int index) {
              ref.read(homeProvider.notifier).switchToIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
