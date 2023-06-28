import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justice_mango/app/data/model/manga_meta.dart';
import 'package:justice_mango/app/data/model/manga_meta_combine.dart';
import 'package:justice_mango/app/data/service/hive_service.dart';
import 'package:justice_mango/app/data/service/source_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_tab.dart';

class FavoriteStateData {
  final List<MangaMeta> favoriteMangas;
  final List<MangaMetaCombine> favoriteMetaCombine;
  final FavoriteCardStyle cardStyle;

  final Map<String, String> latestChapters;

  const FavoriteStateData({
    this.favoriteMangas = const <MangaMeta>[],
    this.favoriteMetaCombine = const <MangaMetaCombine>[],
    this.cardStyle = FavoriteCardStyle.shortMangaCard,
    this.latestChapters = const <String, String>{},
  });

  FavoriteStateData copyWith({
    List<MangaMeta>? favoriteMangas,
    List<MangaMetaCombine>? favoriteMetaCombine,
    FavoriteCardStyle? cardStyle,
    Map<String, String>? latestChapters,
  }) {
    return FavoriteStateData(
      favoriteMangas: favoriteMangas ?? this.favoriteMangas,
      favoriteMetaCombine: favoriteMetaCombine ?? this.favoriteMetaCombine,
      cardStyle: cardStyle ?? this.cardStyle,
      latestChapters: latestChapters ?? this.latestChapters,
    );
  }
}

const String favoriteCardStyleKey = "favorite_card_type";
const String shortMangaCard = "short_manga_card";
const String shortMangaBar = "short_manga_bar";

class FavoriteStateNotifier extends StateNotifier<FavoriteStateData> {
  late SharedPreferences? sharedPreferences;

  FavoriteStateNotifier() : super(const FavoriteStateData()) {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      if (sharedPreferences?.getString(favoriteCardStyleKey) == shortMangaBar) {
        state = state.copyWith(cardStyle: FavoriteCardStyle.shortMangaBar);
      }
      if (sharedPreferences?.getString(favoriteCardStyleKey) ==
          shortMangaCard) {
        state = state.copyWith(cardStyle: FavoriteCardStyle.shortMangaCard);
      }
    });
    refreshUpdate();
  }

  refreshUpdate() async {
    var favoriteMetas = HiveService.favoriteBox.values.toList();
    List<MangaMetaCombine> favoriteMetaCombine = [];
    for (var mangaMeta in favoriteMetas) {
      for (var repo in SourceService.allSourceRepositories) {
        if (mangaMeta.repoSlug == repo.slug) {
          favoriteMetaCombine.add(MangaMetaCombine(repo, mangaMeta));
          break;
        }
      }
    }
    //sorting
    // for (var meta in favoriteMetaCombine) {
    //   print(meta.mangaMeta.title);
    // }
    favoriteMetaCombine.sort(
        (a, b) => (a.mangaMeta.title?.compareTo(b.mangaMeta.title ?? '')) ?? 0);
    // print("--");
    // for (var meta in favoriteMetaCombine) {
    //   print(meta.mangaMeta.title);
    // }
    state = state.copyWith(favoriteMetaCombine: favoriteMetaCombine);
  }

  changeFavoriteCardStyle() {
    if (state.cardStyle == FavoriteCardStyle.shortMangaCard) {
      state = state.copyWith(cardStyle: FavoriteCardStyle.shortMangaBar);
      sharedPreferences?.setString(favoriteCardStyleKey, shortMangaBar);
    } else {
      state = state.copyWith(cardStyle: FavoriteCardStyle.shortMangaCard);
      sharedPreferences?.setString(favoriteCardStyleKey, shortMangaCard);
    }
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteStateNotifier, FavoriteStateData>(
        (ref) => FavoriteStateNotifier());
