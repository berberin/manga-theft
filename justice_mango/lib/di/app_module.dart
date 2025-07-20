import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/data/service/background_context.dart';
import 'package:manga_theft/app/data/service/cache_service.dart';

import '../app/data/service/hive_service.dart';
import '../app/data/service/source_service.dart';
import '../app/route/app_route.dart';

@module
abstract class AppModule {
  @lazySingleton
  AppRoute get appRouter => AppRoute();

  @lazySingleton
  HiveService initHiveService() {
    return HiveService();
  }

  @lazySingleton
  SourceService initSourceService(AppRoute appRoute, HiveService hiveService) {
    return SourceService(appRoute, hiveService);
  }

  @lazySingleton
  BackgroundContext initBackgroundContext(SourceService sourceService) {
    return BackgroundContext(sourceService);
  }

  @lazySingleton
  CacheService initCacheService() {
    return CacheService();
  }
}
