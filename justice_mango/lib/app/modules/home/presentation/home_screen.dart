import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/base/base_stateless_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'board/board_tab.dart';
import 'explore/explore_tab.dart';
import 'favorite/favorite_tab.dart';
import 'recent/recent_tab.dart';

@RoutePage()
class HomeScreen extends BaseStatelessWidget<HomeCubit, HomeState> {
  const HomeScreen({super.key});

  @override
  Widget buildContent(BuildContext context, HomeCubit cubit, HomeState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: cubit.state.selectedIndex,
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
            currentIndex: cubit.state.selectedIndex,
            // selectedItemColor: Colors.amber[800],
            onTap: (index) {
              cubit.switchToIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
