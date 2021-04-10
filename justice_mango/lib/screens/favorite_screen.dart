import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/screens/manga_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<MangaMeta> favoriteMangas;

  final mNameStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final aNameStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    setState(() {
      favoriteMangas = HiveProvider.getFavoriteMangas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('Truyện yêu thích'),
      ),
      body: Column(children: [Expanded(child: _buildGridCards())]),
    );
  }

  Widget _buildGridCards() {
    if (HiveProvider.favoriteBox.isEmpty)
      return Center(
        child: Text(
          'Bạn chưa theo dõi truyện nào cả!!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      );
    else
      return GridView.count(
        padding: const EdgeInsets.all(13.0),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          for (var i = 0; i < HiveProvider.favoriteBox.length; i++)
            _buildMangaCard(favoriteMangas[1])
        ],
      );
  }

  Widget _buildMangaCard(MangaMeta mangaMeta) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 110,
            child: Image.network(mangaMeta.imgUrl, fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(13.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
        ).then((value) {
          setState(() {});
        });
      },
    );
  }
}
