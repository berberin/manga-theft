import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/gwidget/chapter_card.dart';
import 'package:manga_theft/app/gwidget/manga_frame.dart';
import 'package:manga_theft/app/gwidget/tag.dart';
import 'package:manga_theft/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:manga_theft/app/theme/color_theme.dart';
import 'package:manga_theft/app/util/layout_constants.dart';

class MangaDetailScreen extends StatefulWidget {
  final MangaMetaCombine metaCombine;

  const MangaDetailScreen({Key? key, required this.metaCombine})
      : super(key: key);

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
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
                          const Padding(
                            padding: EdgeInsets.all(24.0),
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
            const SliverPadding(padding: EdgeInsets.all(24)),
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
            controller.metaCombine.mangaMeta.alias?.isNotEmpty ?? false
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "${"alias:".tr} ${controller.metaCombine.mangaMeta.alias.toString().replaceAll("[", "").replaceAll("]", "")}"),
                  )
                : Container(),
            Text(
              controller.metaCombine.mangaMeta.description,
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.metaCombine.mangaMeta.status,
              style: Get.textTheme.bodySmall,
            ),
            const SizedBox(
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
      floating: true,
      title: Text(
        controller.metaCombine.mangaMeta.title,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.white,
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
          child: Container(
            decoration: LayoutConstants.backcardMangaBoxDecoration,
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
                            style: Get.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller.metaCombine.mangaMeta.author,
                            style: Get.textTheme.bodySmall,
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
    );
  }

  Widget _fab(controller) {
    return Obx(
      () => SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22),
        backgroundColor: mainColorSecondary,
        foregroundColor: Colors.white,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            backgroundColor:
                controller.chaptersInfo.isEmpty ? notWhite : mainColorSecondary,
            onTap: controller.chaptersInfo.isEmpty
                ? () {}
                : () {
                    controller.addToRecentRead();
                    controller.goToLastReadChapter();
                  },
            label: 'readNow'.tr,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.0,
            ),
            labelBackgroundColor: mainColorSecondary,
          ),
          SpeedDialChild(
            child: controller.isFavorite.value
                ? const Icon(
                    Icons.library_add_check,
                    color: Colors.pink,
                  )
                : const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
            backgroundColor: mainColorSecondary,
            onTap: () async {
              if (controller.isFavorite.value) {
                await controller.removeFromFavoriteBox();
              } else {
                await controller.addToFavoriteBox();
              }
            },
            label: controller.isFavorite.value
                ? 'favorite!'.tr
                : 'markFavorite'.tr,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16.0,
            ),
            labelBackgroundColor: mainColorSecondary,
          ),
          if (controller.isFavorite.value)
            SpeedDialChild(
              child: controller.isExceptional.value
                  ? const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.notifications_off_rounded,
                      color: Colors.white,
                    ),
              backgroundColor: mainColorSecondary,
              onTap: () async {
                if (controller.isExceptional.value) {
                  await controller.removeAsExceptionalFavorite();
                } else {
                  await controller.markAsExceptionalFavorite();
                }
              },
              label: controller.isExceptional.value
                  ? 'turnOnNotification'.tr
                  : 'turnOffNotification'.tr,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: mainColorSecondary,
            ),
        ],
      ),
    );
  }
}
