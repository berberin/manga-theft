import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/gwidget/manga_card.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_controller.dart';
import 'package:justice_mango/app/modules/home/widget/source_tab_chip.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class ExploreTab extends GetWidget<ExploreController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: FocusWatcher(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: nearlyWhite,
              floating: true,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: mainColor,
                        ),
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'searchManga'.tr,
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xffB9BABC),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            color: Color(0xffB9BABC),
                          ),
                        ),
                        controller: controller.textSearchController,
                        onEditingComplete: () => controller.search(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      child: Icon(
                        Icons.search,
                        color: Color(0xffB9BABC),
                      ),
                      onTap: () => controller.search(),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => SliverToBoxAdapter(
                child: controller.searchComplete.value
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'searchResult'.tr,
                              style: Get.textTheme.headline5?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.27,
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.clear_all_rounded),
                                onPressed: () => controller.clearSearch()),
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            Obx(
              () => SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    (controller.searchComplete.value &&
                            controller.mangaSearchResult.isEmpty)
                        ? <Widget>[
                            Text(
                              'noResult'.tr,
                              style: Get.textTheme.caption,
                            )
                          ]
                        : <Widget>[] +
                            List.generate(
                              controller.mangaSearchResult.length,
                              (index) => MangaCard(
                                metaCombine:
                                    controller.mangaSearchResult[index],
                              ),
                            ),
                    addRepaintBoundaries: false,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Row(
                      children: [
                        Text(
                          'randomManga'.tr,
                          style: Get.textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.27,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh_rounded),
                          onPressed: () => controller.getRandomManga(
                              delayedDuration: Duration(seconds: 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<ExploreController>(
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
            ),
            Obx(
              () => SliverPadding(
                padding: EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      controller.randomMangaList.length,
                      (index) => MangaCard(
                        metaCombine: controller.randomMangaList[index],
                      ),
                    ),
                    addRepaintBoundaries: false,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
