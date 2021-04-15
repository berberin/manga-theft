import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheProvider {
  CacheProvider._();

  static CustomCacheManager cacheManager = CustomCacheManager(Config(
    'imageCacheManager',
    maxNrOfCacheObjects: 100,
    stalePeriod: const Duration(days: 7),
  ));

  static getImage(String url) {
    cacheManager.downloadFile(
      url,
      authHeaders: {"Referer": "http://www.nettruyen.com/"},
    );
  }
}

class CustomCacheManager extends CacheManager {
  CustomCacheManager(Config config) : super(config);
}

// class CustomCacheManager extends CacheManager with ImageCacheManager {
//   CustomCacheManager(Config config) : super(config);
// }
