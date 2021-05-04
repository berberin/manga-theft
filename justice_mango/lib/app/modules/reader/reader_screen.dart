import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/reader/reader_controller.dart';
import 'package:justice_mango/app/modules/reader/widget/manga_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReaderScreen extends GetWidget<ReaderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshConfiguration(
        maxUnderScrollExtent: 75,
        footerTriggerDistance: -75,
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
          ),
          onLoading: controller.toNextChapter,
          onRefresh: controller.toPrevChapter,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              Obx(
                () => SliverList(
                  delegate: SliverChildListDelegate(
                    controller.hasError.value
                        ? Center(
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
                        : List.generate(
                            controller.imgUrls.length,
                            (index) => MangaImage(
                              imageUrl: controller.imgUrls[index],
                              repo: controller.metaCombine.repo,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(
        controller.chaptersInfo[controller.index.value].name,
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
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                    ),
                    Obx(
                      () => Text(
                        "#${(controller.chaptersInfo.length - controller.index.value).toString()} / ${controller.chaptersInfo.length}",
                        style: Theme.of(context).textTheme.caption,
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
}
