import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/home/home_binding.dart';
import 'package:justice_mango/app/modules/home/home_screen.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_binding.dart';
import 'package:justice_mango/app/modules/manga_detail/manga_detail_screen.dart';
import 'package:justice_mango/app/route/routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MANGA_DETAIL,
      page: () => MangaDetailScreen(),
      binding: MangaDetailBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MANGA_DETAIL,
      page: () => Container(),
      transition: Transition.cupertino,
    ),
  ];
}
