import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MangaFrame extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const MangaFrame({super.key, required this.imageUrl, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(2),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset('assets/images/placeholder.png'),
        errorWidget: (context, url, error) => Image.asset('assets/images/placeholder.png'),
      ),
    );
  }
}
