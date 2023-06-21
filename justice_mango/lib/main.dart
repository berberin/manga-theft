import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/service/hive_service.dart';
import 'app/data/service/source_service.dart';
import 'app/route/pages.dart';
import 'app/route/routes.dart';
import 'app/theme/app_theme.dart';
import 'app/util/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await HiveService.init();
  await SourceService.init();
  runApp(
    GetMaterialApp(
      // smartManagement: SmartManagement.keepFactory,
      initialRoute: Routes.home,
      getPages: AppPages.pages,
      locale: SourceService.selectedLocale,
      translationsKeys: translationMap,
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    ),
  );
  //runApp(TestApp());
}
