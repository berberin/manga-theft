import 'package:manga_theft/app/data/model/chapter_info.dart';
import 'package:manga_theft/app/data/model/manga_meta_combine.dart';

class ReaderScreenArgs {
  final List<String>? preloadUrl;
  final MangaMetaCombine metaCombine;
  final List<ChapterInfo> chaptersInfo;
  final int index;

  ReaderScreenArgs(
      {this.preloadUrl,
      required this.metaCombine,
      required this.chaptersInfo,
      this.index = 0});
}
