import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/manga_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MangaMeta> mangas;
  @override
  void initState() {
    MangaProvider.getLatestManga().then((value) {
      setState(() {
        mangas = value;
      });
    });
  }

  final mNameStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);

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
    return ListView.separated(
      padding: EdgeInsets.all(13.0),
      itemCount: mangaMeta == null ? 0 : mangaMeta.length,
      itemBuilder: (context, i) {
        return _buildMangaCard(mangaMeta[i]);
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }

  Widget _buildAppBar() {
    Widget appBarTitle = Text("AppBar Title");
    Icon actionIcon = Icon(Icons.search);
    return AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (actionIcon.icon == Icons.search) {
              actionIcon = Icon(Icons.close);
              appBarTitle = TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white)),
              );
            } else {
              actionIcon = Icon(Icons.search);
              appBarTitle = Text("AppBar Title");
            }
          });
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCards(mangas),
    );
  }
}
