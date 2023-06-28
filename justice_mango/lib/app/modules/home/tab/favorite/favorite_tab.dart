import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:justice_mango/app/gwidget/short_manga_card.dart';
import 'package:justice_mango/app/modules/home/tab/favorite/favorite_provider.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

import 'widget/short_manga_bar.dart';

class FavoriteTab extends ConsumerWidget {
  const FavoriteTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteStateProvider = ref.watch(favoriteProvider);
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort_rounded),
                    onPressed: () =>
                        ref.read(favoriteProvider.notifier)
                            .changeFavoriteCardStyle(),
                  ),
                ],
              ),
            ),
            favoriteStateProvider.favoriteMetaCombine.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'dontHaveAnyFavorite'.tr(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ),
            )
                : (favoriteStateProvider.cardStyle ==
                FavoriteCardStyle.shortMangaCard
                ? MasonryGridView.count(
              padding: const EdgeInsets.only(top: 3.0),
              itemCount: favoriteStateProvider.favoriteMetaCombine.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ShortMangaCard(
                  metaCombine:
                  favoriteStateProvider.favoriteMetaCombine[index],
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )
                : ListView.builder(
              itemBuilder: (context, index) {
                return ShortMangaBar(
                  metaCombine:
                  favoriteStateProvider.favoriteMetaCombine[index],
                  latestChapter: favoriteStateProvider.latestChapters[
                  favoriteStateProvider.favoriteMetaCombine[index]
                      .mangaMeta.url] ??
                      "🦉",
                );
              },
              itemCount: favoriteStateProvider.favoriteMetaCombine.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

            )),

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
