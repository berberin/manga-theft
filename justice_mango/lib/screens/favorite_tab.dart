import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/screens/widget/short_manga_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteTab extends StatefulWidget {
  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  List<MangaMeta> favoriteMangas;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    favoriteMangas = HiveProvider.getFavoriteMangas();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: _buildGridCards())]),
    );
  }

  Widget _buildGridCards() {
    if (HiveProvider.favoriteBox.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Chưa có truyện ưa thích.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 38,
              ),
              IconButton(
                icon: Icon(Icons.refresh_rounded),
                onPressed: () {
                  setState(() {
                    favoriteMangas = HiveProvider.getFavoriteMangas();
                  });
                },
              ),
            ],
          ),
        ),
      );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 38),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          setState(() {
            favoriteMangas = HiveProvider.getFavoriteMangas();
          });
          _refreshController.refreshCompleted();
        },
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: favoriteMangas.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Truyện ưa thích",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              );
            }
            return _buildMangaCard(favoriteMangas[index - 1]);
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          //mainAxisSpacing: 4.0,
          //crossAxisSpacing: 4.0,
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildMangaCard(MangaMeta mangaMeta) {
    return ShortMangaCard(
      mangaMeta: mangaMeta,
    );
  }
}
