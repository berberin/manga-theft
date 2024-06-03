import 'package:get/get.dart';
import 'package:manga_theft/app/data/model/manga_meta.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/tab/favorite/favorite_tab.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  var favoriteMangas = <MangaMeta>[];
  var favoriteMetaCombine = <MangaMetaCombine>[].obs;
  var cardStyle = FavoriteCardStyle.shortMangaCard.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late SharedPreferences sharedPreferences;
  var latestChapters = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      if (sharedPreferences.getString(favoriteCardStyleKey) == shortMangaBar) {
        cardStyle.value = FavoriteCardStyle.shortMangaBar;
      }
      if (sharedPreferences.getString(favoriteCardStyleKey) == shortMangaCard) {
        cardStyle.value = FavoriteCardStyle.shortMangaCard;
      }
    });
    refreshUpdate();
  }

  refreshUpdate() async {
    var favoriteMetas = HiveService.favoriteBox.values.toList();
    favoriteMetaCombine.clear();
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
  }

  changeFavoriteCardStyle() {
    if (cardStyle.value == FavoriteCardStyle.shortMangaCard) {
      cardStyle.value = FavoriteCardStyle.shortMangaBar;
      sharedPreferences.setString(favoriteCardStyleKey, shortMangaBar);
    } else {
      cardStyle.value = FavoriteCardStyle.shortMangaCard;
      sharedPreferences.setString(favoriteCardStyleKey, shortMangaCard);
    }
  }
}

const String favoriteCardStyleKey = "favorite_card_type";
const String shortMangaCard = "short_manga_card";
const String shortMangaBar = "short_manga_bar";
