import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';
import 'package:manga_theft/app/data/service/cache_service.dart';
import 'package:manga_theft/app/gwidget/loading_widget.dart';
import 'package:random_string/random_string.dart';

import '../../../../../di/injection.dart';

class MangaImage extends StatefulWidget {
  final String imageUrl;
  final MangaRepository repo;

  const MangaImage({super.key, required this.imageUrl, required this.repo});

  @override
  State<MangaImage> createState() => _MangaImageState();
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
      cacheManager: getIt<CacheService>().cacheManager,
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
      progressIndicatorBuilder: (context, url, downloadProgress) => const LoadingWidget(),
      errorWidget: (context, url, error) => Container(
        margin: const EdgeInsets.all(100),
        child: ElevatedButton(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: const Icon(Icons.refresh_rounded),
          ),
          onPressed: () async {
            //CachedNetworkImage.evictFromCache(imageUrl, cacheManager: CacheProvider.cacheManager);
            setState(() {
              imageUrl = "${widget.imageUrl}&r=${randomAlpha(3)}";
            });
          },
        ),
      ),
    );
  }
}
