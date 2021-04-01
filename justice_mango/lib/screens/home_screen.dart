import 'package:flutter/material.dart';
import 'package:justice_mango/providers/manga_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        MangaProvider.getLatestManga();
      },
      child: Text("Mango"),
    );
  }
}
