import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/providers/name_provider.dart';
import 'package:justice_mango/screens/widget/manga_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home_screen.dart';

class BoardTab extends StatefulWidget {
  final HomeScreenState homeScreenState;

  const BoardTab({Key key, this.homeScreenState}) : super(key: key);
  @override
  _BoardTabState createState() => _BoardTabState();
}

class _BoardTabState extends State<BoardTab> {
  List<MangaMeta> mangas;
  Future<List<MangaMeta>> _futureMangas;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  String randomName;
  String avatarSvg;
  int page;
  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    randomName = NameProvider.getRandomName();
    avatarSvg = Jdenticon.toSvg(
      randomName,
      colorSaturation: 0.48,
      grayscaleSaturation: 0.48,
      colorLightnessMinValue: 0.84,
      colorLightnessMaxValue: 0.84,
      grayscaleLightnessMinValue: 0.84,
      grayscaleLightnessMaxValue: 0.84,
      backColor: '#2a4766ff',
      hues: [207],
    );
    page = 1;
    _futureMangas = MangaProvider.getLatestManga(page: page);
    _futureMangas.then((value) {
      mangas = value;
    });
  }

  void _onRefresh() async {
    page = 1;
    _futureMangas = MangaProvider.getLatestManga(page: page);
    _futureMangas.then((value) {
      setState(() {
        mangas = value;
      });
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    page++;
    MangaProvider.getLatestManga(page: page).then((value) {
      setState(() {
        for (var i = 0; i < value.length; i++) {
          if (mangas.every((item) => item.id != value[i].id)) {
            mangas.add(value[i]);
          }
        }
      });
      _refreshController.loadComplete();
    });
  }

  Widget _buildCards(List<MangaMeta> mangaMeta) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      footer: ClassicFooter(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        addRepaintBoundaries: false,
        physics: BouncingScrollPhysics(),
        itemCount: mangaMeta == null ? 0 : mangaMeta.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                _welcomeBar(),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cập nhật mới cho truyện ưa thích",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                  ),
                ),
                _listUpdateFavorite(),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Text(
                    "Mới cập nhật",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                  ),
                ),
              ],
            );
          }
          return MangaCard(mangaMeta: mangaMeta[i - 1]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: FutureBuilder(
              future: _futureMangas,
              builder: (BuildContext context, AsyncSnapshot<List<MangaMeta>> snapshot) {
                if (snapshot.hasData)
                  return _buildCards(mangas);
                else if (snapshot.hasError)
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _onRefresh();
                            });
                          },
                          child: Text("TẢI LẠI")),
                    ),
                  );
                else
                  return Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SvgPicture.string(
            avatarSvg,
            fit: BoxFit.fill,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào!",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  randomName,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                widget.homeScreenState.setState(() {
                  widget.homeScreenState.selectedIndex = 2;
                });
              })
        ],
      ),
    );
  }

  Widget _listUpdateFavorite() {
    return Container();
  }
}
