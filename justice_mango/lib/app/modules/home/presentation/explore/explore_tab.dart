import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:manga_theft/app/base/base_stateless_widget.dart';
import 'package:manga_theft/app/gwidget/manga_card.dart';
import 'package:manga_theft/app/modules/home/cubit/explore/explore_cubit.dart';
import 'package:manga_theft/app/modules/home/cubit/explore/explore_state.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import '../widget/source_tab_chip.dart';

class ExploreTab extends BaseStatelessWidget<ExploreCubit, ExploreState> {
  const ExploreTab({super.key});

  @override
  void onCubitReady(ExploreCubit cubit) {
    cubit.init();
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, ExploreCubit cubit, ExploreState state) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: FocusWatcher(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: nearlyWhite,
              floating: true,
              title: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainColor,
                      ),
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'searchManga'.tr(),
                        border: InputBorder.none,
                        helperStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xffB9BABC),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          color: Color(0xffB9BABC),
                        ),
                      ),
                      controller: cubit.textSearchController,
                      onEditingComplete: () => cubit.search(),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.search,
                        color: Color(0xffB9BABC),
                      ),
                      onTap: () => cubit.search(),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: state.isSearchComplete
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'searchResult'.tr(),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.27,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              cubit.clearSearch();
                              cubit.clearTextField();
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  (state.isSearchComplete && state.listSearchResultManga.isEmpty)
                      ? <Widget>[
                          Text(
                            'noResult'.tr(),
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ]
                      : <Widget>[] +
                          List.generate(
                            state.listSearchResultManga.length,
                            (index) => MangaCard(
                              metaCombine: state.listSearchResultManga[index],
                            ),
                          ),
                  addRepaintBoundaries: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          'randomManga'.tr(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.27,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: () => cubit.getRandomManga(delayedDuration: const Duration(seconds: 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: List<Widget>.from(
                    List.generate(
                      state.sourceRepositories.length,
                      (index) => GestureDetector(
                        child: SourceTabChip(
                          label: state.sourceRepositories[index].slug,
                          selected: cubit.sourceIndex == index,
                        ),
                        onTap: () {
                          if (cubit.sourceIndex != index) {
                            cubit.changeSourceTab(index);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    state.listRandomManga.length,
                    (index) => MangaCard(
                      metaCombine: state.listRandomManga[index],
                    ),
                  ),
                  addRepaintBoundaries: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
