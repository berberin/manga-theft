import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:justice_mango/app_theme.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/widget/chapter_card.dart';
import 'package:justice_mango/screens/widget/manga_frame.dart';

import 'chapter_screen.dart';
import 'widget/tags.dart';

class MangaDetail extends StatefulWidget {
  final MangaMeta mangaMeta;
  const MangaDetail({Key key, this.mangaMeta}) : super(key: key);

  @override
  MangaDetailState createState() => MangaDetailState();
}

class MangaDetailState extends State<MangaDetail> {
  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);
  bool isFavorite;

  List<ChapterInfo> chaptersInfo = <ChapterInfo>[];
  @override
  void initState() {
    super.initState();
    isFavorite = HiveProvider.isFavoriteOrNot(widget.mangaMeta);
    HiveProvider.updateLastReadInfo(mangaId: widget.mangaMeta.id);
    MangaProvider.getChaptersInfo(widget.mangaMeta.id).then((value) {
      setState(() {
        chaptersInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFAB(),
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.mangaMeta.alias.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              "Tên khác: ${widget.mangaMeta.alias.toString().replaceAll("[", "").replaceAll("]", "")}"),
                        )
                      : Container(),
                  Text(
                    widget.mangaMeta.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.mangaMeta.status,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Tags(
                    tags: widget.mangaMeta.tags,
                  ),
                ],
              ),
            ),
          ),
          _chapterList(chaptersInfo),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      title: Text(
        widget.mangaMeta.title,
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconTheme.of(context).copyWith(color: Colors.black54),
      expandedHeight: 220,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.mangaMeta.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MangaFrame(
                      imageUrl: widget.mangaMeta.imgUrl,
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.mangaMeta.title,
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.mangaMeta.author,
                              style: Theme.of(context).textTheme.caption,
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
      ),
    );
  }

  Widget _chapterList(List<ChapterInfo> info) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(info.length, (index) {
          return ChapterCard(
            chaptersInfo: chaptersInfo,
            index: index,
            mangaMeta: widget.mangaMeta,
            mangaDetailState: this,
          );
        }),
        addRepaintBoundaries: false,
      ),
    );
  }

  void goToLastReadChapter() {
    int lastReadIndex = HiveProvider.getLastReadIndex(mangaId: widget.mangaMeta.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterScreen(
          chaptersInfo: chaptersInfo,
          index: lastReadIndex,
          mangaMeta: widget.mangaMeta,
          mangaDetailState: this,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: mainColorSecondary,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
          ),
          backgroundColor: mainColorSecondary,
          onTap: () {
            goToLastReadChapter();
          },
          label: 'Đọc ngay',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: mainColorSecondary,
        ),
        SpeedDialChild(
          child: isFavorite
              ? Icon(
                  Icons.library_add_check,
                  color: Colors.pink,
                )
              : Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
          backgroundColor: mainColorSecondary,
          onTap: () async {
            if (isFavorite) {
              await HiveProvider.removeFromFavoriteBox(widget.mangaMeta.id);
              setState(() {
                isFavorite = false;
              });
            } else {
              await HiveProvider.addToFavoriteBox(widget.mangaMeta);
              setState(() {
                isFavorite = true;
              });
            }
          },
          label: isFavorite ? 'Truyện ưa thích!' : 'Đánh dấu ưa thích',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: mainColorSecondary,
        ),
      ],
    );
  }
}
