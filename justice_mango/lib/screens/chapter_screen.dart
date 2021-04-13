import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justice_mango/models/chapter_info.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/cache_provider.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/widget/manga_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChapterScreen extends StatefulWidget {
  final List<ChapterInfo> chaptersInfo;
  final int index;
  final MangaMeta mangaMeta;
  final List<String> preloadUrl;

  const ChapterScreen({Key key, this.chaptersInfo, this.index, this.mangaMeta, this.preloadUrl}) : super(key: key);
  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Future<List<String>> _futureImgsUrl;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<String> _preloadUrl;

  @override
  void initState() {
    super.initState();
    if (widget.preloadUrl == null) {
      _futureImgsUrl = MangaProvider.getPages(widget.chaptersInfo[widget.index].url);
    } else {
      _futureImgsUrl = Future.microtask(() {
        return widget.preloadUrl;
      });
    }
    getPreloadUrl();
  }

  void getPreloadUrl() async {
    if (widget.index - 1 >= 0) {
      _preloadUrl = await MangaProvider.getPages(widget.chaptersInfo[widget.index - 1].url);
      for (var url in _preloadUrl) {
        CacheProvider.getImage(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshConfiguration(
        maxUnderScrollExtent: 50,
        footerTriggerDistance: -50.0,
        child: FutureBuilder(
          future: _futureImgsUrl,
          builder: (context, snapshot) {
            Widget listImageSliver;
            if (snapshot.hasData) {
              listImageSliver = SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(snapshot.data.length, (index) => MangaImage(imageUrl: snapshot.data[index])),
                  addRepaintBoundaries: false,
                ),
              );
            } else {
              listImageSliver = SliverToBoxAdapter(
                child: Container(),
              );
            }
            if (snapshot.hasError) {
              listImageSliver = SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureImgsUrl = MangaProvider.getPages(widget.chaptersInfo[widget.index].url);
                          });
                        },
                        child: Text("TẢI LẠI")),
                  ),
                ),
              );
            }
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: ClassicFooter(),
              onLoading: _loadNextChap,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(
                      widget.chaptersInfo[widget.index].name,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    iconTheme: IconTheme.of(context).copyWith(color: Colors.black54),
                    expandedHeight: 150,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
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
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.mangaMeta.title,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    "${(widget.chaptersInfo.length - widget.index).toString()} / ${widget.chaptersInfo.length}",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  listImageSliver,
                ],
              ),
            );
          },
        ),
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
            mangaMeta: widget.mangaMeta,
          ),
        ),
      );
    }
  }

  void _loadNextChap() async {
    if (widget.index > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterScreen(
            chaptersInfo: widget.chaptersInfo,
            index: widget.index - 1,
            mangaMeta: widget.mangaMeta,
            preloadUrl: _preloadUrl ?? null,
          ),
        ),
      );
    }
  }
}
