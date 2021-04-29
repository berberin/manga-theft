import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/route/routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => Container(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MANGA_DETAIL,
      page: () => Container(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MANGA_DETAIL,
      page: () => Container(),
      transition: Transition.cupertino,
    ),
  ];
}
