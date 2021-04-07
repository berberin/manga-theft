import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/manga_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget appBarTitle = Text("AppBar Title");
  Icon actionIcon = Icon(Icons.search);
  var _controller = TextEditingController();
  List<MangaMeta> mangasSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              hintText: "Tìm truyện",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  if (_controller.text != null) {
                    mangasSearch = MangaProvider.search(_controller.text);
                  }
                });
              }),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              setState(() {
                mangasSearch.clear();
              });
            },
          )
        ],
      ),
      body: _buildCards(mangasSearch),
    );
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
}
