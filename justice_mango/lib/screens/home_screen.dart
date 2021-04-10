import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/favorite_screen.dart';
import 'package:justice_mango/screens/manga_detail_screen.dart';
import 'package:justice_mango/screens/search_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MangaMeta> mangas;
  Future<List<MangaMeta>> _futureMangas;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page;
  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
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

  Widget _buildMangaCard(MangaMeta mangaMeta) {
    return InkWell(
      child: Row(
        children: [
          Container(
            width: 90,
            height: 110,
            child: Image.network(mangaMeta.imgUrl, fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      mangaMeta.title,
                      style: mNameStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('Tác giả: ' + mangaMeta.author, style: aNameStyle),
                  Text('Thể loại: ' + mangaMeta.tags.toString()),
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MangaDetail(mangaMeta: mangaMeta)),
        );
      },
    );
  }

  Widget _buildCards(List<MangaMeta> mangaMeta) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropMaterialHeader(),
      footer: ClassicFooter(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        padding: EdgeInsets.all(13.0),
        itemCount: mangaMeta == null ? 0 : mangaMeta.length,
        itemBuilder: (context, i) {
          return _buildMangaCard(mangaMeta[i]);
        },
        separatorBuilder: (context, i) {
          return Divider();
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
        builder:
            (BuildContext context, AsyncSnapshot<List<MangaMeta>> snapshot) {
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
