import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/base/base_constant.dart';
import 'package:manga_theft/app/base/base_stateful_widget.dart';
import 'package:manga_theft/app/gwidget/loading_widget.dart';
import 'package:manga_theft/app/modules/reader/cubit/reader_cubit.dart';
import 'package:manga_theft/app/modules/reader/cubit/reader_state.dart';
import 'package:manga_theft/app/modules/reader/presentation/widget/manga_image.dart';
import 'package:manga_theft/app/modules/reader/presentation/widget/reader_screen_args.dart';
import 'package:manga_theft/app/util/layout_constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class ReaderScreen extends BaseStatefulWidget<ReaderCubit, ReaderState> {
  final ReaderScreenArgs readerScreenArgs;

  const ReaderScreen({super.key, required this.readerScreenArgs});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends BaseStatefulWidgetState<ReaderCubit, ReaderState, ReaderScreen> {
  @override
  void onCubitReady(ReaderCubit cubit) {
    cubit.init(
      widget.readerScreenArgs.chaptersInfo,
      widget.readerScreenArgs.index,
      widget.readerScreenArgs.metaCombine,
      widget.readerScreenArgs.preloadUrl ?? [],
    );
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, ReaderCubit cubit, ReaderState state) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshConfiguration(
          maxUnderScrollExtent: 70,
          footerTriggerDistance: -70,
          child: SmartRefresher(
            controller: cubit.refreshController,
            enablePullUp: true,
            enablePullDown: true,
            footer: ClassicFooter(
              idleText: 'idleLoadingNextChapter'.tr(),
              canLoadingText: 'canLoadingNextChapter'.tr(),
              loadingText: 'loadingNextChapter'.tr(),
              failedText: 'failedNextChapter'.tr(),
            ),
            header: ClassicHeader(
              idleText: 'idleLoadingPrevChapter'.tr(),
              failedText: 'failedPrevChapter'.tr(),
              refreshingText: 'loadingPrevChapter'.tr(),
              releaseText: 'releasePrevChapter'.tr(),
              completeText: 'completeText'.tr(),
            ),
            onLoading: cubit.toNextChapter,
            onRefresh: cubit.toPrevChapter,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(cubit, state),
                state.status == BaseStatus.loading
                    ? const SliverToBoxAdapter(
                        child: LoadingWidget(),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          state.error != null
                              ? [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cubit.getPages();
                                        },
                                        child: Text('reload'.tr()),
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: List.generate(
                                      state.imgUrls.length,
                                      (index) => MangaImage(
                                        imageUrl: state.imgUrls[index],
                                        repo: state.metaCombine!.repo,
                                      ),
                                    ),
                                  ),
                                ],
                          addRepaintBoundaries: false,
                        ),
                      ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      1,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: const Text(
                          "🐱🦊🐯🐶🦁🐮🐷🐰🐹🐼",
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

  Widget _buildSliverAppBar(ReaderCubit cubit, ReaderState state) {
    return SliverAppBar(
      floating: true,
      title: Text(
        state.chaptersInfo[state.currentIndex].name ?? 'chapter name',
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.white,
      iconTheme: IconTheme.of(context).copyWith(color: Colors.black54),
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(state.metaCombine?.mangaMeta.imgUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: LayoutConstants.backcardMangaBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.metaCombine?.mangaMeta.title ?? 'title',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                  ),
                  Text(
                    "#${(state.chaptersInfo.length - state.currentIndex).toString()} / ${state.chaptersInfo.length}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
