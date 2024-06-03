import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/gwidget/short_manga_card.dart';
import 'package:manga_theft/app/modules/home/tab/favorite/favorite_controller.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import 'widget/short_manga_bar.dart';

class FavoriteTab extends GetWidget<FavoriteController> {
  const FavoriteTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'favorites'.tr,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort_rounded),
                    onPressed: () => controller.changeFavoriteCardStyle(),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.favoriteMetaCombine.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'dontHaveAnyFavorite'.tr,
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : (controller.cardStyle.value ==
                          FavoriteCardStyle.shortMangaCard
                      ? MasonryGridView.count(
                          padding: const EdgeInsets.only(top: 3.0),
                          itemCount: controller.favoriteMetaCombine.length,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            return ShortMangaCard(
                              metaCombine:
                                  controller.favoriteMetaCombine[index],
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        )
                      : GetBuilder(
                          builder: (FavoriteController controller) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return ShortMangaBar(
                                  metaCombine:
                                      controller.favoriteMetaCombine[index],
                                  latestChapter: controller.latestChapters[
                                          controller.favoriteMetaCombine[index]
                                              .mangaMeta.url] ??
                                      "🦉",
                                );
                              },
                              itemCount: controller.favoriteMetaCombine.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            );
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

enum FavoriteCardStyle {
  shortMangaCard,
  shortMangaBar,
}
