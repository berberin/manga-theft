import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChapterScreen extends StatefulWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;

  const ChapterScreen({Key key, this.chaptersInfo, this.index})
      : super(key: key);
  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  List<String> imgsUrl;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    MangaProvider.getPages(widget.chaptersInfo[widget.index].url).then((value) {
      setState(() {
        imgsUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: ClassicHeader(),
        footer: ClassicFooter(),
        onRefresh: _loadPrevChap,
        onLoading: _loadNextChap,
        child: ListView.builder(
            itemCount: imgsUrl == null ? 0 : imgsUrl.length,
            itemBuilder: (context, i) {
              print(widget.chaptersInfo[widget.index].chapterId);
              return Image(
                image: NetworkImage(imgsUrl[i], headers: {
                  "Referer": "http://www.nettruyen.com/",
                }),
              );
            }),
      ),
    );
  }

  void _loadPrevChap() async {
    await Future.delayed(Duration(seconds: 3));
    if (widget.index < widget.chaptersInfo.length - 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChapterScreen(
                    chaptersInfo: widget.chaptersInfo,
                    index: widget.index + 1,
                  )));
    }
  }

  void _loadNextChap() async {
    await Future.delayed(Duration(seconds: 3));
    if (widget.index > 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChapterScreen(
                    chaptersInfo: widget.chaptersInfo,
                    index: widget.index - 1,
                  )));
    }
  }
}
