import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/base_constant.dart';
import '../../../../data/model/manga_meta_combine.dart';
import '../../presentation/recent/widget/recent_agrs.dart';

part 'recent_state.freezed.dart';

@freezed
class RecentState with _$RecentState {
  const factory RecentState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<RecentArgs> recentArgs,
    @Default(null) MangaMetaCombine? mangaMetaCombine,
    @Default(null) String? error,
  }) = _RecentState;
}
