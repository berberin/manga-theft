import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/gwidget/chapter_card.dart';
import 'package:justice_mango/app/gwidget/manga_frame.dart';
import 'package:justice_mango/app/gwidget/tag.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class MangaDetailScreen extends StatefulWidget {
  final MangaMetaCombine metaCombine;

  const MangaDetailScreen({Key key, this.metaCombine}) : super(key: key);
  @override
  _MangaDetailScreenState createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(
      MangaDetailController(metaCombine: widget.metaCombine),
      tag: widget.metaCombine.mangaMeta.preId,
    );
  }

  @override
  void dispose() {
    Get.delete(tag: widget.metaCombine.mangaMeta.preId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MangaDetailController>(
      tag: widget.metaCombine.mangaMeta.preId,
      builder: (controller) => Scaffold(
        floatingActionButton: _fab(controller),
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(controller),
            _buildDescription(controller),
            Obx(
              () => SliverList(
                delegate: SliverChildListDelegate(
                  controller.chaptersInfo.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ]
                      : List.generate(
                          controller.chaptersInfo.length,
                          (index) {
                            return ChapterCard(
                              chaptersInfo: controller.chaptersInfo,
                              index: index,
                              metaCombine: controller.metaCombine,
                              isRead: controller.readArray[index],
                            );
                          },
                        ),
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.all(24)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDescription(controller) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.metaCombine.mangaMeta.alias.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "${"alias:".tr} ${controller.metaCombine.mangaMeta.alias.toString().replaceAll("[", "").replaceAll("]", "")}"),
                  )
                : Container(),
            Text(
              controller.metaCombine.mangaMeta.description,
              style: Get.textTheme.bodyText2,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              controller.metaCombine.mangaMeta.status,
              style: Get.textTheme.caption,
            ),
            SizedBox(
              height: 10,
            ),
            Tags(
              tags: controller.metaCombine.mangaMeta.tags,
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(controller) {
    return SliverAppBar(
      title: Text(
        controller.metaCombine.mangaMeta.title,
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.black54,
      ),
      expandedHeight: 40 * 6.5,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(controller.metaCombine.mangaMeta.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MangaFrame(
                      imageUrl: controller.metaCombine.mangaMeta.imgUrl,
                      height: 40 * 4.5,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              controller.metaCombine.mangaMeta.title,
                              style: Get.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              controller.metaCombine.mangaMeta.author,
                              style: Get.textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fab(controller) {
    return Obx(
      () => SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: mainColorSecondary,
        foregroundColor: Colors.white,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            backgroundColor: mainColorSecondary,
            onTap: () {
              controller.goToLastReadChapter();
            },
            label: 'readNow'.tr,
            labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
            labelBackgroundColor: mainColorSecondary,
          ),
          SpeedDialChild(
            child: controller.isFavorite.value
                ? Icon(
                    Icons.library_add_check,
                    color: Colors.pink,
                  )
                : Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
            backgroundColor: mainColorSecondary,
            onTap: () async {
              if (controller.isFavorite.value) {
                controller.removeFromFavoriteBox();
              } else {
                controller.addToFavoriteBox();
              }
            },
            label: controller.isFavorite.value ? 'favorite!'.tr : 'markFavorite'.tr,
            labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
            labelBackgroundColor: mainColorSecondary,
          ),
        ],
      ),
    );
  }
}
