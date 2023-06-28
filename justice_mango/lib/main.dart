import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/data/service/hive_service.dart';
import 'app/data/service/source_service.dart';
import 'app/route/routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await HiveService.init();
  await SourceService.init();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: SourceService.allLocalesSupported,
        fallbackLocale: SourceService.selectedLocale,
        path: 'assets/translations',
        useOnlyLangCode: true,
        child: MaterialApp(
          initialRoute: Routes.home,
          locale: SourceService.selectedLocale,
          theme: appThemeData,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      ),
      // GetMaterialApp(
      //   // smartManagement: SmartManagement.keepFactory,
      //   initialRoute: Routes.home,
      //   getPages: AppPages.pages,
      //   locale: SourceService.selectedLocale,
      //   translationsKeys: translationMap,
      //   debugShowCheckedModeBanner: false,
      //   theme: appThemeData,
      //   builder: (context, child) {
      //     final mediaQueryData = MediaQuery.of(context);
      //     return MediaQuery(
      //       data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      //       child: child!,
      //     );
      //   },
      // ),
    ),
  );
  //runApp(TestApp());
}
