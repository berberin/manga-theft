import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';
import 'package:justice_mango/app/data/service/cache_service.dart';
import 'package:random_string/random_string.dart';

class MangaImage extends StatefulWidget {
  final String imageUrl;
  final MangaRepository repo;

  const MangaImage({Key? key, required this.imageUrl, required this.repo})
      : super(key: key);

  @override
  _MangaImageState createState() => _MangaImageState();
}

class _MangaImageState extends State<MangaImage> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: CacheService.cacheManager,
      imageUrl: imageUrl,
      //httpHeaders: {"Referer": "https://www.nettruyen.com/"},
      // imageBuilder: (context, imageProvider) => PhotoView(
      //   imageProvider: imageProvider,
      //   maxScale: PhotoViewComputedScale.covered * 2.0,
      //   minScale: PhotoViewComputedScale.contained * 0.8,
      //   initialScale: PhotoViewComputedScale.covered,
      //   tightMode: true,
      // ),
      httpHeaders: widget.repo.imageHeader(),
      fit: BoxFit.fitWidth,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: Container(
              margin: EdgeInsets.all(100),
              child:
                  CircularProgressIndicator(value: downloadProgress.progress))),
      errorWidget: (context, url, error) => Container(
        margin: EdgeInsets.all(100),
        child: ElevatedButton(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Icon(Icons.refresh_rounded)),
          onPressed: () async {
            //CachedNetworkImage.evictFromCache(imageUrl, cacheManager: CacheProvider.cacheManager);
            setState(() {
              imageUrl = widget.imageUrl + "&r=${randomAlpha(3)}";
            });
          },
        ),
      ),
    );
  }
}
