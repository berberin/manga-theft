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
  Future<List<String>> _futureImgsUrl;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _futureImgsUrl =
        MangaProvider.getPages(widget.chaptersInfo[widget.index].url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _futureImgsUrl,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return RefreshConfiguration(
                maxUnderScrollExtent: 50,
                footerTriggerDistance: -40.0,
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  header: ClassicHeader(),
                  footer: ClassicFooter(),
                  onLoading: _loadNextChap,
                  onRefresh: _loadPrevChap,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return Image(
                          image: NetworkImage(snapshot.data[i], headers: {
                            "Referer": "http://www.nettruyen.com/"
                          }),
                        );
                      }),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Opps!! Có lỗi xảy ra!!');
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  void _loadPrevChap() async {
    await Future.delayed(Duration(seconds: 3));
    if (widget.index < widget.chaptersInfo.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterScreen(
              chaptersInfo: widget.chaptersInfo, index: widget.index + 1),
        ),
      );
    }
  }

  void _loadNextChap() async {
    await Future.delayed(Duration(seconds: 3));
    if (widget.index > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterScreen(
              chaptersInfo: widget.chaptersInfo, index: widget.index - 1),
        ),
      );
    }
  }
}
