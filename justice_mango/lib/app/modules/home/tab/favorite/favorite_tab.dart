import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/gwidget/short_manga_card.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_controller.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

import 'widget/short_manga_bar.dart';

class FavoriteTab extends GetWidget<FavoriteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                    style: Get.textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.sort_rounded),
                    onPressed: () => controller.changeFavoriteCardStyle(),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.favoriteMetaCombine.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'dontHaveAnyFavorite'.tr,
                          style: Get.textTheme.bodyText2,
                        ),
                      ),
                    )
                  : (controller.cardStyle.value ==
                          FavoriteCardStyle.ShortMangaCard
                      ? StaggeredGridView.countBuilder(
                          padding: EdgeInsets.only(top: 3.0),
                          itemCount: controller.favoriteMetaCombine.length,
                          crossAxisCount: 4,
                          itemBuilder: (context, index) {
                            return ShortMangaCard(
                              metaCombine:
                                  controller.favoriteMetaCombine[index],
                            );
                          },
                          staggeredTileBuilder: (index) =>
                              new StaggeredTile.fit(2),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return ShortMangaBar(
                              metaCombine:
                                  controller.favoriteMetaCombine[index],
                            );
                          },
                          itemCount: controller.favoriteMetaCombine.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

enum FavoriteCardStyle {
  ShortMangaCard,
  ShortMangaBar,
}
