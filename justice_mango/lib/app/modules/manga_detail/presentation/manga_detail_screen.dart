import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:manga_theft/app/base/base_stateful_widget.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/gwidget/chapter_card.dart';
import 'package:manga_theft/app/gwidget/loading_widget.dart';
import 'package:manga_theft/app/gwidget/manga_frame.dart';
import 'package:manga_theft/app/gwidget/tag.dart';
import 'package:manga_theft/app/modules/manga_detail/cubit/manga_detail_cubit.dart';
import 'package:manga_theft/app/modules/manga_detail/cubit/manga_detail_state.dart';
import 'package:manga_theft/app/route/app_route.dart';
import 'package:manga_theft/app/theme/color_theme.dart';
import 'package:manga_theft/app/util/layout_constants.dart';

import '../../reader/presentation/widget/reader_screen_args.dart';

@RoutePage()
class MangaDetailScreen extends BaseStatefulWidget<MangaDetailCubit, MangaDetailState> {
  final MangaMetaCombine metaCombine;

  const MangaDetailScreen({super.key, required this.metaCombine});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends BaseStatefulWidgetState<MangaDetailCubit, MangaDetailState, MangaDetailScreen> {
  @override
  void onCubitReady(MangaDetailCubit cubit) {
    cubit.init(widget.metaCombine);
    super.onCubitReady(cubit);
  }

  @override
  Widget buildContent(BuildContext context, MangaDetailCubit cubit, MangaDetailState state) {
    return Scaffold(
      floatingActionButton: _fab(cubit, state),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(cubit, state),
          _buildDescription(cubit, state),
          SliverList(
            delegate: SliverChildListDelegate(
              state.chaptersInfo.isEmpty
                  ? [const LoadingWidget()]
                  : List.generate(
                      state.chaptersInfo.length,
                      (index) {
                        return ChapterCard(
                          chaptersInfo: state.chaptersInfo,
                          index: index,
                          metaCombine: state.metaCombine!,
                          isRead: state.readArray[index],
                        );
                      },
                    ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.all(24)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDescription(MangaDetailCubit cubit, MangaDetailState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.metaCombine!.mangaMeta.alias?.isNotEmpty ?? false
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "${"alias:".tr} ${state.metaCombine!.mangaMeta.alias.toString().replaceAll("[", "").replaceAll("]", "")}"),
                  )
                : Container(),
            Text(
              state.metaCombine!.mangaMeta.description ?? 'description',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              state.metaCombine!.mangaMeta.status ?? 'status',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Tags(
              tags: state.metaCombine!.mangaMeta.tags ?? ['tag'],
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(MangaDetailCubit cubit, MangaDetailState state) {
    return SliverAppBar(
      floating: true,
      title: Text(
        state.metaCombine!.mangaMeta.title ?? 'title',
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.white,
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.black54,
      ),
      expandedHeight: 40 * 6.5,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(state.metaCombine!.mangaMeta.imgUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: LayoutConstants.backcardMangaBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MangaFrame(
                    imageUrl: state.metaCombine!.mangaMeta.imgUrl ?? '',
                    height: 40 * 4.5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            state.metaCombine!.mangaMeta.title ?? 'title',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            state.metaCombine!.mangaMeta.author ?? 'author',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fab(MangaDetailCubit cubit, MangaDetailState state) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      backgroundColor: mainColorSecondary,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
          ),
          backgroundColor: state.chaptersInfo.isEmpty ? notWhite : mainColorSecondary,
          onTap: state.chaptersInfo.isEmpty
              ? () {}
              : () {
                  cubit.addToRecentRead();
                  navigator.push(
                    ReaderRoute(
                      readerScreenArgs: ReaderScreenArgs(
                        chaptersInfo: state.chaptersInfo,
                        index: state.metaCombine!.repo.getLastReadIndex(state.metaCombine!.mangaMeta.preId) ?? 0,
                        metaCombine: state.metaCombine!,
                      ),
                    ),
                  );
                },
          label: 'readNow'.tr(),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: mainColorSecondary,
        ),
        SpeedDialChild(
          child: state.isFavorite
              ? const Icon(
                  Icons.library_add_check,
                  color: Colors.pink,
                )
              : const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
          backgroundColor: mainColorSecondary,
          onTap: () async {
            if (state.isFavorite) {
              await cubit.removeFromFavoriteBox();
            } else {
              await cubit.addToFavoriteBox();
            }
          },
          label: state.isFavorite ? 'favorite!'.tr() : 'markFavorite'.tr(),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: mainColorSecondary,
        ),
        if (state.isFavorite)
          SpeedDialChild(
            child: state.isExceptional
                ? const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.notifications_off_rounded,
                    color: Colors.white,
                  ),
            backgroundColor: mainColorSecondary,
            onTap: () async {
              if (state.isExceptional) {
                await cubit.removeAsExceptionalFavorite();
              } else {
                await cubit.markAsExceptionalFavorite();
              }
            },
            label: state.isExceptional ? 'turnOnNotification'.tr() : 'turnOffNotification'.tr(),
            labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
            labelBackgroundColor: mainColorSecondary,
          ),
      ],
    );
  }
}
