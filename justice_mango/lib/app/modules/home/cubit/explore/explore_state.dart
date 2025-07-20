import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/base_constant.dart';
import '../../../../data/model/manga_meta_combine.dart';
import '../../../../data/repository/manga_repository.dart';

part 'explore_state.freezed.dart';

@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default(false) bool isSearchComplete,
    @Default([]) List<MangaMetaCombine> listSearchResultManga,
    @Default([]) List<MangaMetaCombine> listRandomManga,
    @Default([]) List<MangaRepository> sourceRepositories,
    @Default(null) String? error,
  }) = _ExploreState;
}
