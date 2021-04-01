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
          onPressed: () {
            MangaProvider.getPages("/truyen-tranh/sekai-no-owari-to-yoakemae/chap-9/2386");
          },
          child: Text("Mango"),
        ),
      ],
    );
  }
}
