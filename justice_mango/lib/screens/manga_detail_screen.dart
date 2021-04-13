import 'dart:ui';

import 'package:flutter/material.dart';
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
    MangaProvider.getChaptersInfo(widget.mangaMeta.id).then((value) {
      setState(() {
        chaptersInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.play_arrow_rounded,
          size: 30,
        ),
        onPressed: () {
          goToLastReadChapter();
        },
      ),
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

  Widget _buildMangaInfos_bak() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 180,
              child: Image.network(widget.mangaMeta.imgUrl, fit: BoxFit.cover),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        widget.mangaMeta.title,
                        style: mNameStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('Tác giả: ' + widget.mangaMeta.author, style: aNameStyle),
                    Text('Thể loại: ' + widget.mangaMeta.tags.toString()),
                    Text('Tình trạng: ' + widget.mangaMeta.status),
                    Text(
                      'Mô tả: ' + widget.mangaMeta.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text('Theo dõi truyện: '),
                        GestureDetector(
                          child: isFavorite == true
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.pinkAccent,
                                )
                              : Icon(Icons.favorite_border, color: Colors.pinkAccent),
                          onTap: () {
                            setState(() {
                              if (isFavorite) {
                                isFavorite = !isFavorite;
                                HiveProvider.removeFromFavoriteBox(widget.mangaMeta.id);
                              } else {
                                isFavorite = !isFavorite;
                                HiveProvider.addToFavoriteBox(widget.mangaMeta);
                              }
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.all(3.0),
          itemCount: chaptersInfo == null ? 0 : chaptersInfo.length,
          itemBuilder: (context, i) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                child: Text(
                  chaptersInfo[i].name,
                  style: HiveProvider.getReadChapter(chaptersInfo[i].chapterId) == null
                      ? TextStyle(color: Colors.black)
                      : TextStyle(color: Colors.black45),
                ),
              ),
              onTap: () {
                HiveProvider.addToReadBox(chaptersInfo[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterScreen(
                      chaptersInfo: chaptersInfo,
                      index: i,
                      mangaMeta: widget.mangaMeta,
                    ),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            );
          },
          separatorBuilder: (context, i) {
            return Divider();
          },
        ),
      )
    ]);
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
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.mangaMeta.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            widget.mangaMeta.author == '' ? 'Chưa rõ tác giả' : widget.mangaMeta.author,
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
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
    // todo: implement
    int lastReadIndex = HiveProvider.getLastReadIndex(mangaId: widget.mangaMeta.id);
    //int lastReadIndex = 1;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterScreen(
          chaptersInfo: chaptersInfo,
          index: lastReadIndex,
          mangaMeta: widget.mangaMeta,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }
}
