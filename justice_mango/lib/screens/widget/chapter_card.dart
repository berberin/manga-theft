import 'package:flutter/material.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';

import '../chapter_screen.dart';
import '../manga_detail_screen.dart';

class ChapterCard extends StatefulWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;
  final MangaMeta mangaMeta;
  final MangaDetailState mangaDetailState;

  const ChapterCard({Key key, this.chaptersInfo, this.index, this.mangaMeta, this.mangaDetailState}) : super(key: key);

  @override
  _ChapterCardState createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterScreen(
              chaptersInfo: widget.chaptersInfo,
              index: widget.index,
              mangaMeta: widget.mangaMeta,
              mangaDetailState: widget.mangaDetailState,
            ),
          ),
        ).then((value) {
          widget.mangaDetailState.setState(() {});
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        elevation: HiveProvider.isRead(chapterId: widget.chaptersInfo[widget.index].chapterId) ? 1 : 3,
        color: HiveProvider.isRead(chapterId: widget.chaptersInfo[widget.index].chapterId)
            ? Colors.grey[300]
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 14,
          ),
          child: Text(
            widget.chaptersInfo[widget.index].name,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
    );
  }
}
