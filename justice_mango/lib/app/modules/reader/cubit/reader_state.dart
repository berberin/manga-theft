import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/base_constant.dart';
import '../../../data/model/chapter_info.dart';
import '../../../data/model/manga_meta_combine.dart';

part 'reader_state.freezed.dart';

@freezed
class ReaderState with _$ReaderState {
  const factory ReaderState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<ChapterInfo> chaptersInfo,
    @Default(0) int currentIndex,
    @Default(null) MangaMetaCombine? metaCombine,
    @Default([]) List<String> preloadUrl,
    @Default([]) List<String> imgUrls,
    // @Default([]) Rx<bool> hasError;
    // late Rx<bool> loading;
    @Default(null) String? error,
  }) = _ReaderState;
}
