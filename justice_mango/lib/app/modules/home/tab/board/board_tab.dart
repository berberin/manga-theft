import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/gwidget/manga_card.dart';
import 'package:justice_mango/app/modules/home/home_controller.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_controller.dart';
import 'package:justice_mango/app/modules/home/widget/source_tab_chip.dart';
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
                            metaCombine: controller.favoriteUpdate[index],
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
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
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
          _buildTagRow(),
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
                        : [Padding(
                          padding: const EdgeInsets.all(56.0),
                          child: Center(child: CircularProgressIndicator()),
                        )]
                    : List.generate(
                        controller.mangaBoard.length,
                        (index) => MangaCard(
                          metaCombine: controller.mangaBoard[index],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GetBuilder<BoardController> _buildTagRow() {
    return GetBuilder<BoardController>(
      builder: (controller) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: List<Widget>.from(
              List.generate(
                controller.sourceRepositories.length,
                (index) => GestureDetector(
                  child: SourceTabChip(
                    label: controller.sourceRepositories[index].slug,
                    selected: controller.sourceSelected == index,
                  ),
                  onTap: () {
                    if (controller.sourceSelected != index) {
                      controller.changeSourceTab(index);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeBar() {
    return Row(
      children: [
        Obx(
          () => SvgPicture.string(
            controller.avatarSvg.value,
            fit: BoxFit.fill,
            height: 40,
          ),
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
