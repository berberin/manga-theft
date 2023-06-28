import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:justice_mango/app/gwidget/manga_card.dart';
import 'package:justice_mango/app/modules/home/home_provider.dart';
import 'package:justice_mango/app/modules/home/tab/board/board_provider.dart';
import 'package:justice_mango/app/modules/home/tab/board/widget/setting_bottom_sheet.dart';
import 'package:justice_mango/app/modules/home/widget/source_tab_chip.dart';
import 'package:justice_mango/app/theme/color_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BoardTab extends ConsumerStatefulWidget {
  const BoardTab({Key? key}) : super(key: key);

  @override
  BoardTabState createState() => BoardTabState();
}

class BoardTabState extends ConsumerState<BoardTab> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
  }

  onRefresh() {
    ref.read(boardProvider.notifier).refreshBoard();
    refreshController.refreshCompleted();
  }

  onLoading() {
    ref.read(boardProvider.notifier).loadMoreBoard();
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final boardStateProvider = ref.watch(boardProvider);
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: 'loading'.tr(),
        canLoadingText: 'canLoading'.tr(),
        idleText: 'idleLoading'.tr(),
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: nearlyWhite,
            floating: true,
            title: _welcomeBar(boardStateProvider),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'newUpdateFavorite'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                boardStateProvider.favoriteUpdate.isEmpty
                    ? [Text('noUpdateFound'.tr())]
                    : List.generate(
                        boardStateProvider.favoriteUpdate.length > 5
                            ? 5
                            : boardStateProvider.favoriteUpdate.length,
                        (index) => MangaCard(
                          metaCombine: boardStateProvider.favoriteUpdate[index],
                        ),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(
                    'updateJustNow'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List<Widget>.from(
                    List.generate(
                      boardStateProvider.sourceRepositories.length,
                      (index) => GestureDetector(
                        child: SourceTabChip(
                          label:
                              boardStateProvider.sourceRepositories[index].slug,
                          selected: boardStateProvider.sourceSelected == index,
                        ),
                        onTap: () {
                          if (boardStateProvider.sourceSelected != index) {
                            ref
                                .read(boardProvider.notifier)
                                .changeSourceTab(index);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              boardStateProvider.mangaBoard.isEmpty
                  ? boardStateProvider.hasError
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  onRefresh();
                                },
                                child: Text('reload'.tr()),
                              ),
                            ),
                          )
                        ]
                      : [
                          const Padding(
                            padding: EdgeInsets.all(56.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        ]
                  : List.generate(
                      boardStateProvider.mangaBoard.length,
                      (index) => MangaCard(
                        metaCombine: boardStateProvider.mangaBoard[index],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeBar(BoardStateData stateProvider) {
    return Row(
      children: [
        SvgPicture.string(
          stateProvider.avatarSvg,
          fit: BoxFit.fill,
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "hello!".tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          color: nearlyBlack,
          onPressed: () {
            showBarModalBottomSheet(
              context: context,
              builder: (context) => const SettingBottomSheet(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          color: nearlyBlack,
          onPressed: () {
            ref.read(homeProvider.notifier).switchToIndex(2);
          },
        ),
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
