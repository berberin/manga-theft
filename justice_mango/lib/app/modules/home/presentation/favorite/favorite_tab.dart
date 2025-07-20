import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:manga_theft/app/base/base_stateless_widget.dart';
import 'package:manga_theft/app/gwidget/short_manga_card.dart';
import 'package:manga_theft/app/modules/home/cubit/favorite/favorite_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/favorite/favorite_state.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import '../../../../base/base_constant.dart';
import 'widget/short_manga_bar.dart';

class FavoriteTab extends BaseStatelessWidget<FavoriteCubit, FavoriteState> {
  const FavoriteTab({super.key});

  @override
  void onCubitReady(FavoriteCubit cubit) {
    cubit.init();
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, FavoriteCubit cubit, FavoriteState state) {
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
                    'favorites'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort_rounded),
                    onPressed: () => cubit.changeFavoriteCardStyle(),
                  ),
                ],
              ),
            ),
            state.listFavoriteMetaCombine.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'dontHaveAnyFavorite'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                : (state.cardStyle == FavoriteCardStyle.shortMangaCard
                    ? MasonryGridView.count(
                        padding: const EdgeInsets.only(top: 3.0),
                        itemCount: state.listFavoriteMetaCombine.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return ShortMangaCard(
                            metaCombine: state.listFavoriteMetaCombine[index],
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return ShortMangaBar(
                            metaCombine: state.listFavoriteMetaCombine[index],
                            latestChapter:
                                state.latestChapters[state.listFavoriteMetaCombine[index].mangaMeta.url] ?? "🦉",
                          );
                        },
                        itemCount: state.listFavoriteMetaCombine.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      )),
          ],
        ),
      ),
    );
  }
}
