import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:justice_mango/models/manga_meta.dart';
import 'package:justice_mango/providers/hive_provider.dart';
import 'package:justice_mango/screens/widget/short_manga_card.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: favoriteMangas.length,
        itemBuilder: (BuildContext context, int index) => _buildMangaCard(favoriteMangas[index]),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        //mainAxisSpacing: 4.0,
        //crossAxisSpacing: 4.0,
        shrinkWrap: true,
      ),
    );

    return GridView.count(
      padding: const EdgeInsets.all(13.0),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [for (var i = 0; i < HiveProvider.favoriteBox.length; i++) _buildMangaCard(favoriteMangas[0])],
    );
  }

  Widget _buildMangaCard(MangaMeta mangaMeta) {
    return ShortMangaCard(
      mangaMeta: mangaMeta,
    );
  }
}
