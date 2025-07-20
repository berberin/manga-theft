import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/base_constant.dart';
import '../../../data/model/chapter_info.dart';
import '../../../data/model/manga_meta_combine.dart';

part 'manga_detail_state.freezed.dart';

@freezed
class MangaDetailState with _$MangaDetailState {
  const factory MangaDetailState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default(null) MangaMetaCombine? metaCombine,
    @Default(false) bool isFavorite,
    @Default(false) bool isExceptional,
    @Default([]) List<ChapterInfo> chaptersInfo,
    @Default([]) List<bool> readArray,
    @Default(null) String? error,
  }) = _MangaDetailState;
}
