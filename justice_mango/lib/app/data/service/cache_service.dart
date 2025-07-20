import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';

class CacheService {
  CacheService();

  CustomCacheManager cacheManager = CustomCacheManager(Config(
    'imageCacheManager',
    maxNrOfCacheObjects: 350,
    stalePeriod: const Duration(days: 7),
  ));

  void getImage(String url, MangaRepository mangaRepository) {
    cacheManager.downloadFile(
      url,
      authHeaders: mangaRepository.imageHeader(),
    );
  }
}

class CustomCacheManager extends CacheManager {
  CustomCacheManager(super.config);
}
