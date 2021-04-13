import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/favorite_screen.dart';
import 'package:justice_mango/screens/search_screen.dart';
import 'package:justice_mango/screens/widget/manga_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MangaMeta> mangas;
  Future<List<MangaMeta>> _futureMangas;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page;
  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    page = 1;
    _futureMangas = MangaProvider.getLatestManga(page: page);
    _futureMangas.then((value) {
      mangas = value;
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
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
    await Future.delayed(Duration(seconds: 3));
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Mới cập nhật",
                style: Theme.of(context).textTheme.caption,
              ),
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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('Justice for Manga'),
        leading: IconButton(
            icon: Icon(
              Icons.view_list,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
              ;
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              })
        ],
      ),
      body: FutureBuilder(
        future: _futureMangas,
        builder: (BuildContext context, AsyncSnapshot<List<MangaMeta>> snapshot) {
          if (snapshot.hasData)
            return _buildCards(mangas);
          else if (snapshot.hasError)
            return Text('Opps!! Có lỗi xảy ra!!');
          else
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
              ),
            );
        },
      ),
    );
  }
}
