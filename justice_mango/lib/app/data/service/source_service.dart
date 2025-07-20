import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manga_theft/app/data/provider/sources/mango_collector/mango_coll_manga_provider.dart';
import 'package:manga_theft/app/data/repository/manga_repository.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route/app_route.dart';
import 'background_context.dart';

class SourceService {
  final AppRoute appRoute;
  final HiveService hiveService;

  SourceService(this.appRoute, this.hiveService);

  List<MangaRepository> sourceRepositories = <MangaRepository>[];
  late List<MangaRepository> allSourceRepositories;

  BuildContext? get context => appRoute.navigatorKey.currentContext;
  late Locale selectedLocale;
  List<Locale> allLocalesSupported = <Locale>[
    const Locale('vi', 'VN'),
    const Locale('en', 'US'),
  ];

  Future<void> init() async {
    selectedLocale = await loadLocale();
    allSourceRepositories = <MangaRepository>[
      MangaRepository(MangoCollMangaProvider(), hiveService),
      // MangaRepository(NettruyenMangaProvider()),
      //   MangaRepository(NeloMangaProvider()),
      // sources..
    ];
    await loadSources();
    for (var repo in sourceRepositories) {
      // init data in background isolate
      BackgroundContext backgroundContext = getIt<BackgroundContext>();
      await backgroundContext.init(repo.slug);
    }
    hiveService.setVersion();
  }

  void addToSource(MangaRepository mangaRepository) async {
    sourceRepositories.add(mangaRepository);
    await saveSources();
    try {
      mangaRepository.initData();
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e);
        print(stacktrace);
      }
    }
  }

  void removeSource(MangaRepository mangaRepository) {
    if (sourceRepositories.length > 1) {
      sourceRepositories.remove(mangaRepository);
    }
    saveSources();
  }

  Future<void> loadSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> sourcesSlug = prefs.getStringList('sources') ?? (['vi>storynap>']);
    for (var slug in sourcesSlug) {
      for (var repo in allSourceRepositories) {
        if (repo.slug == slug) {
          addToSource(repo);
        }
      }
    }
  }

  Future<void> saveSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> slugs = sourceRepositories.map((e) => e.slug).toList();
    await prefs.setStringList('sources', slugs);
  }

  Future<void> saveLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', selectedLocale.languageCode);
    await prefs.setString('countryCode', selectedLocale.countryCode ?? '');
  }

  Future<Locale> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String langCode;
    late String countryCode;
    if (context != null) {
      langCode =
          prefs.getString('langCode') ?? (EasyLocalization.of(context!)?.locale.languageCode == 'vi' ? 'vi' : 'en');
      countryCode =
          prefs.getString('countryCode') ?? (EasyLocalization.of(context!)?.locale.languageCode == 'vi' ? 'VN' : 'US');
    } else {
      langCode = prefs.getString('langCode') ?? 'vi';
      countryCode = prefs.getString('countryCode') ?? 'VN';
    }
    return Locale(langCode, countryCode);
  }

  void changeLocale(Locale locale) {
    if (context != null) {
      EasyLocalization.of(context!)?.setLocale(locale);
      selectedLocale = locale;
      saveLocale();
    } else {
      return;
    }
  }

  MangaRepository getRepo(String repoSlug) {
    for (var repo in allSourceRepositories) {
      if (repo.slug == repoSlug) {
        return repo;
      }
    }
    throw ('No repo slug: $repoSlug');
  }
}
