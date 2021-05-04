import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/model/chapter_info.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/modules/reader/reader_screen_args.dart';
import 'package:justice_mango/app/route/routes.dart';

class ChapterCard extends StatelessWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;
  final MangaMetaCombine metaCombine;
  final bool isRead;

  const ChapterCard({Key key, this.chaptersInfo, this.index, this.metaCombine, this.isRead = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.READER,
          preventDuplicates: false,
          arguments: ReaderScreenArgs(
            metaCombine: metaCombine,
            chaptersInfo: chaptersInfo,
            index: index,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
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
            chaptersInfo[index].name,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
    );
  }
}
