import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';

class CacheService {
  CacheService._();

  static CustomCacheManager cacheManager = CustomCacheManager(Config(
    'imageCacheManager',
    maxNrOfCacheObjects: 350,
    stalePeriod: const Duration(days: 7),
  ));

  static getImage(String url, MangaRepository mangaRepository) {
    cacheManager.downloadFile(
      url,
      authHeaders: mangaRepository.imageHeader(),
    );
  }
}

class CustomCacheManager extends CacheManager {
  CustomCacheManager(Config config) : super(config);
}

// class CustomCacheManager extends CacheManager with ImageCacheManager {
//   CustomCacheManager(Config config) : super(config);
// }
