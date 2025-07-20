import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:manga_theft/app/base/base_constant.dart';

import '../../../../data/model/manga_meta_combine.dart';
import '../../../../data/repository/manga_repository.dart';

part 'board_state.freezed.dart';

@freezed
class BoardState with _$BoardState {
  const factory BoardState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<MangaMetaCombine> listBoardManga,
    @Default([]) List<MangaMetaCombine> listFavoriteUpdateManga,
    @Default(0) int sourceIndex,
    @Default([]) List<MangaRepository> sourceRepositories,
    @Default(null) String? error,
  }) = _BoardState;
}
