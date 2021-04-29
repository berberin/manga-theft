import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:justice_mango/app_theme.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/nettruyen_manga_provider.dart';
import 'package:justice_mango/screens/widget/manga_card.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  Widget appBarTitle = Text("AppBar Title");
  Icon actionIcon = Icon(Icons.search);
  var _controllerTextField = TextEditingController();
  List<MangaMeta> mangasSearch = <MangaMeta>[];

  bool searchComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: FocusWatcher(
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    _tags.shuffle();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: nearlyWhite,
          floating: true,
          title: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  //padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextFormField(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: mainColor,
                    ),
                    keyboardType: TextInputType.text,
                    autofocus: false,
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
                    controller: _controllerTextField,
                    onEditingComplete: () => _doSearch(),
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
                  onTap: () => _doSearch(),
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              Divider(),
              _buildSearchResult(mangasSearch),
              Divider(),
              _buildRandomManga(_tags[0]),
              Divider(),
              _buildRandomManga(_tags[1]),
              Divider(),
              _buildRandomManga(_tags[2]),
              Divider(),
              _buildRandomManga(_tags[3]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRandomManga(String tag) {
    var randomManga = MangaProvider.getRandomManga(tag, 5);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      shrinkWrap: true,
      addRepaintBoundaries: false,
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
      addRepaintBoundaries: false,
      shrinkWrap: true,
      itemCount: mangaMeta.isEmpty ? 1 : mangaMeta.length + 1,
      itemBuilder: (context, i) {
        if (searchComplete && mangaMeta.isEmpty) {
          return Text(
            'Không tìm thấy kết quả phù hợp.',
            style: Theme.of(context).textTheme.caption,
          );
        }
        if (i == 0) {
          if (searchComplete) {
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
                      searchComplete = false;
                    });
                  },
                )
              ],
            );
          } else {
            return Container();
          }
        }
        return MangaCard(mangaMeta: mangaMeta[i - 1]);
      },
    );
  }

  Future<void> _doSearch() async {
    if (_controllerTextField.text.length >= 2) {
      FocusScope.of(context).unfocus();
      var mangas = await MangaProvider.search(_controllerTextField.text);
      setState(() {
        searchComplete = true;
        mangasSearch = mangas;
      });
    }
  }
}

List<String> _tags = [
  "Action",
  "Adult",
  "Adventure",
  "Manga",
  "Sci-fi",
  "Manhua",
  "Martial Arts",
  "Truyện Màu",
  "Comedy",
  "Drama",
  "Historical",
  "Romance",
  "Supernatural",
  "Fantasy",
  "One shot",
  "Slice of Life",
  "Việt Nam",
  "Shoujo Ai",
  "Harem",
  "School Life",
  "Horror",
  "Shounen",
  "Manhwa",
  "Webtoon",
  "Shoujo",
  "Ngôn Tình",
  "Yuri",
  "Comic",
  "Soft Yaoi",
  "Mature",
  "Mystery",
  "Psychological",
  "Ecchi",
  "Soft Yuri",
  "Thiếu Nhi",
  "Seinen",
  "Smut",
  "Josei",
  "Tragedy",
  "Gender Bender",
  "Doujinshi",
  "Anime",
  "Chuyển Sinh",
  "Truyện scan",
  "Shounen Ai",
  "Sports",
  "Trinh Thám",
  "Mecha",
  "Live action",
  "Xuyên Không",
  "Cooking",
  "Đam Mỹ",
  "Yaoi",
];
