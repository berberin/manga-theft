import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:manga_theft/app/base/base_constant.dart';

import '../../../../data/model/manga_meta.dart';
import '../../../../data/model/manga_meta_combine.dart';

part 'favorite_state.freezed.dart';

@freezed
class FavoriteState with _$FavoriteState {
  const factory FavoriteState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<MangaMeta> listFavoriteManga,
    @Default([]) List<MangaMetaCombine> listFavoriteMetaCombine,
    @Default(FavoriteCardStyle.shortMangaCard) FavoriteCardStyle cardStyle,
    @Default({}) Map<String, String> latestChapters,
    @Default(null) String? error,
  }) = _FavoriteState;
}
