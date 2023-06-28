import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justice_mango/app/gwidget/manga_card.dart';
import 'package:justice_mango/app/modules/home/tab/explore/explore_provider.dart';
import 'package:justice_mango/app/modules/home/widget/source_tab_chip.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  ExploreTabState createState() => ExploreTabState();
}

class ExploreTabState extends ConsumerState<ExploreTab> {
  final TextEditingController textSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final exploreStateProvider = ref.watch(exploreProvider);
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
                      controller: textSearchController,
                      onEditingComplete: () => ref
                          .read(exploreProvider.notifier)
                          .search(textSearchController.text),
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
                      onTap: () => ref
                          .read(exploreProvider.notifier)
                          .search(textSearchController.text),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: exploreStateProvider.searchComplete
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'searchResult'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.27,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              ref.read(exploreProvider.notifier).clearSearch();
                              textSearchController.clear();
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
                  (exploreStateProvider.searchComplete &&
                          exploreStateProvider.mangaSearchResult.isEmpty)
                      ? <Widget>[
                          Text(
                            'noResult'.tr(),
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ]
                      : <Widget>[] +
                          List.generate(
                            exploreStateProvider.mangaSearchResult.length,
                            (index) => MangaCard(
                              metaCombine:
                                  exploreStateProvider.mangaSearchResult[index],
                            ),
                          ),
                  addRepaintBoundaries: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          'randomManga'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.27,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: () => ref
                              .read(exploreProvider.notifier)
                              .getRandomManga(
                                  delayedDuration: const Duration(seconds: 0)),
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
                      exploreStateProvider.sourceRepositories.length,
                      (index) => GestureDetector(
                        child: SourceTabChip(
                          label: exploreStateProvider
                              .sourceRepositories[index].slug,
                          selected:
                              exploreStateProvider.sourceSelected == index,
                        ),
                        onTap: () {
                          if (exploreStateProvider.sourceSelected != index) {
                            ref
                                .read(exploreProvider.notifier)
                                .changeSourceTab(index);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    exploreStateProvider.randomMangaList.length,
                    (index) => MangaCard(
                      metaCombine: exploreStateProvider.randomMangaList[index],
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
