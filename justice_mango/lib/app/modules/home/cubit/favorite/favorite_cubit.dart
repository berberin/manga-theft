import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';
import 'package:manga_theft/app/data/service/hive_service.dart';
import 'package:manga_theft/app/data/service/source_service.dart';
import 'package:manga_theft/app/modules/home/cubit/favorite/favorite_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manga_theft/app/base/base_constant.dart';

@injectable
class FavoriteCubit extends Cubit<FavoriteState> {
  final HiveService hiveService;
  final SourceService sourceService;

  FavoriteCubit(this.hiveService, this.sourceService) : super(const FavoriteState());

  RefreshController refreshController = RefreshController(initialRefresh: false);
  late SharedPreferences sharedPreferences;

  void init() {
    try {
      emit(state.copyWith(status: BaseStatus.loading));
      SharedPreferences.getInstance().then((value) {
        sharedPreferences = value;
        late FavoriteCardStyle cardStyle;
        if (sharedPreferences.getString(favoriteCardStyleKey) == FavoriteCardStyle.shortMangaBar.value) {
          cardStyle = FavoriteCardStyle.shortMangaBar;
        } else {
          cardStyle = FavoriteCardStyle.shortMangaCard;
        }
        emit(state.copyWith(cardStyle: cardStyle));
      });
      refreshUpdate();
      emit(state.copyWith(status: BaseStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.failed, error: e.toString()));
    }
  }

  void refreshUpdate() async {
    var favoriteMetas = hiveService.favoriteBox.values.toList();
    // clear favorite meta
    emit(state.copyWith(listFavoriteMetaCombine: []));
    List<MangaMetaCombine> favoriteMetaCombine = [];
    for (var mangaMeta in favoriteMetas) {
      for (var repo in sourceService.allSourceRepositories) {
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
    favoriteMetaCombine.sort((a, b) => (a.mangaMeta.title?.compareTo(b.mangaMeta.title ?? '')) ?? 0);
    // print("--");
    // for (var meta in favoriteMetaCombine) {
    //   print(meta.mangaMeta.title);
    // }
    emit(state.copyWith(listFavoriteMetaCombine: favoriteMetaCombine));
  }

  void changeFavoriteCardStyle() {
    FavoriteCardStyle cardStyle = state.cardStyle;
    if (cardStyle == FavoriteCardStyle.shortMangaCard) {
      cardStyle = FavoriteCardStyle.shortMangaBar;
    } else {
      cardStyle = FavoriteCardStyle.shortMangaCard;
    }
    sharedPreferences.setString(favoriteCardStyleKey, cardStyle.value);
  }

  void updateLastestChapter(String lastestKey, String? chapterName) {
    Map<String, String> lastestChapters = state.latestChapters;
    lastestChapters[lastestKey] = chapterName ?? '';
    emit(state.copyWith(latestChapters: lastestChapters));
  }
}
