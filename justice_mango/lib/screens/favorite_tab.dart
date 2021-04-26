import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:justice_mango/app_theme.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/providers/manga_provider.dart';
import 'package:justice_mango/screens/widget/short_manga_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteTab extends StatefulWidget {
  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  List<MangaMeta> favoriteUpdate = <MangaMeta>[];
  List<MangaMeta> favoriteMangas;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    favoriteMangas = HiveProvider.getFavoriteMangas();
    MangaProvider.getFavoriteUpdate().then((value) {
      setState(() {
        favoriteUpdate = value;
      });
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: Column(children: [Expanded(child: _buildGridCards())]),
    );
  }

  Widget _buildGridCards() {
    if (HiveProvider.favoriteBox.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 120.0,
            horizontal: 16,
          ),
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
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        setState(() {
          favoriteMangas = HiveProvider.getFavoriteMangas();
        });
        _refreshController.refreshCompleted();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Truyện ưa thích",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
              ),
            ),
            StaggeredGridView.countBuilder(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              crossAxisCount: 4,
              shrinkWrap: true,
              addRepaintBoundaries: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteMangas.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMangaCard(favoriteMangas[index]);
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              //mainAxisSpacing: 4.0,
              //crossAxisSpacing: 4.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listUpdateFavorite() {
    if (favoriteUpdate.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Không có cập nhật mới.',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 120,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Truyện ưa thích",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
              ),
            ),
          ],
        ),
        StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemBuilder: (BuildContext context, int index) {},
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        ),
      ],
    );
    //   ListView.builder(
    //   itemBuilder: (context, index) => MangaCard(
    //     mangaMeta: favoriteUpdate[index],
    //   ),
    //   itemCount: favoriteUpdate.length > 5 ? 5 : favoriteUpdate.length,
    //   physics: NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   addRepaintBoundaries: false,
    // );
  }

  Widget _buildMangaCard(MangaMeta mangaMeta) {
    return ShortMangaCard(
      mangaMeta: mangaMeta,
    );
  }
}
