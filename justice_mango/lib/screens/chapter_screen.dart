import 'package:flutter/material.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/providers/manga_provider.dart';

class ChapterScreen extends StatefulWidget {
  final ChaptersInfo chapterInfo;

  const ChapterScreen({Key key, this.chapterInfo}) : super(key: key);
  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  List<String> imgsUrl;
  @override
  void initState() {
    MangaProvider.getPages(widget.chapterInfo.url).then((value) {
      setState(() {
        imgsUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: imgsUrl == null ? 0 : imgsUrl.length,
          itemBuilder: (context, i) {
            return Image(
              image: NetworkImage(imgsUrl[i], headers: {
                "Referer": "http://www.nettruyen.com/",
              }),
            );
          }),
    );
  }
}
