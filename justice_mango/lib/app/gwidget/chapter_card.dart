import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/modules/manga_detail/manga_detail_controller.dart';
import 'package:manga_theft/app/modules/reader/reader_screen.dart';
import 'package:manga_theft/app/modules/reader/reader_screen_args.dart';

class ChapterCard extends StatelessWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;
  final MangaMetaCombine metaCombine;
  final bool isRead;

  const ChapterCard({
    Key? key,
    required this.chaptersInfo,
    required this.index,
    required this.metaCombine,
    this.isRead = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ReaderScreen(
            readerScreenArgs: ReaderScreenArgs(
              metaCombine: metaCombine,
              chaptersInfo: chaptersInfo,
              index: index,
            ),
          ),
        );
        MangaDetailController mangaDetailController =
            Get.find(tag: metaCombine.mangaMeta.preId);
        mangaDetailController.addToRecentRead();
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
