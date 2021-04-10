import 'package:flutter/material.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/providers/manga_provider.dart';

import 'chapter_screen.dart';

class MangaDetail extends StatefulWidget {
  final MangaMeta mangaMeta;
  const MangaDetail({Key key, this.mangaMeta}) : super(key: key);

  @override
  _MangaDetailState createState() => _MangaDetailState();
}

class _MangaDetailState extends State<MangaDetail> {
  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);
  bool isFavorite;

  List<ChapterInfo> chaptersInfo;
  @override
  void initState() {
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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('Justice for Manga'),
      ),
      body: Widget_buildMangaInfos(),
    );
  }

  Widget_buildMangaInfos() {
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
                    Text('Tác giả: ' + widget.mangaMeta.author,
                        style: aNameStyle),
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
                              : Icon(Icons.favorite_border,
                                  color: Colors.pinkAccent),
                          onTap: () {
                            setState(() {
                              if (isFavorite) {
                                isFavorite = !isFavorite;
                                HiveProvider.removeFromFavoriteBox(
                                    widget.mangaMeta.id);
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
                  style:
                      HiveProvider.getReadChapter(chaptersInfo[i].chapterId) ==
                              null
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
}
