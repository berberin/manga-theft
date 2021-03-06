import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/reader/reader_controller.dart';
import 'package:justice_mango/app/modules/reader/reader_screen_args.dart';
import 'package:justice_mango/app/modules/reader/widget/manga_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_string/random_string.dart';

class ReaderScreen extends StatefulWidget {
  final ReaderScreenArgs readerScreenArgs;

  const ReaderScreen({Key? key, required this.readerScreenArgs})
      : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String tag = randomAlpha(3);

  @override
  void initState() {
    super.initState();
    Get.put(
      ReaderController(
        chaptersInfo: widget.readerScreenArgs.chaptersInfo,
        index: widget.readerScreenArgs.index,
        metaCombine: widget.readerScreenArgs.metaCombine,
        preloadUrl: widget.readerScreenArgs.preloadUrl ?? [],
      ),
      tag: tag,
    );
  }

  @override
  void dispose() {
    Get.delete(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReaderController>(
      tag: tag,
      builder: (controller) => Scaffold(
        body: RefreshConfiguration(
          maxUnderScrollExtent: 70,
          footerTriggerDistance: -70,
          child: SmartRefresher(
            controller: controller.refreshController,
            enablePullUp: true,
            enablePullDown: true,
            footer: ClassicFooter(
              idleText: 'idleLoadingNextChapter'.tr,
              canLoadingText: 'canLoadingNextChapter'.tr,
              loadingText: 'loadingNextChapter'.tr,
              failedText: 'failedNextChapter'.tr,
            ),
            header: ClassicHeader(
              idleText: 'idleLoadingPrevChapter'.tr,
              failedText: 'failedPrevChapter'.tr,
              refreshingText: 'loadingPrevChapter'.tr,
              releaseText: 'releasePrevChapter'.tr,
              completeText: 'completeText'.tr,
            ),
            onLoading: controller.toNextChapter,
            onRefresh: controller.toPrevChapter,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(controller),
                Obx(
                  () => controller.loading.value
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Center(
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            controller.hasError.value
                                ? [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.getPages();
                                          },
                                          child: Text('reload'.tr),
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    Column(
                                      children: List.generate(
                                        controller.imgUrls.length,
                                        (index) => MangaImage(
                                          imageUrl: controller.imgUrls[index],
                                          repo: controller.metaCombine.repo,
                                        ),
                                      ),
                                      mainAxisSize: MainAxisSize.min,
                                    ),
                                  ],
                            addRepaintBoundaries: false,
                          ),
                        ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      1,
                      (index) => Container(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "???? ???? ???? ???? ????",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSliverAppBar(controller) {
    return Obx(
      () => SliverAppBar(
        title: Text(
          controller.chaptersInfo[controller.index].name,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black54),
        expandedHeight: 150,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.metaCombine.mangaMeta.title,
                        style: Get.textTheme.bodyText1,
                        maxLines: 1,
                      ),
                      Obx(
                        () => Text(
                          "#${(controller.chaptersInfo.length - controller.index).toString()} / ${controller.chaptersInfo.length}",
                          style: Get.textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
