import 'package:flutter/material.dart';

class MangaFrame extends StatelessWidget {
  final String imageUrl;
  final double width;

  const MangaFrame({Key key, this.imageUrl, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.white,
      padding: EdgeInsets.all(2),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
