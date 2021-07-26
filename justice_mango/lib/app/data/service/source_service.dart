import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/data/provider/sources/manganelo/nelo_manga_provider.dart';
import 'package:justice_mango/app/data/provider/sources/nettruyen/nettruyen_manga_provider.dart';
import 'package:justice_mango/app/data/repository/manga_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_context.dart';

class SourceService {
  SourceService._();
  static List<MangaRepository> sourceRepositories = <MangaRepository>[];

  static List<MangaRepository> allSourceRepositories = <MangaRepository>[
    MangaRepository(NettruyenMangaProvider()),
    MangaRepository(NeloMangaProvider()),
    // sources..
  ];

  static Locale selectedLocale;
  static List<Locale> allLocalesSupported = <Locale>[
    Locale('vi', 'VN'),
    Locale('en', 'US'),
  ];

  static init() async {
    selectedLocale = await loadLocale();
    await loadSources();
    for (var repo in sourceRepositories) {
      // init data in background isolate
      await BackgroundContext.initMetadata(repo.slug);
    }
  }

  static addToSource(MangaRepository mangaRepository) async {
    sourceRepositories.add(mangaRepository);
    await saveSources();
    try {
      mangaRepository.initData();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  static removeSource(MangaRepository mangaRepository) {
    if (sourceRepositories.length > 1) {
      sourceRepositories.remove(mangaRepository);
    }
    saveSources();
  }

  static loadSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> sourcesSlug = prefs.getStringList('sources') ?? (['vi>nettruyen>', 'en>manganelo>']);
    for (var slug in sourcesSlug) {
      for (var repo in allSourceRepositories) {
        if (repo.slug == slug) {
          addToSource(repo);
        }
      }
    }
  }

  static saveSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> slugs = sourceRepositories.map((e) => e.slug).toList();
    await prefs.setStringList('sources', slugs);
  }

  static saveLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', selectedLocale.languageCode);
    await prefs.setString('countryCode', selectedLocale.countryCode);
  }

  static Future<Locale> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String langCode = prefs.getString('langCode') ?? (Get.deviceLocale.languageCode == 'vi' ? 'vi' : 'en');
    String countryCode = prefs.getString('countryCode') ?? (Get.deviceLocale.languageCode == 'vi' ? 'VN' : 'US');
    return Locale(langCode, countryCode);
    // Get.deviceLocale.languageCode == 'vi' ? Locale('vi', 'VN') : Locale('en', 'US')
  }

  static changeLocale(Locale locale) {
    selectedLocale = locale;
    saveLocale();
    Get.updateLocale(selectedLocale);
  }

  static MangaRepository getRepo(String repoSlug) {
    for (var repo in allSourceRepositories) {
      if (repo.slug == repoSlug) {
        return repo;
      }
    }
    return null;
  }
}
