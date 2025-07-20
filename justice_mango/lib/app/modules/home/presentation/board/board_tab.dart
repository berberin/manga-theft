import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manga_theft/app/base/base_stateless_widget.dart';
import 'package:manga_theft/app/gwidget/loading_widget.dart';
import 'package:manga_theft/app/gwidget/manga_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:manga_theft/app/modules/home/cubit/board/board_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/board/board_state.dart';
import 'package:manga_theft/app/modules/home/presentation/board/widget/setting_bottom_sheet.dart';
import 'package:manga_theft/app/modules/home/presentation/widget/source_tab_chip.dart';
import 'package:manga_theft/app/theme/color_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BoardTab extends BaseStatelessWidget<BoardCubit, BoardState> {
  const BoardTab({super.key});

  @override
  void onCubitReady(BoardCubit cubit) {
    cubit.init();
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, BoardCubit cubit, BoardState state) {
    return SmartRefresher(
      controller: cubit.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: 'loading'.tr(),
        canLoadingText: 'canLoading'.tr(),
        idleText: 'idleLoading'.tr(),
      ),
      onRefresh: cubit.onRefresh,
      onLoading: cubit.onLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: nearlyWhite,
            floating: true,
            title: _welcomeBar(context, cubit),
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
                state.listFavoriteUpdateManga.isEmpty
                    ? [Text('noUpdateFound'.tr())]
                    : List.generate(
                        state.listFavoriteUpdateManga.length > 5 ? 5 : state.listFavoriteUpdateManga.length,
                        (index) => MangaCard(
                          metaCombine: state.listFavoriteUpdateManga[index],
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
          _buildTagRow(cubit, state),
          SliverList(
            delegate: SliverChildListDelegate(
              state.listBoardManga.isEmpty
                  ? state.error != null && state.error!.isNotEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  cubit.onRefresh();
                                },
                                child: Text('reload'.tr()),
                              ),
                            ),
                          )
                        ]
                      : [const LoadingWidget()]
                  : List.generate(
                      state.listBoardManga.length,
                      (index) => MangaCard(
                        metaCombine: state.listBoardManga[index],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagRow(BoardCubit cubit, BoardState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.from(
              List.generate(
                state.sourceRepositories.length,
                (index) => GestureDetector(
                  child: SourceTabChip(
                    label: state.sourceRepositories[index].slug,
                    selected: state.sourceIndex == index,
                  ),
                  onTap: () {
                    if (state.sourceIndex != index) {
                      cubit.changeSourceTab(index);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeBar(BuildContext context, BoardCubit cubit) {
    return Row(
      children: [
        SvgPicture.string(
          cubit.avatarSvg,
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
              builder: (context) => SettingBottomSheet(boardCubit: cubit),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          color: nearlyBlack,
          onPressed: () {
            cubit.switchHomeTabByIndex(2);
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
