import 'package:flutter/material.dart';
import 'package:justice_mango/providers/manga_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: NetworkImage("http://anhnhanh.org/data/images/73/2386/014-fix.jpg?data=net", headers: {
            "Referer": "http://www.nettruyen.com/",
          }),
        ),
        ElevatedButton(
          onPressed: () async {
            var mangas = await MangaProvider.getLatestManga();
            print(mangas[0].toJson());
            var chapterInfos = await MangaProvider.getChaptersInfo(mangas[0].id);
            print(chapterInfos[0].toJson());
            var images_url = await MangaProvider.getPages(chapterInfos[0].url);
            print(images_url);
          },
          child: Text("Mango"),
        ),
      ],
    );
  }
}
