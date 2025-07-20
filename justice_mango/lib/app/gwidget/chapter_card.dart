import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/modules/manga_detail/cubit/manga_detail_cubit.dart';
import 'package:manga_theft/app/modules/reader/presentation/widget/reader_screen_args.dart';

import '../../di/injection.dart';
import '../route/app_route.dart';

class ChapterCard extends StatelessWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;
  final MangaMetaCombine metaCombine;
  final bool isRead;

  const ChapterCard({
    super.key,
    required this.chaptersInfo,
    required this.index,
    required this.metaCombine,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getIt<AppRoute>().push(
          ReaderRoute(
            readerScreenArgs: ReaderScreenArgs(
              metaCombine: metaCombine,
              chaptersInfo: chaptersInfo,
              index: index,
            ),
          ),
        );
        final mangaDetailCubit = context.read<MangaDetailCubit>();
        mangaDetailCubit.addToRecentRead();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        elevation: isRead ? 1 : 3,
        color: isRead ? Colors.grey[300] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 14,
          ),
          child: Text(
            chaptersInfo[index].name ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
