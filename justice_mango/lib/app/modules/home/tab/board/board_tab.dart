import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:justice_mango/app/gwidget/manga_card.dart';
import 'package:justice_mango/app/modules/home/home_controller.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_controller.dart';
import 'package:justice_mango/app/theme/color_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BoardTab extends GetWidget<BoardController> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: 'loading'.tr,
        canLoadingText: 'canLoading'.tr,
        idleText: 'idleLoading'.tr,
      ),
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: nearlyWhite,
            floating: true,
            title: _welcomeBar(),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'newUpdateFavorite'.tr,
                style: Get.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.27,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            sliver: Obx(
              () => SliverList(
                delegate: SliverChildListDelegate(
                  controller.favoriteUpdate.isEmpty
                      ? [Center(child: Text('noUpdateFound'.tr))]
                      : List.generate(
                          controller.favoriteUpdate.length > 5 ? 5 : controller.favoriteUpdate.length,
                          (index) => MangaCard(
                            mangaMeta: controller.favoriteUpdate[index],
                          ),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Text(
                    'updateJustNow'.tr,
                    style: Get.textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildListDelegate(
                controller.mangaBoard.isEmpty
                    ? controller.hasError.value
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.onRefresh();
                                  },
                                  child: Text('reload'.tr),
                                ),
                              ),
                            )
                          ]
                        : [Center(child: CircularProgressIndicator())]
                    : List.generate(
                        controller.mangaBoard.length,
                        (index) => MangaCard(
                          mangaMeta: controller.mangaBoard[index],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeBar() {
    return Row(
      children: [
        SvgPicture.string(
          Jdenticon.toSvg('message'),
          fit: BoxFit.fill,
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "hello!".tr,
                style: Get.textTheme.headline6,
              ),
              Text(
                'Senjou',
                style: Get.textTheme.caption,
              )
            ],
          ),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: Icon(Icons.search_rounded),
          color: nearlyBlack,
          onPressed: () {
            HomeController homeController = Get.find();
            homeController.selectedIndex.value = 2;
          },
        )
      ],
    );
  }
}

/*
ListView.builder(
  shrinkWrap: true,
  addRepaintBoundaries: false,
  itemCount: controller.mangaBoard.length,
  itemBuilder: (context, i) {
    return MangaCard(mangaMeta: controller.mangaBoard[i]);
  },
),
 */
