import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/data/service/cache_service.dart';

import 'app.dart';
import 'app/data/service/hive_service.dart';
import 'app/data/service/source_service.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  configureDependencies(); // setup DI
  final hiveService = getIt<HiveService>();
  await hiveService.init();
  final sourceService = getIt<SourceService>();
  await sourceService.init();
  getIt<CacheService>();
  runApp(
    EasyLocalization(
      supportedLocales: sourceService.allLocalesSupported,
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}
