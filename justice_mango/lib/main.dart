import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Read you like a book',
      home: ReaderHome(),
    );
  }
}

class ReaderHome extends StatefulWidget {
  @override
  _ReaderHomeState createState() => _ReaderHomeState();
}

class _ReaderHomeState extends State<ReaderHome> {
  String imgURL =
      'https://scontent.fhan2-6.fna.fbcdn.net/v/t1.6435-9/47356850_1402827323186301_4371766091551080448_n.jpg?_nc_cat=100&ccb=1-3&_nc_sid=e3f864&_nc_ohc=4oss_0hQTtEAX95ZM5w&_nc_ht=scontent.fhan2-6.fna&oh=8c7bc92b1f230e6527f52cd9c38c5151&oe=608A724A';
  String mName, aName;
  int chaps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('bo may di dai bo dai vao bat quai')),
      ),
      body: _buildCard(),
    );
  }

  Widget _buildMangaCard(String imageURL, String mangaName, String author, int chapters) {
    return Row(
      children: [
        Container(
          width: 90,
          height: 110,
          child: Image.network(imgURL, fit: BoxFit.cover),
        ),
        Container(
          child: Column(
            children: [Padding(padding: EdgeInsets.all(10))],
          ),
        )
      ],
    );
  }

  Widget _buildCard() {
    return ListView.separated(
      padding: EdgeInsets.all(14.0),
      itemCount: 10,
      itemBuilder: /*1*/ (context, i) {
        return _buildMangaCard(imgURL, mName, aName, chaps);
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }
}
