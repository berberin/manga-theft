import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/modules/home/presentation/home_screen.dart';
import 'package:manga_theft/app/modules/manga_detail/presentation/manga_detail_screen.dart';

import '../data/model/manga_meta_combine.dart';
import '../modules/reader/presentation/reader_screen.dart';
import '../modules/reader/presentation/widget/reader_screen_args.dart';

part 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRoute extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/home', initial: true),
        AutoRoute(page: MangaDetailRoute.page, path: '/manga_detail'),
        AutoRoute(page: ReaderRoute.page, path: '/reader'),
      ];
}
