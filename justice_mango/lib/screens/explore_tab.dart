import 'package:flutter/material.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/widget/manga_card.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  Widget appBarTitle = Text("AppBar Title");
  Icon actionIcon = Icon(Icons.search);
  var _controller = TextEditingController();
  List<MangaMeta> mangasSearch = <MangaMeta>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Tìm truyện',
                      border: InputBorder.none,
                      helperStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xffB9BABC),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: Color(0xffB9BABC),
                      ),
                    ),
                    controller: _controller,
                    onEditingComplete: () async {
                      var mangas = await MangaProvider.search(_controller.text);
                      setState(() {
                        if (_controller.text != null) {
                          mangasSearch = mangas;
                        }
                      });
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: GestureDetector(
                  child: Icon(
                    Icons.search,
                    color: Color(0xffB9BABC),
                  ),
                  onTap: () async {
                    var mangas = await MangaProvider.search(_controller.text);
                    setState(() {
                      if (_controller.text != null) {
                        mangasSearch = mangas;
                      }
                    });
                  },
                ),
              )
            ],
          ),
          Divider(),
          _buildSearchResult(mangasSearch),
          Divider(),
          _buildRandomManga('Comedy'),
          Divider(),
          _buildRandomManga('Drama'),
          Divider(),
          _buildRandomManga('Action'),
          Divider(),
          _buildRandomManga('Adventure'),
        ],
      ),
    );
  }

  Widget _buildRandomManga(String tag) {
    var randomManga = MangaProvider.getRandomManga(tag, 5);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Row(
              children: [
                Text(
                  'Truyện ngẫu nhiên #$tag',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.27,
                      ),
                ),
              ],
            ),
          );
        }
        return MangaCard(mangaMeta: randomManga[i - 1]);
      },
    );
  }

  Widget _buildSearchResult(List<MangaMeta> mangaMeta) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      shrinkWrap: true,
      itemCount: mangaMeta.isEmpty ? 0 : mangaMeta.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Row(
            children: [
              Text(
                'Kết quả tìm kiếm',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
              ),
              IconButton(
                icon: Icon(Icons.clear_all_rounded),
                onPressed: () {
                  setState(() {
                    mangasSearch.clear();
                  });
                },
              )
            ],
          );
        }
        return MangaCard(mangaMeta: mangaMeta[i - 1]);
      },
    );
  }
}
