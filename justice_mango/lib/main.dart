import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/route/pages.dart';
import 'app/route/routes.dart';
import 'app/theme/app_theme.dart';
import 'app/util/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    GetMaterialApp(
      // unknownRoute: GetPage(name: 'notfound', page: () => UnknownRoutePage()),
      initialRoute: Routes.HOME,
      getPages: AppPages.pages,
      //locale: Locale('vi', 'VN'),
      locale: Get.deviceLocale.languageCode == 'vi' ? Locale('vi', 'VN') : Locale('en', 'US'),
      translationsKeys: translationMap,
      debugShowCheckedModeBanner: false,
      theme: appThemeData,
    ),
  );
  //runApp(TestApp());
}
