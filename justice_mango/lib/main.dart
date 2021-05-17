import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/provider/sources/manganelo/nelo_manga_provider.dart';
import 'app/data/provider/sources/nettruyen/nettruyen_manga_provider.dart';
import 'app/data/repository/manga_repository.dart';
import 'app/data/service/hive_service.dart';
import 'app/data/service/source_service.dart';
import 'app/route/pages.dart';
import 'app/route/routes.dart';
import 'app/theme/app_theme.dart';
import 'app/util/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await HiveService.init();
  // for testing
  SourceService.addToSource(MangaRepository(NettruyenMangaProvider()));
  SourceService.addToSource(MangaRepository(NeloMangaProvider()));
  //SourceService.init();
  runApp(
    GetMaterialApp(
      // smartManagement: SmartManagement.keepFactory,
      initialRoute: Routes.HOME,
      getPages: AppPages.pages,
      // locale: Locale('vi', 'VN'),
      locale: Get.deviceLocale.languageCode == 'vi' ? Locale('vi', 'VN') : Locale('en', 'US'),
      translationsKeys: translationMap,
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
    ),
  );
  //runApp(TestApp());
}
